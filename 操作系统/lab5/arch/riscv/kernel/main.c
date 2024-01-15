#include "sched.h"
#include "stdio.h"
#include "test.h"
#include "sched.h"

int start_kernel() {
  puts("ZJU OSLAB 5 3210103796 储宁奕 3210103803 蒋奕\n");
  
  slub_init();
  task_init();

  // 设置第一次时钟中断
  asm volatile("ecall");
  
  init_test_case();
  call_first_process();
  
  dead_loop();
  return 0;
}
