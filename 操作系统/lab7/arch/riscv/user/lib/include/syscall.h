#pragma once

#define SYS_EXIT 60
#define SYS_READ 63
#define SYS_WRITE 64
#define SYS_GETPID 172
#define SYS_EXEC 191
#define SYS_MUNMAP 215
#define SYS_FORK 220
#define SYS_MMAP 222
#define SYS_WAIT 247

#define SFS_OPEN      1001
#define SFS_CLOSE     1002
#define SFS_SEEK      1003
#define SFS_READ      1004
#define SFS_WRITE     1005
#define SFS_GET_FILES 1006

#include "types.h"

struct ret_info {
  uint64_t a0;
  uint64_t a1;
};

struct ret_info u_syscall(uint64_t syscall_num, uint64_t arg0, uint64_t arg1,
                          uint64_t arg2, uint64_t arg3, uint64_t arg4,
                          uint64_t arg5);
