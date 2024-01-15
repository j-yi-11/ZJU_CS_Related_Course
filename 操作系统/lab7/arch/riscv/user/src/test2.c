#include "fs.h"
#include "stdio.h"

int main() {
  //
  // test case 1. sfs_open
  //
  printf("\033[32m[sfs_open(/hello, read | write)]\033[0m\n");

  int fd = sfs_open("/hello", SFS_FLAG_READ | SFS_FLAG_WRITE);
  if (fd < 0) {
    printf("sfs_open failed");
    while (1)
      ;
  }
  printf("/hello fd is %d\n", fd);

  //
  // test case 2. sfs_write
  //
  printf("\033[32m[sfs_write(fd, \"hello\", 5)]\033[0m\n");

  char buf[10] = "hello";
  int len = sfs_write(fd, buf, 5);
  if (len != 5) {
    printf("sfs_write failed");
    while (1)
      ;
  }
  printf("/hello write %d bytes\n", len);

  //
  // test case 3. sfs_close
  //
  printf("\033[32m[sfs_close(fd)]\033[0m\n");

  int ret = sfs_close(fd);
  if (ret != 0) {
    printf("sfs_close failed");
    while (1)
      ;
  }
  printf("/hello close\n");

  //
  // test case 4. sfs_seeks
  //
  printf("\033[32m[sfs_seeks(fd, 1, SEEK_SET)]\033[0m\n");

  fd = sfs_open("/hello", SFS_FLAG_READ | SFS_FLAG_WRITE);
  ret = sfs_seek(fd, 1, SEEK_SET);
  if (ret != 0) {
    printf("sfs_seek failed");
    while (1)
      ;
  }
  printf("/hello seek 1 byte from SEEK_SET\n");

  //
  // test case 5. sfs_read
  //
  printf("\033[32m[sfs_read(fd, buf, 10)]\033[0m\n");

  len = sfs_read(fd, buf, 10);
  if (len != 4) {
    printf("sfs_read failed (should be ello)");
    while (1)
      ;
  }
  buf[4] = '\0';
  printf("/hello read %d byte: %s\n", len, buf);
  sfs_close(fd);

  //
  // test case 6. sfs_get_files
  //
  printf("\033[32m[sfs_get_files test]\033[0m\n");

  char tmp[10][28];
  char *filename[10];
  for (int i = 0; i < 10; i++)
    filename[i] = tmp[i];
  len = sfs_get_files("/", filename);
  if (len != 2) {
    printf("sfs_get_files failed (should be . and hello)");
    while (1)
      ;
  }
  for (int i = 0; i < len; i++)
    printf("/%s\n", filename[i]);

  return 0;
}
