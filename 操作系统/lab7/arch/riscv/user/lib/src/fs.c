#include "fs.h"
#include "syscall.h"

int sfs_open(const char *path, uint32_t flags) {
  struct ret_info ret = u_syscall(SFS_OPEN, (uint64_t)path, flags, 0, 0, 0, 0);
  return (int)ret.a0;
}

int sfs_close(int fd) {
  struct ret_info ret = u_syscall(SFS_CLOSE, (uint64_t)fd, 0, 0, 0, 0, 0);
  return (int)ret.a0;
}

int sfs_seek(int fd, int off, int fromwhere) {
  struct ret_info ret = u_syscall(SFS_SEEK, (uint64_t)fd, off, fromwhere, 0, 0, 0);
  return (int)ret.a0;
}

int sfs_read(int fd, char *buf, uint32_t len) {
  struct ret_info ret = u_syscall(SFS_READ, (uint64_t)fd, (uint64_t)buf, len, 0, 0, 0);
  return (int)ret.a0;
}

int sfs_write(int fd, char *buf, uint32_t len) {
  struct ret_info ret = u_syscall(SFS_WRITE, (uint64_t)fd, (uint64_t)buf, len, 0, 0, 0);
  return (int)ret.a0;
}

int sfs_get_files(const char *path, char *files[]) {
  struct ret_info ret = u_syscall(SFS_GET_FILES, (uint64_t)path, (uint64_t)files, 0, 0, 0, 0);
  return (int)ret.a0;
}