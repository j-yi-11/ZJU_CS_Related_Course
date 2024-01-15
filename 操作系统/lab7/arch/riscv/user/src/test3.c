#include "fs.h"
#include "stdio.h"

int memcmp(const char *a, const char *b, int len) {
  while (len--) {
    if (*a != *b)
      return 1;
    a++;
    b++;
  }
  return 0;
}

int main() {
  // write many more hello
  int fd = sfs_open("/test3/big", SFS_FLAG_READ | SFS_FLAG_WRITE);
  if (fd < 0) {
    printf("open file failed!\n");
    while (1)
      ;
  }
  printf("writing ...\n");
  for (int i = 0; i < 4096; i++) {
    int len = sfs_write(fd, "hello ", 6);
    if (len != 6) {
      printf("write file failed!\n");
      while (1)
        ;
    }
  }
  sfs_close(fd);

  // read many more hello
  fd = sfs_open("/test3/big", SFS_FLAG_READ);
  if (fd < 0) {
    printf("open file failed!\n");
    while (1)
      ;
  }
  printf("reading ...\n");
  char buf[10];
  for (int i = 0; i < 4096; i++) {
    int len = sfs_read(fd, buf, 6);
    if (len != 6 || memcmp(buf, "hello ", 6) != 0) {
      printf("read file failed!\n");
      while (1)
        ;
    }
  }
  sfs_close(fd);

  printf("\033[32m[write/read big file pass]\033[0m\n");
  return 0;
}