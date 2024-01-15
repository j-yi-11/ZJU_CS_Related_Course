#ifndef PRINT_ONLY
#include "defs.h"

extern int main();
extern int puts();
extern int put_num();
extern unsigned long long ticks;
extern void clock_set_next_event(void);

void handler_s(uint64_t cause) {
  // TODO
  // interrupt
  // cause 第一位是1--中断，后面表示中断类型
  //debug
  // puts("[DEBUG]:handler_s called------------\n");
  if ( cause & 0x8000000000000000) {
    // supervisor timer interrupt
    // puts("[DEBUG]:cause----\n");
    if ( cause & 0x8000000000000005) {
      // 设置下一个时钟中断
      // puts("[DEBUG]:time interrupt\n");
      clock_set_next_event();
      //打印当前的中断数目
      puts("current number of ticks is ");
      put_num(ticks);
      puts("\n");
      // TODO
    }
  }
}
#endif