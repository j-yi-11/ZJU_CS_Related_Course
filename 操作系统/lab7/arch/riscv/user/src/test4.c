#include "fs.h"
#include "stdio.h"
#include "getpid.h"
#include "mm.h"
#include "proc.h"

int main() {
  int ret = fork();
  if (ret == 0) {
    printf("[children process]\n");
    int fd = sfs_open("/children/test_file", SFS_FLAG_READ | SFS_FLAG_WRITE);
    if (fd < 0) {
      printf("children process open file failed\n");
      while(1);
    }
    sfs_write(fd, "hello father process", 21);
    sfs_close(fd);
  } else {
    wait(ret);
    printf("[father process]\n");
    int fd = sfs_open("/children/test_file", SFS_FLAG_READ | SFS_FLAG_WRITE);
    if (fd < 0) {
      printf("father process open file failed\n");
      while(1);
    }
    char buf[30];
    int len = sfs_read(fd, buf, 30);
    if (len != 21) {
      printf("read data error\n");
      while(1);
    }
    printf("children process send \"%s\"\n", buf);
    sfs_close(fd);
  }
  return 0;
}