#pragma once

#include "defs.h"
#include "stdio.h"

struct buf {
  int disk;
  uint32_t blockno;
  uint8_t *data; // at least 4096 byte
};