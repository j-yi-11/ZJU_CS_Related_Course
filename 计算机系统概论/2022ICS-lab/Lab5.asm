.ORIG x3000
AND R1,R1,0; R1 == N
;读入第一位
GETC
    LD R1,ASCIITONUM
    ADD R1,R0,R1
OUT
; GETNUM读入第2位(如果有)
    GETC
        AND R5,R5,#0
        ADD R5,R5,#-10
        ADD R5,R5,R0;   R5 == ENTER?
        BRz READY1;只有一位
        
        STI R1,SAVER1
        LD R1,ASCIITONUM
        ADD R0,R0,R1; R0 = R0 - 48 ;
        LDI R1,SAVER1
        
        AND R2,R2,#0;  
        ADD R2,R1,R1;R2 = 2 * R1
        AND R4,R4,#0
        ADD R4,R2,R2;R4 = 4 * R1
        ADD R4,R4,R4;R4 = 8 * R1
        ADD R1,R4,R2;R1 = 10 * R1
        ADD R1,R1,R0;
        
        STI R1,SAVER1
        LD R1,ASCIITONUM
        NOT R1,R1
        ADD R1,R1,#1
        ADD R0,R0,R1 ; R0 = R0+48
        LDI R1,SAVER1
    OUT
    BR READY2
READY1 OUT
    BR READY
READY2
    GETC
    OUT
    BR READY
READY
AND R2,R2,0;
AND R4,R4,0;
AND R5,R5,0;
;  R1  十进制储存输入数字
STI R1,N
AND R3,R3,0;R3  每次读入的数
LD R2,STRING;R2  数据存放地址指针
ADD R1,R1,R1


READDATALOOP
    READFIRSTBIT;读入第一位
        ADD R2,R2,1; R2 指针向后一个
        GETC
        OUT
            AND R3,R3,0
            LD R3,ASCIITONUM;R3 = -48
            ADD R3,R0,R3;R3 = R0 - 48
        
    ; 读入第2位(如果有)
        GETC
            AND R5,R5,#0
            ADD R5,R5,#-15
            ADD R5,R5,#-15
            ADD R5,R5,#-2
            ADD R5,R5,R0;   R0 == SPACE ?
            BRz READDATA_NEXT_1
            AND R5,R5,#0
            ADD R5,R5,#-10
            ADD R5,R5,R0;   R0 == ENTER ?
            BRz READDATA_NEXT_1
            
            STI R1,SAVER1
            LD R1,ASCIITONUM
            ADD R0,R0,R1; R0 = R0 - 48;
            LDI R1,SAVER1
            
            STI R2,SAVER2
            AND R2,R2,#0;  
            ADD R2,R3,R3;R2 = 2 * R3
            AND R4,R4,#0
            ADD R4,R2,R2;R4 = 4 * R3
            ADD R4,R4,R4;R4 = 8 * R3
            ADD R3,R4,R2;R3 = 10 * R3
            ADD R3,R3,R0;  R3 = 10 * R3 + R0 ;
            STI R1,SAVER1
            LD R1,ASCIITONUM
            NOT R1,R1
            ADD R1,R1,#1
            ADD R0,R0,R1 ; R0 = R0 + 48 ;
            LDI R1,SAVER1
            LDI R2,SAVER2
            BR READDATA_NEXT_2
    READDATA_NEXT_1
        OUT
        STR R3,R2,0
        BR STORED
    READDATA_NEXT_2
        OUT
        GETC
        OUT
        STR R3,R2,0
        BR STORED
    STORED
        ADD R1,R1,#-1
BRP READDATALOOP


LDI R1,N; R1 = N
LD R2,STRING;R2  数据存放地址指针

AND R0,R0,0
ADD R0,R0,R1; R0 == N
AND R3,R3,0
ADD R3,R3,1
AND R4,R4,0
AND R5,R5,0
LD R4,NUM
INITIAL
    STR R3,R4,0
    ADD R5,R5,R3
    ADD R4,R4,1
    ADD R3,R3,R3
    ADD R0,R0,#-1
    BRP INITIAL
LD R4,NUM
ADD R4,R4,#-1
STR R5,R4,0
;  X6010  0111 1111 1111 1111
;  X6011 - X601F  各位为1其他为0
;NUM 构造完成

    LDI R1,N
    ADD R1,R1,R1; R1 == 2*N
    STI R0,SAVER00
    CONTINUE_
        LD R0,STRING
        ADD R0,R0,#0
        LD R2,MODIFIED; R2 == x5011
        ADD R2,R2,#0
        ADD R0,R0,R1
        ADD R2,R2,R1
        STI R3,SAVER33
        LDR R3,R0,0
        STR R3,R2,0
        LDI R3,SAVER33
        ADD R1,R1,#-1
        BRZP CONTINUE_
    LDI R0,SAVER00    
    
    ;复位 x5031
AND R3,R3,0
AND R0,R0,#0
LDI R0,N
AND R5,R5,#0
LDI R1,N; R1 = N
LD R2,STRING;R2  数据存放地址指针
ADD R2,R2,#1
LOOP1
    LDR R4,R2,0; R4 == OFFSET
    ADD R2,R2,#2
    LD R5,NUM
    ADD R5,R5,#-1
    ADD R5,R5,R4;
    LDR R1,R5,0
    AND R6,R1,R3
    BRZ PLUS 
    AFTER_PLUS
    ADD R0,R0,#-1
    BRP LOOP1
