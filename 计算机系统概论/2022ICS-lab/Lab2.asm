.ORIG x3000
AND R0,R0,#0
AND R2,R2,#0
AND R3,R3,#0
AND R4,R4,#0
GETC
    ADD R0,R0,#-10
    ADD R0,R0,#-10
    ADD R0,R0,#-10
    ADD R0,R0,#-10
    ADD R0,R0,#-8
    ADD R3,R0,#0
        ADD R0,R0,#10
        ADD R0,R0,#10
        ADD R0,R0,#10
        ADD R0,R0,#10
        ADD R0,R0,#8    
OUT
GETNUM
    GETC
        AND R5,R5,#0
        ADD R5,R5,#-10
        ADD R5,R5,R0;   R5  ENTER?
        BRz TRAN
        
        ;MULTI

        ADD R0,R0,#-10
        ADD R0,R0,#-10
        ADD R0,R0,#-10
        ADD R0,R0,#-10
        ADD R0,R0,#-8

        AND R2,R2,#0;  
        ADD R2,R3,R3;R2 = 2 * R3
        AND R4,R4,#0
        ADD R4,R2,R2;R4 = 4 * R3
        ADD R4,R4,R4;R4 = 8 * R3
        ADD R3,R4,R2;R3 = 10 * R3

        ADD R3,R3,R0
        
        ADD R0,R0,#10
        ADD R0,R0,#10
        ADD R0,R0,#10
        ADD R0,R0,#10
        ADD R0,R0,#8    
    OUT
ADD R5,R5,#0
BRnp GETNUM
;  R3  十进制储存输入数字结果

TRAN 
    
    AND R0,R0,#0
    ADD R0,R0,#10
    OUT;先输出一个换行符
    AND R0,R0,#0
    AND R1,R1,#0
    ADD R1,R1,#8   ; R1 = 2 ^ 3
    ADD R1,R1,R1; 4
    ADD R1,R1,R1; 5
    ADD R1,R1,R1; 6 
    ADD R1,R1,R1; 7
    ADD R1,R1,R1; 8
    ADD R1,R1,R1; 9
    ADD R1,R1,R1; 10
    ADD R1,R1,R1; 11
    ADD R1,R1,R1; 12
    ADD R1,R1,R1; 13
    ADD R1,R1,R1; 14
    ADD R1,R1,R1; 15
    
    
    AND R0,R0,#0
    AND R2,R2,#0
    AND R2,R3,R1;
    BRnp ADD1
LABEL1    
ADD R3,R3,R3;
    AND R2,R2,#0
    AND R2,R3,R1;
    BRnp ADD2
LABEL2   
ADD R3,R3,R3;
    AND R2,R2,#0
    AND R2,R3,R1;
    BRnp ADD3
LABEL3   
ADD R3,R3,R3;
    
    AND R2,R2,#0
    AND R2,R3,R1;
    BRnp ADD4
LABEL4  
ADD R3,R3,R3;
    AND R4,R4,#0
    ADD R4,R0,0
    AND R5,R5,#0
    ADD R5,R4,#-10
    BRzp OUTPUTLETTER1; ASCII >= 10
    BRn  OUTPUTDIGIT1
    NEXT1
    OUT




    AND R0,R0,#0
    AND R2,R2,#0
    AND R2,R3,R1;
    BRnp ADD5
LABEL5    
ADD R3,R3,R3;
    AND R2,R2,#0
    AND R2,R3,R1;
    BRnp ADD6
LABEL6   
ADD R3,R3,R3;
    AND R2,R2,#0
    AND R2,R3,R1;
    BRnp ADD7
LABEL7   
ADD R3,R3,R3;
    AND R2,R2,#0
    AND R2,R3,R1;
    BRnp ADD8
LABEL8  
ADD R3,R3,R3;
    AND R4,R4,#0
    ADD R4,R0,0
    AND R5,R5,#0
    ADD R5,R4,#-10
    BRzp OUTPUTLETTER2; ASCII >= 10
    BRn  OUTPUTDIGIT2
    NEXT2
    OUT



    AND R0,R0,#0
    AND R2,R2,#0
    AND R2,R3,R1;
    BRnp ADD9
LABEL9    
ADD R3,R3,R3;
    AND R2,R2,#0
    AND R2,R3,R1;
    BRnp ADD10
