#include "sched.h"
#include "test.h"
#include "stdio.h"

#define Kernel_Page 0x80210000
#define LOW_MEMORY 0x80211000
#define PAGE_SIZE 4096UL

extern void __init_sepc();

struct task_struct* current;
struct task_struct* task[NR_TASKS];

// If next==current,do nothing; else update current and call __switch_to.
void switch_to(struct task_struct* next) {
  if (current != next) {
    struct task_struct* prev = current;
    current = next;
    __switch_to(prev, next);
  }
}

int task_init_done = 0;
// initialize tasks, set member variables
void task_init(void) {
  puts("task init...\n");

  for(int i = 0; i < LAB_TEST_NUM; ++i) {
    // TODO
    // initialize task[i]
    // get the task_struct based on Kernel_Page and i
    if(i==0){
      task[i] = (struct task_struct*)Kernel_Page;
    }else{
      task[i] = (struct task_struct*)(LOW_MEMORY + (i-1) * PAGE_SIZE); 
    }
    task[i]->state = TASK_RUNNING;
    task[i]->counter = 0;
    task[i]->priority = 5;
    //thread.sp, thread.ra
    task[i]->blocked = 0;
    task[i]->pid = i;
    task[i]->thread.ra = (unsigned long long)__init_sepc;
    task[i]->thread.sp = (unsigned long long)task[i] + PAGE_SIZE;

    printf("[PID = %d] Process Create Successfully!\n", task[i]->pid);
  }
  task_init_done = 1;
}

void call_first_process() {
  // set current to 0x0 and call schedule()
  current = (struct task_struct*)(Kernel_Page + LAB_TEST_NUM * PAGE_SIZE);
  current->pid = -1;
  current->counter = 0;
  current->priority = 0;

  schedule();
}


void show_schedule(unsigned char next) {
  // show the information of all task and mark out the next task to run
  for (int i = 0; i < LAB_TEST_NUM; ++i) {
    if (task[i]->pid == next) {
      printf("task[%d]: counter = %d, priority = %d <-- next\n", i,
             task[i]->counter, task[i]->priority);
    } else {
      printf("task[%d]: counter = %d, priority = %d\n", i, task[i]->counter,
           task[i]->priority);
    }
  }
}

/*jy : SKF pass*/
#ifdef SJF
// simulate the cpu timeslice, which measn a short time frame that gets assigned
// to process for CPU execution
void do_timer(void) {
  if (!task_init_done) return;

  printf("[*PID = %d] Context Calculation: counter = %d,priority = %d\n",
         current->pid, current->counter, current->priority);
  
  // current process's counter -1, judge whether to schedule or go on.
  // TODO 
  if (current == 0) //NULL
    return;
  printf("do timer sjf: current->pid = %d current->counter = %d\n",current->pid,current->counter);
  current->counter--;
  if (current->counter <= 0)
  {
    schedule();
  }
  // if(current->counter == 1){
  //   current->counter--;// 0
  //   schedule();
  // }else if(current->counter == 0){
  //   schedule();
  // }else{ //counter >= 2
  //   current->counter--;
  // }
}


// Select the next task to run. If all tasks are done(counter=0), reinitialize all tasks.
void schedule(void) {
  unsigned char next = 0;
  // TODO
  unsigned long min_counter = 0x7FFF; // 0x7FFF
  char all_task_counter_is_zero = 1;
  // 遍历进程指针数组 `task`，
  // 从 `LAST_TASK` 至 `FIRST_TASK`，
  // 在所有运行状态(TASK_RUNNING)下的进程剩余运行时间最小的进程作为下一个执行的进程。
  // 若剩余运行时间相同，则按照遍历的顺序优先选择。
  for(int i = NR_TASKS - 1; i >= 0 ; i--){ // 从 LAST_TASK 至 FIRST_TASK
    if(task[i] != 0){ //NULL 
      if (task[i]->state == TASK_RUNNING && task[i]->counter > 0){
        all_task_counter_is_zero = 0;
        // find min counter
        if (task[i]->counter < min_counter) {
          min_counter = task[i]->counter;
          next = i;
        }
      }
    }
  }

  if(all_task_counter_is_zero == 1){
    init_test_case();
    //schedule();
    for(int i = NR_TASKS - 1; i >= 0 ; i--){ // 从 LAST_TASK 至 FIRST_TASK
      if(task[i] != 0){ //NULL 
        if (task[i]->state == TASK_RUNNING && task[i]->counter > 0){
          all_task_counter_is_zero = 0;
          // find min counter
          if (task[i]->counter < min_counter) {
            min_counter = task[i]->counter;
            next = i;
          }
        }
      }
    }
  }else{
    // do nothing
  }
  printf("------------------schedule : next = %d ---------------------\n",next);
  show_schedule(next);
  
  switch_to(task[next]);
}

