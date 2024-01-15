#pragma once

#include "types.h"

#define SEEK_CUR 0
#define SEEK_SET 1
#define SEEK_END 2

#define SFS_FLAG_READ 0
#define SFS_FLAG_WRITE 1

int sfs_open(const char *path, uint32_t flags);

int sfs_close(int fd);

int sfs_seek(int fd, int off, int fromwhere);

int sfs_read(int fd, char *buf, uint32_t len);

int sfs_write(int fd, char *buf, uint32_t len);

int sfs_get_files(const char* path, char* files[]);