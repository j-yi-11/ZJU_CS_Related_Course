.ORIG x3000
AND R0,R0,#0
AND R1,R1,#0
LD R1,STRING

READLINE
    GETC
    OUT  ;ECHO
    STR R0,R1,0
    ADD R1,R1,1
        AND R2,R2,#0
        ADD R2,R2,#-10
        ADD R2,R2,R0
    BRNP READLINE 
;指令字符串存到x3300开始的连续地址，结尾字符为Enter;
LD R1,STRING; R1 字符串数据源指针
AND R0,R0,#0
AND R2,R2,#0
AND R3,R3,#0
AND R4,R4,#0
AND R5,R5,#0
LD R2,STARTQUEUE;  FRONT  -- LEFT 
LD R3,STARTQUEUE;  REAR   -- RIGHT
;OK
ANALYZE
    AND R0,R0,#0
    LDR R0,R1,#0
    ADD R0,R0,#-10
    BRZ BREAK;判断是否读到最后的Enter;
    ADD R0,R0,#10
    ; ADD R1,R1,#1
    
    ;处理PUSH
    AND R5,R5,#0
    LD R5,LEFTPUSH
    ADD R5,R5,R0
    BRZ LEFTPUSHING
    
    AND R5,R5,#0
    LD R5,RIGHTPUSH
    ADD R5,R5,R0
    BRZ RIGHTPUSHING  
    
    ;处理POP
    AND R5,R5,#0
    LD R5,LEFTPOP
    ADD R5,R5,R0
    BRZ LEFTPOPPING    

    AND R5,R5,#0
    LD R5,RIGHTPOP
    ADD R5,R5,R0
    BRZ RIGHTPOPPING 
    
    AFTERPUSH
    AFTERPOP
    LDR R0,R1,#0
    ADD R0,R0,#-10
    BRNP ANALYZE;判断是否读到最后的Enter;



BREAK  
HALT

STARTQUEUE .FILL x3700
STRING     .FILL x3300

;对应ASCII取负数便于操作  OK
LEFTPUSH   .FILL xFFD5;  + == X002B
LEFTPOP    .FILL xFFD3;  - == X002D
RIGHTPUSH  .FILL xFFA5;  [ == X005B
RIGHTPOP   .FILL xFFA3;  ] == X005D

LEFTPUSHING
        ADD R1,R1,#1
        LDR R0,R1,#0
        ADD R2,R2,#-1
        STR R0,R2,#0
        ADD R1,R1,#1
    BRNZP AFTERPUSH
RIGHTPUSHING
        ADD R1,R1,#1
        LDR R0,R1,#0
        STR R0,R3,#0
        ADD R3,R3,#1
        ADD R1,R1,#1
    BRNZP AFTERPUSH
    
LEFTPOPPING
        ; JUDGEEMPTY
        AND R4,R4,#0
        NOT R4,R2
        ADD R4,R4,R3
        ADD R4,R4,#1
        BRZ ISEMPTY        
        ; NOTEMPTY
        LDR R0,R2,#0
        ADD R1,R1,#1
        OUT
        ADD R2,R2,#1
    BRNZP AFTERPOP

RIGHTPOPPING
        ; JUDGEEMPTY
        AND R4,R4,#0
        NOT R4,R2
        ADD R4,R4,R3
        ADD R4,R4,#1
        BRZ ISEMPTY        
        ; NOTEMPTY
        ADD R3,R3,#-1
        LDR R0,R3,#0
        ADD R1,R1,#1
        OUT
    BRNZP AFTERPOP
    
ISEMPTY
        AND R0,R0,#0
        ADD R0,R0,#15
        ADD R0,R0,#15
        ADD R0,R0,#15
        ADD R0,R0,#15
        ADD R0,R0,#15
        ADD R0,R0,#15
        ADD R0,R0,#5
        OUT
        ADD R1,R1,#1
    BRNZP AFTERPOP
.END