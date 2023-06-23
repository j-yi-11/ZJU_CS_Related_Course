# include <stdio.h>
# include <string.h>
# include <math.h>
# define len 16+1
# define memory_size 65536+1
# define BR_index 0
# define ADD_index 1 
# define LD_index 2 
# define ST_index 3 
# define JSR_index 4 
# define AND_index 5 
# define LDR_index 6 
# define STR_index 7
# define NOT_index 8 
# define LDI_index 9 
# define STI_index 10
# define JMP_index 11
# define LEA_index 12
# define HALT_index 13
char temp[len];/*save the result of the string changed from a number*/
const int imm = 5 ;
const int pcoffset6 = 6 ;
const int pcoffset9 = 9 ;
const int pcoffset11 = 11 ;
typedef enum {
	negative = -1, zero = 0, positive = 1
}condition_code;
condition_code condition;
char memory[memory_size][len];
unsigned short pc = 0, BaseAddress, CurAddress;
short Register[8];
int FindInstruction(char *s)
{
	char ins[5]="\0\0\0\0";
	strncpy(ins, s, 4);
	char Ins[14][5]=
	{
		"0000","0001","0010","0011",
		"0100","0101","0110","0111",
		"1001","1010","1011","1100",
		"1110","1111"	
	};
	for(int i = 0 ; i < 14 ; i++)
		if ( strncmp(s, Ins[i], 4) == 0 )
			return i;
}
/*change the machine code into an unsigned short number*/
unsigned short binary_to_num(char* s)
{
	unsigned short NUM = 0 ;
	int length = strlen(s) ;
	for( int i = 0 ; i < length ; i++ )
	{
		if ( *( s + length - i - 1 ) - '0' )
			NUM += pow(2,i);
	}
	return NUM;
}
void num_to_string(short num)
{
	memset(temp,0,sizeof(temp));
	if(num >= 0){
		for( int i = 15 ; i >= 0 ; i-- )
		{
			temp[i] = num % 2 + '0' ;
			num /= 2;
		}		
	}else{
		num = ~ num ;
		for( int i = 15 ; i >= 0 ; i-- )
		{
			temp[i] = num % 2 + '0' ;
			num /= 2;
			temp[i] = temp[i] == '1' ? '0' : '1' ; 
		}		
	}
	return;
}
short SignExtension(char* s, int size)
{
	short ExtendedNum = 0 ;
	if( *s == '0' )/* positive number*/
	{
		for(int i = 0 ; i < size - 1 ; i++)
		{
			if ( *( s + size - i - 1 ) - '0' )
				ExtendedNum += pow(2, i);
		}
		return ExtendedNum;		
	}
	if( *s == '1' )/* negative number */
	{
		for(int i = 0 ; i < size - 1 ; i++)
		{
			if ( *( s + size - i - 1 ) - '0' == 0 )
				ExtendedNum += pow(2, i);
		}
		return - ExtendedNum - 1;			
	}
}
void InitialRegister()
{
	for( int i = 0 ; i < 8 ; i++ )
		Register[i] = 0x7777;
}
void ChangeConditionCode(short num)
{
	if ( num == 0 ){
		condition = zero ;
	}else if ( num > 0 ){
		condition = positive ;
	}else{
		condition = negative ;
	}	
	return ;
}
void LD(char* s)
{
	char destRegister[4]="\0\0\0";
	strncpy(destRegister, s + 4, 3); 
	short index = binary_to_num(destRegister);/*index of register*/
	char offsetstring[10]="\0\0\0\0\0\0\0\0\0";
	
	strncpy(offsetstring, s + 7, 9); 
	short offset = SignExtension(offsetstring, pcoffset9);
	Register[index] = (short)binary_to_num(memory[pc+offset]);
	/* LD DR,OFF9 -- M[DR] == MEM[BASE+PC+OFF9]*/
	ChangeConditionCode( Register[index] );
	return;
}
void LDI(char* s)
{
	char destRegister[4]="\0\0\0";
	strncpy(destRegister, s + 4, 3); 
	short index = binary_to_num(destRegister);/*index of register*/
	
	char offsetstring[10]="\0\0\0\0\0\0\0\0\0";
	strncpy(offsetstring, s + 7, 9); 
	short offset = SignExtension(offsetstring, pcoffset9);
	Register[index] = (short)binary_to_num(memory[(unsigned short)binary_to_num(memory[pc+offset])]);
	/* LDI DR,OFF9 -- M[DR] == MEM[MEM[PC+OFF9]]*/
	ChangeConditionCode( Register[index] );
	return;
}
void LDR(char* s)
{
	char destRegister[4]="\0\0\0";
	strncpy(destRegister, s + 4, 3); 
	short destindex = binary_to_num(destRegister);/*index of destregister*/
	char sourRegister[4]="\0\0\0";
	strncpy(sourRegister, s + 7, 3); 
	short sourindex = binary_to_num(sourRegister);/*index of sourregister*/
		
	char offsetstring[7]="\0\0\0\0\0\0";
	strncpy(offsetstring, s + 10, 6); 
	short offset = SignExtension(offsetstring, pcoffset6);
	Register[destindex] = (short)binary_to_num(memory[(unsigned short)Register[sourindex]+offset]);
	/*LDR R4, R2, #5 ;R4 ¡ûmem[R2+5]*/
	ChangeConditionCode( Register[destindex] );
	return;
}
void LEA(char* s)
{
	char destRegister[4]="\0\0\0";
	strncpy(destRegister, s + 4, 3); 
	short index = binary_to_num(destRegister);/*index of register*/
	char offsetstring[10]="\0\0\0\0\0\0\0\0\0";
	
	strncpy(offsetstring, s + 7, 9); 
	short offset = SignExtension(offsetstring, pcoffset9);
	Register[index] = (short)(pc+offset);
	/* LEA DR,OFF9 -- M[DR] == PC+OFF9*/
	return;
}
void ST(char* s)
{
	char sourRegister[4]="\0\0\0";
	strncpy(sourRegister, s + 4, 3); 
	short sourindex = binary_to_num(sourRegister);/*index of register*/
	
	char offsetstring[10]="\0\0\0\0\0\0\0\0\0";
	strncpy(offsetstring, s + 7, 9); 
	short offset = SignExtension(offsetstring, pcoffset9);
    num_to_string( Register[sourindex] );
	strncpy(memory[pc+offset], temp, 16);
	/*ST SR,OFF9 -- MEM[PC+OFF9] == MEM[SR]*/
	return;
}
void STI(char* s)
{
	char sourRegister[4]="\0\0\0";
	strncpy(sourRegister, s + 4, 3); 
	short sourindex = binary_to_num(sourRegister);/*index of register*/
	
	char offsetstring[10]="\0\0\0\0\0\0\0\0\0";
	strncpy(offsetstring, s + 7, 9); 
	short offset = SignExtension(offsetstring, pcoffset9);
    num_to_string( Register[sourindex] );
	strncpy( memory[(unsigned short)binary_to_num(memory[pc+offset])], temp, 16);
	/*STI SR,OFF9 -- MEM[MEM[PC+OFF9]] == MEM[SR]
	STI R4, NOT HERE ; mem[mem[NOT HERE]] <-- R4*/
	return;
}
void STR(char* s)
{
	char sourRegister[4]="\0\0\0";
	strncpy(sourRegister, s + 4, 3); 
	short sourindex = binary_to_num(sourRegister);/*index of sourregister*/
	char destRegister[4]="\0\0\0";
	strncpy(destRegister, s + 7, 3); 
	short destindex = binary_to_num(destRegister);/*index of destregister*/
		
	char offsetstring[7]="\0\0\0\0\0\0";
	strncpy(offsetstring, s + 10, 6); 
	short offset = SignExtension(offsetstring, pcoffset6);
	num_to_string( Register[sourindex] );
	strncpy(memory[(unsigned short)Register[destindex]+offset], temp, 16);
	/*STR R4, R2, #5 ; mem[R2+5] ¡û R4*/ 
	return;
}
void NOT(char* s)
{
	char sourRegister[4]="\0\0\0";
	strncpy(sourRegister, s + 7, 3); 
	short sourindex = binary_to_num(sourRegister);/*index of sourregister*/
	char destRegister[4]="\0\0\0";
	strncpy(destRegister, s + 4, 3); 
	short destindex = binary_to_num(destRegister);/*index of destregister*/
	Register[destindex] = ~ Register[sourindex];
	ChangeConditionCode( Register[destindex] );	
	return;	
}
void ADD(char* s) 
{
	char destRegister[4]="\0\0\0";
	strncpy(destRegister, s + 4, 3); 
	short destindex = binary_to_num(destRegister);/*index of destregister*/
	char sourRegister[4]="\0\0\0";
	strncpy(sourRegister, s + 7, 3); 
	short sourindex = binary_to_num(sourRegister);/*index of sourregister*/
		
	if ( *(s + 10) == '1' ){/*immediate number*/
		char imnum[6]="\0";
		strncpy(imnum, s+11, 5);
		short imm5 = SignExtension(imnum, imm);
		Register[destindex] = Register[sourindex] + imm5 ;
		ChangeConditionCode( Register[destindex] );	
	}else{
		char sourRegister2[4]="\0\0\0";
		strncpy(sourRegister2, s + 13, 3); 
		short sourindex2 = binary_to_num(sourRegister2);/*index of sourregister2*/
		Register[destindex] = Register[sourindex] + Register[sourindex2] ;
		ChangeConditionCode( Register[destindex] );	
	}
	return;
}
void AND(char* s) 
{
	char sourRegister[4]="\0\0\0";
	strncpy(sourRegister, s + 7, 3); 
	short sourindex = binary_to_num(sourRegister);/*index of sourregister*/
	char destRegister[4]="\0\0\0";
	strncpy(destRegister, s + 4, 3); 
	short destindex = binary_to_num(destRegister);/*index of destregister*/
		
	if ( *(s + 10) == '1' ){/*immediate number*/
		char imnum[6]="\0";
		strncpy(imnum, s+11, 5);
		short imm5 = SignExtension(imnum, imm);
		Register[destindex] = Register[sourindex] & imm5 ;
		ChangeConditionCode( Register[destindex] );	
	}else{
		char sourRegister2[4]="\0\0\0";
		strncpy(sourRegister2, s + 13, 3); 
		short sourindex2 = binary_to_num(sourRegister2);/*index of sourregister2*/
		Register[destindex] = Register[sourindex] & Register[sourindex2] ;
		ChangeConditionCode( Register[destindex] );	
	}
	return;
}
void BR(char* s)
{
	int can_negative = *(s + 4) == '1' ? 1 : 0;
	int can_zero = *(s + 5) == '1' ? 1 : 0;
	int can_positive = *(s + 6) == '1' ? 1 : 0;
	if ( (condition == negative && can_negative) || (condition == zero && can_zero) 
	|| (condition == positive && can_positive) )/*condition code satisfies the condition*/
	{
		char offsetstring[10]="\0\0\0\0\0\0\0\0\0";
		strncpy(offsetstring, s + 7, 9); 
		short offset = SignExtension(offsetstring, pcoffset9);
		pc += offset;
	}else
		return;
}
void JMP(char* s)
{
	char baseRegister[4]="\0\0\0";
	strncpy(baseRegister, s + 7, 3); 
	short baseindex = binary_to_num(baseRegister);/*index of baseregister*/	
	pc = (unsigned short)Register[baseindex];
	/*JMP R2 ; PC ¡û R2*/
	return ;
}
void JSR(char *s)
{
	Register[7] = pc ;
	if( *(s + 4) == '1' )  /*JSR*/
	{
		char offsetstring[12]="\0\0\0\0\0\0\0\0\0\0\0";
		strncpy(offsetstring, s + 5, 11); 
		short offset = SignExtension(offsetstring, pcoffset11);
		pc += offset;
	}else if( *(s + 4) == '0' )  /*JSRR*/
	{
		char baseRegister[4]="\0\0\0";
		strncpy(baseRegister, s + 7, 3); 
		short baseindex = binary_to_num(baseRegister);/*index of baseregister*/	
		pc = (unsigned short)Register[baseindex];
	}
	/*R7 = PC;
	if (bit[11] == 0)
	PC = BaseR;
	else
	PC=PC + SEXT(PCoffset11);*/
	return;
}
/*judge whether it is HALT instruction 
return value: 1 -- halt ; 0 -- not halt*/
int IsHalt(char* s)
{
	char* halt = "1111000000100101";
	return !strncmp(s,halt,16);
}
int main(void)
{
	char readline[len];
	scanf("%s\n",readline);
	CurAddress = BaseAddress = binary_to_num(readline);	
	strcpy( memory[CurAddress - 1], readline );
	/*memory[BaseAddress-1] stores the machine code that the program starts*/ 
	/*For example, memory[x2fff] == x3000 */
	while( scanf("%s\n",readline) != EOF )
	{
		strcpy( memory[CurAddress++], readline );
	}
	int count = CurAddress - BaseAddress ; /*the number of machine code*/
	/*save the machine code into memory*/
	InitialRegister();
	CurAddress = BaseAddress;
	pc = BaseAddress;
	while( !IsHalt(memory[CurAddress]) )
	{
		pc += 1;
		int instruction_index = FindInstruction(memory[CurAddress]);
		switch(instruction_index)
		{
			case BR_index:
				BR(memory[CurAddress]);break;
			case ADD_index:
				ADD(memory[CurAddress]);break;
			case LD_index:
				LD(memory[CurAddress]);break;
			case ST_index:
				ST(memory[CurAddress]);break;				
			case JSR_index:
				JSR(memory[CurAddress]);break;
			case AND_index:
				AND(memory[CurAddress]);break;
			case LDR_index:
				LDR(memory[CurAddress]);break;
			case STR_index:
				STR(memory[CurAddress]);break;
			case NOT_index:
				NOT(memory[CurAddress]);break;
			case LDI_index:
				LDI(memory[CurAddress]);break;
			case STI_index:
				STI(memory[CurAddress]);break;
			case JMP_index:
				JMP(memory[CurAddress]);break;
			case LEA_index:
				LEA(memory[CurAddress]);break;
			case HALT_index:
				goto print;break;
			default:
				break;
		}
			CurAddress = pc ;
	}
	print:
		for(int i = 0 ; i < 8 ; i++)
			printf("R%d = x%04hX\n", i, Register[i]); 
	return 0;
}
