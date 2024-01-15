#ifndef PRINT_ONLY
#include "defs.h"
#include "riscv.h"
volatile unsigned long long ticks;/*ticks*/
// uint64_t ticks = 0;
/*QEMU f=10MHz, 1s~10000000 cycles*/
static uint64_t timebase = 10000000;//

extern struct sbiret sbi_call(uint64_t ext, uint64_t fid, uint64_t arg0, uint64_t arg1,
                       uint64_t arg2, uint64_t arg3, uint64_t arg4,
                       uint64_t arg5);
// 使用 rdtime 汇编指令获得当前 mtime 中的值并返回
// 你并不需要修改该函数
uint64_t get_cycles(void) {
#if __riscv_xlen == 64
  uint64_t n;
  __asm__ __volatile__("rdtime %0" : "=r"(n));
  return n;
#else
  uint32_t lo, hi, tmp;
  __asm__ __volatile__(
      "1:\n"
      "rdtimeh %0\n"
      "rdtime %1\n"
      "rdtimeh %2\n"
      "bne %0, %2, 1b"
      : "=&r"(hi), "=&r"(lo), "=&r"(tmp));
  return ((uint64_t)hi << 32) | lo;
#endif
}

void clock_init(void) {
  puts("ZJU OS LAB 1      Student_ID:3210103803\n");

  // 对 sie 寄存器中的时钟中断位设置（ sie[stie] = 1 ）以启用时钟中断
  set_csr(sie, 32);
  // 设置第一个时钟中断
  uint64_t current_cycles = get_cycles();
  ticks = 0;
  // puts("[DEBUG]:before clock_init \n");
  sbi_call(0,0,current_cycles+timebase,0,0,0,0,0);//sbi_set_timer(current_cycles + timebase);
  // puts("[DEBUG]:after clock_init \n");
}

void clock_set_next_event(void) {
  // 获取当前 cpu cycles 数并计算下一个时钟中断的发生时刻
  uint64_t current_cycles = get_cycles();
  ticks++;
  // 通过调用 OpenSBI 提供的函数触发时钟中断
  sbi_call(0,0,current_cycles+timebase,0,0,0,0,0);// sbi_set_timer(current_cycles + timebase);
}
#endif