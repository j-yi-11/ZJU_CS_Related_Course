#include "fs.h"
#include "getchar.h"
#include "mm.h"
#include "proc.h"
#include "stdio.h"

int getchar_until_valid();
int strcmp(const char *a, const char *b);
void strcpy(char *a, const char *b);

void path_add_entry(char *path, const char *entry);

int main() {
  char input[64];
  int n = 0, ch;

  char *path = 0x0;
  mmap(0, 1024, PTE_V | PTE_U | PTE_R | PTE_W, 0, 0, 0);
  path[0] = '/';
  path[1] = '.';

  char tmp[10][28];
  char *filename[10];
  for (int i = 0; i < 10; i++)
    filename[i] = tmp[i];

  char *copy = (char *)0x10000;
  mmap(copy, 1024, PTE_V | PTE_U | PTE_R | PTE_W, 0, 0, 0);

  char * content = (char *)0x1000;
  mmap(content, 0x1000, PTE_V | PTE_R | PTE_W | PTE_U, 0, 0, 0);

  printf("fssh support: \n");
  printf("> ls\n");
  printf("> cd (only support): cd .   cd ..   cd filename\n");
  printf("> exit\n");
  printf("> cat filename\n");
  printf("> pwd\n");
  printf("> echo filename content\n");
  printf("> echo dir/filename content\n");

  for (;;) {
    n = 0;

    printf("lab7@oslab: %s $ ", path);
    for (;;) {
      ch = getchar_until_valid();
      printf("%c", ch);

      switch (ch) {
      case '\r' /* enter */:
        // note that: enter_key --> \r\n
        printf("\n");
        goto input_end;
      case 127 /* delete */:
        if (n) {
          n--;
          printf("\b \b");
        }
        break;
      default:
        input[n++] = ch;
      }
    }
  input_end:
    input[n] = '\0';

    if (strcmp(input, "ls") == 0) {
      int len = sfs_get_files(path, filename);
      if (len < 0) {
        printf("ls failed");
        while(1);
      }
      for (int i = 0; i < len; i++)
        printf("%s ", filename[i]);
      printf("\n");
    }

    if (strcmp(input, "pwd") == 0) {
      printf("%s\n", path);
    }

    if (input[0] == 'c' && input[1] == 'd') {
      path_add_entry(path, input + 3);
    }

    if (strcmp(input, "exit") == 0) {
      exit(0);
    }

    if (input[0] == 'c' && input[1] == 'a' && input[2] == 't') {
      strcpy(copy, path);
      path_add_entry(copy, input + 4);
      int fd = sfs_open(copy, SFS_FLAG_WRITE | SFS_FLAG_READ);
      if (fd < 0) {
        printf("%s not found\n", copy);
        continue;
      }
      int len = sfs_read(fd, content, 20);
      for (int i = 0; i < len; i++) {
        printf("%c", content[i]);
      }
      printf("\n");
      sfs_close(fd);
    }

    if (input[0] == 'e' && input[1] == 'c' && input[2] == 'h' && input[3] == 'o') {
      int content_start = 0;
      for (int i = 5; i < n; i++) {
        if (input[i] == ' ') {
          input[i] = '\0';
          content_start = i + 1;
          break;
        }
      }
      strcpy(copy, path);
      path_add_entry(copy, input + 5);
      int fd = sfs_open(copy, SFS_FLAG_WRITE | SFS_FLAG_READ);
      if (fd < 0) {
        printf("%s not found\n", copy);
        continue;
      }
      strcpy(content, input + content_start);
      int len = sfs_write(fd, content, n - content_start);
      for (int i = 0; i < len; i++) {
        printf("%c", content[i]);
      }
      printf("\n");
      sfs_close(fd);
    }
  }
  return 0;
}

void path_add_entry(char *path, const char *entry) {
  while (*path)
    path++;
  *path++ = '/';
  while (*entry) {
    *path++ = *entry++;
  }
  *path = '\0';
}

int strcmp(const char *a, const char *b) {
  while (*a && *b) {
    if (*a < *b)
      return -1;
    if (*a > *b)
      return 1;
    a++;
    b++;
  }
  if (*a && !*b)
    return 1;
  if (*b && !*a)
    return -1;
  return 0;
}

void strcpy(char *a, const char *b) {
  while (*b) {
    *a++ = *b++;
  }
  *a = '\0';
}

int getchar_until_valid() {
  int ch;
  do {
    ch = getchar();
  } while (ch <= 0);
  return ch;
}