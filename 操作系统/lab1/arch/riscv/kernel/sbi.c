#include "defs.h"
//debug
//extern void puts(char *);
struct sbiret sbi_call(uint64_t ext, uint64_t fid, uint64_t arg0, uint64_t arg1,
                       uint64_t arg2, uint64_t arg3, uint64_t arg4,
                       uint64_t arg5) {
  //puts("[DEBUG]:sbi_call\n");
  struct sbiret ret;
  __asm__ volatile(
    // 汇编指令
    "mv a7, %[ext]\n"
    "mv a6, %[fid]\n"
    "mv a0, %[arg0]\n"
    "mv a1, %[arg1]\n"
    "mv a2, %[arg2]\n"
    "mv a3, %[arg3]\n"
    "mv a4, %[arg4]\n"
    "mv a5, %[arg5]\n"
    "ecall\n"
    "mv %[error], a0\n"
    "mv %[value], a1\n"
    // 输出操作数
    : [error] "=r"(ret.error), [value] "=r"(ret.value)
    //输入操作数
    : [ext] "r"(ext), [fid] "r"(fid), [arg0] "r"(arg0), [arg1] "r"(arg1),
      [arg2] "r"(arg2), [arg3] "r"(arg3), [arg4] "r"(arg4), [arg5] "r"(arg5)
    // 可能影响的寄存器或存储器
    : "a0", "a1", "a2", "a3", "a4", "a5", "a6", "a7"
  );
  return ret;














































  
  // /*binding a0-a7 to reg a0-a7 with asm*/
	// register uint64_t a0 asm ("a0"); 
	// register uint64_t a1 asm ("a1"); 
	// register uint64_t a2 asm ("a2"); 
	// register uint64_t a3 asm ("a3"); 
	// register uint64_t a4 asm ("a4"); 
	// register uint64_t a5 asm ("a5"); 
	// register uint64_t a6 asm ("a6");
	// register uint64_t a7 asm ("a7");

  // /*ext (Extension ID) 放入寄存器 a7 中
  // fid (Function ID) 放入寄存器 a6 中
  // arg0 ~ arg5 放入寄存器 a0 ~ a5 中*/
  // a0 = arg0;
  // a1 = arg1;
  // a2 = arg2;
  // a3 = arg3;
  // a4 = arg4;
  // a5 = arg5;
	// a6 = fid;
  // a7 = ext;
  // /*ecall 之后系统会进入 M 模式
  // 之后 OpenSBI 会完成相关操作*/
  // asm volatile (
	// 	"ecall"
	// 	:"+r" (a0), "+r" (a1) /*output: +r read and write*/
	// 	:"r" (a0),"r" (a1),"r" (a2),"r" (a3),"r" (a4),"r" (a5),"r" (a6),"r" (a7) /*input*/
	// 	:"memory"	/*memory beyond a0-a7 needed*/
	// );
  // /*OpenSBI 的返回结果放在寄存器 a0 ， a1 中
  // a0 为 error code， a1 为返回值*/
  // ret.error = a0;
  // ret.value = a1;
  // return ret;
}
