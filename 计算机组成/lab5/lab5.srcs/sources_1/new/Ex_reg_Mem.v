`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/12 13:48:12
// Design Name: 
// Module Name: Ex_reg_Mem
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Ex_reg_Mem( 
        input clk_EXMem,//寄存器时�?
        input rst_EXMem, //寄存器复�?
        input en_EXMem, //寄存器使�?

		input [31:0] PC_imm_EXMem,	/*PC输入(imm+pc)*/ 
		input valid_in_EXMem,		/*有效*/
		input [31:0] inst_in_EXMem,	/*指令输入*/

        input[31:0] PC_in_EXMem, //PC输入
        input[31:0] PC4_in_EXMem, //PC+4输入
        input [4:0] Rd_addr_EXMem, //写目的寄存器地址输入
        input zero_in_EXMem, //zero
        input[31:0] ALU_in_EXMem, //ALU输入
        input[31:0] Rs2_in_EXMem, //操作�?2输入
        input Branch_in_EXMem, //Beq
        input BranchN_in_EXMem, //Bne
        input MemRW_in_EXMem, //存储器读�?
        input [1:0] Jump_in_EXMem, //Jal
        input [1:0] MemtoReg_in_EXMem, //写回
        input RegWrite_in_EXMem, //寄存器堆读写

		output reg [31:0] PC_imm_out_EXMem,	/*PC输出(imm+pc)*/
		output reg valid_out_EXMem,			/*有效*/
		output reg [31:0] inst_out_EXMem,	/*inst输出*/

        output reg[31:0] PC_out_EXMem, //PC输出
        output reg[31:0] PC4_out_EXMem, //PC+4输出
        output reg[4:0] Rd_addr_out_EXMem, //写目的寄存器输出
        output reg      zero_out_EXMem, //zero
        output reg[31:0] ALU_out_EXMem,        //ALU输出
        output reg[31:0] Rs2_out_EXMem,         //操作�?2输出
        output reg       Branch_out_EXMem,     //Beq
        output reg BranchN_out_EXMem,     //Bne
        output reg MemRW_out_EXMem,       //存储器读�?
        output reg [1:0]Jump_out_EXMem,        //Jal
        output reg [1:0]MemtoReg_out_EXMem, 	  //写回
        output reg RegWrite_out_EXMem    //寄存器堆读写
    ); 
	//For test
    always @(posedge clk_EXMem or posedge rst_EXMem)
		if (rst_EXMem==1) begin
			PC_imm_out_EXMem <= 0;	/*PC输出(imm+pc)*/
			valid_out_EXMem <= 0;	/*有效*/
			inst_out_EXMem <= 0;	/*inst输出*/
		end 
		else if (en_EXMem) begin
			PC_imm_out_EXMem <= PC_imm_EXMem;	/*PC输出(imm+pc)*/
			valid_out_EXMem <= valid_in_EXMem;	/*有效*/
			inst_out_EXMem <= inst_in_EXMem;	/*inst输出*/
		end

    //PC4_out
    always @(posedge clk_EXMem or posedge rst_EXMem)
		if (rst_EXMem==1)  PC4_out_EXMem <= 0;
		else if (en_EXMem) PC4_out_EXMem <= PC4_in_EXMem;
    //PC_out
    always @(posedge clk_EXMem or posedge rst_EXMem)
		if (rst_EXMem==1)  PC_out_EXMem <= 0;
		else if (en_EXMem) PC_out_EXMem <= PC_in_EXMem;
    //Rd_addr寄存�?
    always @(posedge clk_EXMem or posedge rst_EXMem)
		if (rst_EXMem==1)  Rd_addr_out_EXMem <= 0;
		else if (en_EXMem) Rd_addr_out_EXMem <= Rd_addr_EXMem;
    //zero
    always @(posedge clk_EXMem or posedge rst_EXMem)
		if (rst_EXMem==1)  zero_out_EXMem <= 0;
		else if (en_EXMem) zero_out_EXMem <= zero_in_EXMem;

    //ALU_out
    always @(posedge clk_EXMem or posedge rst_EXMem)
		if (rst_EXMem==1)  ALU_out_EXMem <= 0;
		else if (en_EXMem) ALU_out_EXMem <= ALU_in_EXMem;
    //Rs2
    always @(posedge clk_EXMem or posedge rst_EXMem)
		if (rst_EXMem==1)  Rs2_out_EXMem <= 0;
		else if (en_EXMem) Rs2_out_EXMem <= Rs2_in_EXMem;
    //Branch
    always @(posedge clk_EXMem or posedge rst_EXMem)
		if (rst_EXMem==1)  Branch_out_EXMem <= 0;
		else if (en_EXMem) Branch_out_EXMem <= Branch_in_EXMem;
    //BranchN
    always @(posedge clk_EXMem or posedge rst_EXMem)
		if (rst_EXMem==1)  BranchN_out_EXMem <= 0;
		else if (en_EXMem) BranchN_out_EXMem <= BranchN_in_EXMem;
    //MemRW
    always @(posedge clk_EXMem or posedge rst_EXMem)
		if (rst_EXMem==1)  MemRW_out_EXMem <= 0;
		else if (en_EXMem) MemRW_out_EXMem <= MemRW_in_EXMem;
    //Jump
    always @(posedge clk_EXMem or posedge rst_EXMem)
		if (rst_EXMem==1)  Jump_out_EXMem <= 0;
		else if (en_EXMem) Jump_out_EXMem <= Jump_in_EXMem;
    //MemtoReg
    always @(posedge clk_EXMem or posedge rst_EXMem)
		if (rst_EXMem==1)  MemtoReg_out_EXMem <= 0;
		else if (en_EXMem) MemtoReg_out_EXMem <= MemtoReg_in_EXMem;
    //RegWrite
    always @(posedge clk_EXMem or posedge rst_EXMem)
		if (rst_EXMem==1)  RegWrite_out_EXMem <= 0;
		else if (en_EXMem) RegWrite_out_EXMem <= RegWrite_in_EXMem;
endmodule

