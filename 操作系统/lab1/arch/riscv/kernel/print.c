#include "defs.h"
extern struct sbiret sbi_call(uint64_t ext, uint64_t fid, uint64_t arg0,
                              uint64_t arg1, uint64_t arg2, uint64_t arg3,
                              uint64_t arg4, uint64_t arg5);

int puts(char *str) {
  int count = 0;
  while(str[count] != '\0'){
      /*SBI_PUTCHAR : 0x1*/
      sbi_call(0x1, 0x0, (uint64_t)str[count], 0, 0, 0, 0, 0);
      count++;
  }
  return 0;
}

int put_num(uint64_t n) {
  int digits = 10;
  int num = n;
  if(n<0){ /*negative*/
    puts("-");
    num = -num;
  }
  if(num<10 && num>=0){
    sbi_call(0x1, 0x0, (uint64_t)('0'+num), 0, 0, 0, 0, 0);
    return 0;
  }
  /* if n = 1234, digits = 1000
      n = 10000, digits = 10000*/
  while(n/digits >= 10)  digits *= 10;
  while(digits!=0){
      /*SBI_PUTCHAR : 0x1*/
      sbi_call(0x1, 0x0, (uint64_t)('0'+num/digits), 0, 0, 0, 0, 0);
      num %= digits;
      digits /= 10;
  }
  return 0;
}