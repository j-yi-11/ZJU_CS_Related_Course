.ORIG  x0200
            LD  R6,  OS_SP
            LD  R0,  USER_PSR;程序状态寄存器;特权模式psr[15]==0,psr[10:8]中断优先级
            ADD  R6,  R6,  #-1
            STR  R0,  R6,  #0;PSR压入栈内
            LD  R0,  USER_PC
            ADD  R6,  R6,  #-1
            STR  R0,  R6,  #0;PC压入栈内
            LD  R0,  KBDEn;ready bit == 1
            STI  R0,  KBSR
            LD  R0,  IntVecter
            LD  R1,  IntService
            STR  R1,  R0,  #0
            RTI
OS_SP       .FILL  x3000
USER_PSR    .FILL  x8002
USER_PC     .FILL  x3000
KBDEn       .FILL  x4000
KBSR        .FILL  xFE00
IntVecter   .FILL  x0180;键盘中断起始地址
IntService  .FILL  x2000
            .END

.ORIG  x2000
            ST  R0,Save
            LEA  R0,Save
            STR  R1,R0,#1
            STR  R3,R0,#2
            STR  R5,R0,#3
            ;R0,R1,R3,R5分别存放在Save开始的四个连续的位置;
            LDI  R1,KBDR;此时R1代表键盘读入字符的ASCII;
            LD  R3,_ASCII_9
            NOT  R3,R3
            ADD  R3,R3,#1; R3 = -57
            ADD  R5,R1,R3
            BRp  IsLetter; ASCII R1 > 57 -> 字母;
IsNumber    LD  R3,_ASCII_9; R3 == 57
            ADD  R3,R3,#-9;  R3 == 48
            NOT  R3,R3
            ADD  R3,R3,#1; R3 = -48
            ADD  R1,R1,R3; 此时R1代表读入的数字
            ADD  R2,R2,R1
            ADD  R2,R2,#1;满足输入1-9就能使得字母串向右移动1-9格
            BR   Restore
IsLetter    ADD  R4,R1,#0;直接把字母存到R4;
            BR   Restore
Restore     LDR  R5,R0,#3
            LDR  R3,R0,#2
            LDR  R1,R0,#1
            LDR  R0,R0,#0
            ;R0,R1,R3,R5分别从在Save开始的四个连续的位置取出,R0只能最后取出，否则地址乱了;
            RTI
Save        .BLKW  4
KBDR        .FILL  xFE02
_ASCII_9    .FILL  x0039; '9' ASCII == 57
            .END



.ORIG  x3000
            LD  R2,  LeftPos         ; R2是字母串最左边和R1的相对位置,初始R2 == 17
            LD  R4,  ASCII_a         ; R4 is the current letter
            ADD  R5,R2,#2;R5 = 19
            NOT  R5,R5
            ADD  R5,R5,#1; R5 = -19
MAIN        AND  R1,R1,#0; R1代表当前一行已经输出字符的个数
            LD  R3,LeftPos
            NOT  R3,R3
            ADD  R3,R3,#1; R3 = -17
            ADD  R3,R2,R3;R3 = R2 - 17
            BRnz  NotRight
            LD  R2,  LeftPos
NotRight    NOT  R3,R2
            ADD  R3,R3,#1; R3 = -R2
PrintLoop   ADD  R0,R1,R5
            BRp  NewLine;已经输出20个字符就应该换行;
            ADD  R0,  R1,  R3
            BRz  PrintLetter;到达字母串的最左边;
PrintPoint  LD  R0,  ASCII_Dot
            OUT
            ADD  R1,  R1,  #1
            BR  PrintLoop
PrintLetter ADD  R0,R4,#0;中断读入的字母存到R0
            OUT
            OUT
            OUT
            ADD  R1,R1,#3
            BR  PrintLoop;一次性输出三个字母后返回;
NewLine     LD  R0,ASCII_Enter
            OUT
            JSR  DELAY ; ENTER 后delay ,一行DELAY一次;
            ADD  R2,R2,#-1
            BRzp  ValidPos
            AND  R2,R2,#0
ValidPos    BR  MAIN

HALT
DELAY       
    LD  R0,DELAYTIME
DELAYING    
    ADD  R0,R0,#-1
    BRp  DELAYING
RET
;
LeftPos     .FILL  #17
ASCII_a     .FILL  x0061
ASCII_Dot   .FILL  x002E
ASCII_Enter .FILL  x000A
DELAYTIME   .FILL  x7FFF
            .END