#endif
/*jy PRI ok*/
#ifdef PRIORITY

// simulate the cpu timeslice, which measn a short time frame that gets assigned
// to process for CPU execution
void do_timer(void) {
  if (!task_init_done) return;
  
  printf("[*PID = %d] Context Calculation: counter = %d,priority = %d\n",
         current->pid, current->counter, current->priority);
  
  // current process's counter -1, judge whether to schedule or go on.
  // TODO
  if (current == 0) // NULL
    return;
  printf("do timer pri: current->pid = %d current->priority = %d\n",current->pid,current->priority);
  current->counter--;
  printf("do timer pri: current->pid = %d current->counter = %d\n",current->pid,current->counter);
    schedule();
  // current->counter--;
  // if(current->counter == 1){
  //   current->counter--;// 0
  //   schedule();
  // }else if(current->counter == 0){
  //   schedule();
  // }else{ //counter >= 2
  //   current->counter--;
  // }
}

// Select the task with highest priority and lowest counter to run. If all tasks are done(counter=0), reinitialize all tasks.
void schedule(void) {
  unsigned char next;
  // TODO
  unsigned long long min_counter = 0x7FFF;
  unsigned long long high_priority = 0x7FFF;
  char all_task_counter_is_zero = 1;
  // 遍历进程指针数组 task，从 LAST_TASK 至 FIRST_TASK，调度规则如下：
  // • 高优先级的进程，优先被运行（值越小越优先）。
  // • 若优先级相同，则选择剩余运行时间少的进程（若剩余运行时间也相同，则按照遍历的顺序优先选择）。
  // 如果所有运行状态下的进程剩余运行时间都为 0，则通过 init_test_case() 函数重新为进程分配运行时间与优先级，然后再次调度。
  next = NR_TASKS - 1;
  for(int i = NR_TASKS - 1; i >= 0 ;i--){ // 从 LAST_TASK 至 FIRST_TASK
    if(task[i] != 0){ // not NULL
      if (task[i]->state == TASK_RUNNING && task[i]->counter > 0){
        all_task_counter_is_zero = 0;
        // find high priority
        if (task[i]->priority < high_priority) { // 优先被运行（值越小越优先）
          high_priority = task[i]->priority;
          min_counter = task[i]->counter;
          next = i;
          // printf("high_priority = %d  next = %d\n",high_priority,next);
          continue;
        }
        // find min counter
        else if((task[i]->priority == high_priority) && (task[i]->counter < min_counter)){
          min_counter = task[i]->counter;
          next = i;
          printf("min_counter = %d  next = %d\n",min_counter,next);
          continue;
        }       
      }
    }
    // next_step:
  }  
  if(all_task_counter_is_zero == 1){
    init_test_case();
    // schedule();
    min_counter = 0x7FFF;
    high_priority = 0xFF;
    for(int i = NR_TASKS - 1; i >= 0 ;i--){ // 从 LAST_TASK 至 FIRST_TASK
      if(task[i] != 0){ // not NULL
        if (task[i]->state == TASK_RUNNING && task[i]->counter > 0){
          all_task_counter_is_zero = 0;
          // find high priority
          if (task[i]->priority < high_priority) { // // 优先被运行（值越小越优先）
            high_priority = task[i]->priority;
            min_counter = task[i]->counter;
            next = i;
            continue;
          }
          // find min counter
          else if((task[i]->priority == high_priority) && (task[i]->counter < min_counter)){
            min_counter = task[i]->counter;
            next = i;
            continue;
          }       
        }
      }
    }
  }else{
    // do nothing
  }
  printf("------------------schedule : next = %d ---------------------\n ",next);
  show_schedule(next);

  switch_to(task[next]);
}

#endif