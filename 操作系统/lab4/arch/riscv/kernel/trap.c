#include "defs.h"
#include "sched.h"
#include "test.h"
#include "syscall.h"
#include "stdio.h"

void handler_s(uint64_t cause, uint64_t epc, uint64_t sp) {
  // interrupt
  if (cause >> 63 == 1) {
    // supervisor timer interrupt
    if (cause == 0x8000000000000005) {
      asm volatile("ecall");
      ticks++;
      if (ticks % 10 == 0) {
        do_timer();
      }
    }
  }
  // exception
  else if (cause >> 63 == 0) {
    // instruction page fault
    if (cause == 0xc) {
      printf("Instruction page fault! epc = 0x%016lx\n", epc);
      while (1);
    }
    // load page fault
    else if (cause == 0xd) {
      printf("Load page fault! epc = 0x%016lx\n", epc);
      while (1);
    }
    // Store/AMO page fault
    else if (cause == 0xf) {
      printf("Store/AMO page fault! epc = 0x%016lx\n", epc);
      while (1);
    }
    // TODO: syscall from user mode
    else if (cause == 0x8) {
      // TODO: 根据我们规定的接口规范，从a7中读取系统调用号，然后从a0~a5读取参数，调用对应的系统调用处理函数，最后把返回值保存在a0~a1中。
      //       注意读取和修改的应该是保存在栈上的值，而不是寄存器中的值，因为寄存器上的值可能被更改。
      // 提示，可以用(uint64_t*)(sp)得到一个数组
      uint64_t *sp_ptr_array = (uint64_t*)(sp);
      // 1. 从 a7 中读取系统调用号
      uint64_t system_call_number = sp_ptr_array[11];
      // 2. 从 a0 ~ a5 中读取系统调用参数
      uint64_t arg0 = sp_ptr_array[4];
      uint64_t arg1 = sp_ptr_array[5];
      uint64_t arg2 = sp_ptr_array[6];
      uint64_t arg3 = sp_ptr_array[7];
      uint64_t arg4 = sp_ptr_array[8];
      uint64_t arg5 = sp_ptr_array[9];
      // 2. 调用syscall()
      struct ret_info ret = syscall(system_call_number, arg0, arg1, arg2, arg3, arg4, arg5);
      // 并把返回值保存到 a0,a1 中
      sp_ptr_array[4] = ret.a0;
      sp_ptr_array[5] = ret.a1;
      // 3. sepc += 4，注意应该修改栈上的sepc，而不是sepc寄存器
      sp_ptr_array[16] += 4;
    }
    else {
      printf("Unknown exception! epc = 0x%016lx\n", epc);
      while (1);
    }
  }
  return;
}