LABEL10   
ADD R3,R3,R3;
    AND R2,R2,#0
    AND R2,R3,R1;
    BRnp ADD11
LABEL11   
ADD R3,R3,R3;
    AND R2,R2,#0
    AND R2,R3,R1;
    BRnp ADD12
LABEL12  
ADD R3,R3,R3;
    AND R4,R4,#0
    ADD R4,R0,0
    AND R5,R5,#0
    ADD R5,R4,#-10
    BRzp OUTPUTLETTER3; ASCII >= 10
    BRn  OUTPUTDIGIT3
    NEXT3
    OUT
    
    
    AND R0,R0,#0
    AND R2,R2,#0
    AND R2,R3,R1;
    BRnp ADD13
LABEL13    
ADD R3,R3,R3;
    AND R2,R2,#0
    AND R2,R3,R1;
    BRnp ADD14
LABEL14   
ADD R3,R3,R3;
    AND R2,R2,#0
    AND R2,R3,R1;
    BRnp ADD15
LABEL15   
ADD R3,R3,R3;
    AND R2,R2,#0
    AND R2,R3,R1;
    BRnp ADD16
LABEL16  
ADD R3,R3,R3;
    AND R4,R4,#0
    ADD R4,R0,0
    AND R5,R5,#0
    ADD R5,R4,#-10
    BRzp OUTPUTLETTER4; ASCII >= 10
    BRn  OUTPUTDIGIT4
    NEXT4
    OUT    
HALT


ADD1 ADD  R0,R0,#8;X304F
    BRnzp LABEL1
ADD2 ADD  R0,R0,#4
    BRnzp LABEL2
ADD3 ADD  R0,R0,#2
    BRnzp LABEL3
ADD4 ADD  R0,R0,#1
    BRnzp LABEL4
OUTPUTLETTER1 
    ADD R0,R0,#15
    ADD R0,R0,#15
    ADD R0,R0,#15
    ADD R0,R0,#10
    BRnzp NEXT1
OUTPUTDIGIT1
    ADD R0,R0,#15
    ADD R0,R0,#15
    ADD R0,R0,#15
    ADD R0,R0,#3    
    BRnzp NEXT1
    
    
    
    
ADD5 ADD  R0,R0,#8
    BRnzp LABEL5
ADD6 ADD  R0,R0,#4
    BRnzp LABEL6
ADD7 ADD  R0,R0,#2
    BRnzp LABEL7
ADD8 ADD  R0,R0,#1
    BRnzp LABEL8
OUTPUTLETTER2 
    ADD R0,R0,#15
    ADD R0,R0,#15
    ADD R0,R0,#15
    ADD R0,R0,#10
    BRnzp NEXT2
OUTPUTDIGIT2
    ADD R0,R0,#15
    ADD R0,R0,#15
    ADD R0,R0,#15
    ADD R0,R0,#3    
    BRnzp NEXT2
    
    
ADD9 ADD  R0,R0,#8
    BRnzp LABEL9
ADD10 ADD  R0,R0,#4
    BRnzp LABEL10
ADD11 ADD  R0,R0,#2
    BRnzp LABEL11
ADD12 ADD  R0,R0,#1
    BRnzp LABEL12
OUTPUTLETTER3 
    ADD R0,R0,#15
    ADD R0,R0,#15
    ADD R0,R0,#15
    ADD R0,R0,#10
    BRnzp NEXT3
OUTPUTDIGIT3
    ADD R0,R0,#15
    ADD R0,R0,#15
    ADD R0,R0,#15
    ADD R0,R0,#3    
    BRnzp NEXT3   
    
    
ADD13 ADD  R0,R0,#8
    BRnzp LABEL13
ADD14 ADD  R0,R0,#4
    BRnzp LABEL14
ADD15 ADD  R0,R0,#2
    BRnzp LABEL15
ADD16 ADD  R0,R0,#1
    BRnzp LABEL16
OUTPUTLETTER4 
    ADD R0,R0,#15
    ADD R0,R0,#15
    ADD R0,R0,#15
    ADD R0,R0,#10
    BRnzp NEXT4
OUTPUTDIGIT4
    ADD R0,R0,#15
    ADD R0,R0,#15
    ADD R0,R0,#15
    ADD R0,R0,#3    
    BRnzp NEXT4
    
    
.END



