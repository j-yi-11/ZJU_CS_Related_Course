#include "sched.h"
#include "defs.h"
#include "stdio.h"
#include "clock.h"
#define TEST_CASE_NUMBER 5
// 该变量更改任务的时间片与优先级，同学们可以进行修改，自己的算法运行是否符合预期
// 建议多检测些边界条件，例如优先级时间片均相同的情况。
int counter_priority[TEST_CASE_NUMBER][LAB_TEST_NUM][2] = {
  {
    {1, 4}, {4, 5}, {3, 2}, {4, 1}, {5, 4}
  },
  {
    {3, 1}, {2, 1}, {4, 1}, {1, 1}, {1, 2}
  },
  {
    {1, 1}, {1, 1}, {1, 1}, {1, 1}, {1, 1}
  },
  {
    {1, 1}, {3, 1}, {0, 1}, {4, 1}, {2, 1}
  },
  {
    {1, 5}, {1, 2}, {1, 4}, {1, 1}, {1, 1}
  }
};

void init_test_case() {
  printf("init_test_case called\n");
  static int c_p_i = 0;
  for (int i = 0; i <= LAB_TEST_NUM - 1; i++) {
    task[i]->counter = counter_priority[c_p_i][i][0];
    task[i]->priority = counter_priority[c_p_i][i][1];
  }
  c_p_i++;
  if(c_p_i == TEST_CASE_NUMBER + 1){
    printf("test end\n");
    // show the ticks
    printf("ticks: %d\n", ticks);
    while(1);
  }
}

// 该函数用于批改系统对同学们的代码进行批改，同学们也可修改该文件中的任意代码改变输出进行自测。
int test() {
  while(1);
  return 0;
}