STI R3,ORIGIN;  X600F
;OK TESTED; 

AND R0,R0,#0
AND R1,R1,#0
AND R2,R2,#0
AND R3,R3,#0
AND R4,R4,#0
AND R5,R5,#0
LDI R1,N
LDI R0,SUCCEED;  R0 == 2^N - 1

; ADD R0,R0,#1
MAIN; R0 : 2^N - 1 -> 1
    LDI R3,N
    INNER; R3 : N -> 1
        STI R0,SAVER0
        LD R5,NUM
        ADD R5,R5,R3
        ADD R5,R5,#-1
        LDR R5,R5,#0; R5 == MEM[NUM+R3]
        AND R6,R6,#0
        AND R6,R0,R5
        BRNP SWAP
        AFTER_SWAP
        LDI R0,SAVER0
        ADD R3,R3,#-1
        BRP INNER
    ; AFTER_JUDGE    
    BR JUDGE_SUCCESS
        FAIL
    BR NORMAL;复位到x5031;
    RETURN_NORMAL
    LDI R0,SAVER0
    ADD R0,R0,#-1
    BRP MAIN
    
OK
LDI R1,N
LD R2,MODIFIED
PRINTLOOP
    LDR R3,R2,1
    ADD R3,R3,#-10
    BRZP DOUBLE
    BRN SINGLE
    AFTER_ONE_NUMBER
    AND R0,R0,#0
    ADD R0,R0,#15
    ADD R0,R0,#15
    ADD R0,R0,#2
    OUT
    ADD R2,R2,#2
    ADD R1,R1,#-1
    BRP PRINTLOOP
HALT
ASCIITONUM  .FILL xFFD0; -48
STRING      .FILL x5000;  第一个元素的前一个位置,输入原始数据
MODIFIED    .FILL x5031;  复位数据
SAVER555    .FILL x5FF5
SAVER333    .FILL x5FF3
SAVER222    .FILL x5FF0
SAVER000    .FILL x5FF1
SAVER33     .FILL x5FFC
SAVER00     .FILL x5FFF
SAVER0      .FILL x5FFE
SAVER1      .FILL x6001
SAVER2      .FILL x6002
SAVER3      .FILL x6003
SAVER4      .FILL x6004
SAVER5      .FILL x6005
N           .FILL x6000
ORIGIN      .FILL x600F;
SUCCEED     .FILL x6010
NUM         .FILL x6011; MEM[NUM-1] == 0111 1111 1111 1111
STACK       .FILL x9000

PLUS
    ADD R3,R3,R1
    BR AFTER_PLUS
    
NORMAL; MODIFIED复位OK
    LDI R1,N
    ADD R1,R1,R1; R1 == 2*N
    STI R0,SAVER00
    CONTINUE
        LD R0,STRING
        ADD R0,R0,#0
        LD R2,MODIFIED; R2 == x5011
        ADD R2,R2,#0
        ADD R0,R0,R1
        ADD R2,R2,R1
        STI R3,SAVER33
        LDR R3,R0,0
        STR R3,R2,0
        LDI R3,SAVER33
        ADD R1,R1,#-1
        BRZP CONTINUE
    LDI R0,SAVER00    
    BR RETURN_NORMAL
    
    
JUDGE_SUCCESS; OK TESTED
    LDI R1,N
    STI R0,SAVER000
    STI R5,SAVER555
        LDI R2,SUCCEED
        GOON
            AND R6,R6,0
            ADD R6,R6,R1
            ADD R6,R6,R1
            ADD R6,R6,#-1
            
            LD R0,MODIFIED; R0 == X5031
            ADD R0,R0,R6
            LDR R0,R0,0; R0 == MODIFIED[2R1-1]    1<=R0<=N
            
            LD R4,NUM
            ADD R4,R4,#-1
            ADD R4,R4,R0
            LDR R4,R4,0; R4 == MEM[MODIFIED+R0]
            AND R5,R4,R2
            BRZ FAIL
            BRNP PROCESS
            AFTER_PROCESS
            ADD R1,R1,#-1
        BRP GOON
    LDI R5,SAVER555
    LDI R0,SAVER000
    ADD R2,R2,0
    BRZ OK
    BR FAIL
PROCESS
    NOT R4,R4
    ADD R4,R4,#1
    ADD R2,R2,R4
    BR AFTER_PROCESS
    
SWAP 
    LD R5,MODIFIED;
    ADD R5,R5,R3
    ADD R5,R5,R3
    ADD R5,R5,#-1 ;  R5 == MODIFIED + 2R3 - 1
    LDR R6,R5,#0
    LDR R4,R5,#1
    STR R4,R5,#0
    STR R6,R5,#1
    BR AFTER_SWAP
DOUBLE
    AND R0,R0,#0
    ADD R0,R0,#15
    ADD R0,R0,#15
    ADD R0,R0,#15
    ADD R0,R0,#4
    OUT
    AND R0,R0,#0
    ADD R0,R0,#15
    ADD R0,R0,#15
    ADD R0,R0,#15
    ADD R0,R0,#3    
    ADD R0,R0,R3
    OUT
    BR AFTER_ONE_NUMBER
SINGLE
    AND R0,R0,#0
    ADD R0,R0,#15
    ADD R0,R0,#15
    ADD R0,R0,#15
    ADD R0,R0,#3
    ADD R3,R3,#10
    ADD R0,R0,R3
    OUT
    BR AFTER_ONE_NUMBER
.END