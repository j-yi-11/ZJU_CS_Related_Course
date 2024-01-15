#include "syscall.h"

#include "task_manager.h"
#include "stdio.h"
#include "defs.h"


struct ret_info syscall(uint64_t syscall_num, uint64_t arg0, uint64_t arg1, uint64_t arg2, uint64_t arg3, uint64_t arg4, uint64_t arg5) {
    // TODO: implement syscall function
    struct ret_info ret;
    switch (syscall_num) {
        // 172 号系统调用 sys_getpid()：该调用从 current 中获取当前的 pid 放入 a0 中返回，无参数。
        case SYS_GETPID:{
            ret.a0 = getpid();
            break;
        }
        // 64 号系统调用 sys_write(unsigned int fd, const char* buf, size_t count)： 
        // 该调用将用户态传递的字符串打印到屏幕上，此处 
        // fd 为标准输出（用户态程序中仅会传递 1），
        // buf 为用户需要打印的起始地址，
        // count 为字符串长度，
        // 返回打印的字符数。
        case SYS_WRITE:{
            int fd = arg0;
            char* buffer = (char*)arg1;
            int count = arg2;
            if(fd == 1) {
                for(int i = 0; i < count; i++) {
                    putchar(buffer[i]);
                }
            }
            ret.a0 = count;
            break;
        }
    default:
        printf("Unknown syscall! syscall_num = %d\n", syscall_num);
        while(1);
        break;
    }
    return ret;
}