`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/12 13:49:14
// Design Name: 
// Module Name: ID_reg_Ex
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

module ID_reg_Ex( 
        input clk_IDEX, //寄存器时�?
        input rst_IDEX, //寄存器复�?
        input en_IDEX, //寄存器使�?

		input NOP_IDEX,			/*插入NOP使能*/
		input valid_in_IDEX,	/*有效*/
		input [31:0] inst_in_IDEX,/*指令输入*/

        input[31:0] PC_in_IDEX, //PC输入
        input[4:0] Rd_addr_IDEX, //写目的地�?输入
        input[31:0] Rs1_in_IDEX,//操作�?1输入
        input[31:0] Rs2_in_IDEX, //操作�?2输如
        input[31:0] Imm_in_IDEX , //立即数输�?
        input ALUSrc_B_in_IDEX , //ALU B输入选择
        input[3:0] ALU_control_in_IDEX, //ALU选择控制
        input Branch_in_IDEX, //Beq
        input BranchN_in_IDEX, //Bne
        input MemRW_in_IDEX, //存储器读�?
        input[1:0] Jump_in_IDEX, //Jal
        input[1:0] MemtoReg_in_IDEX, //写回选择
        input RegWrite_in_IDEX, //寄存器堆读写

		output reg[31:0] inst_out_IDEX,	//inst输出
		output reg valid_out_IDEX,			//有效

		output reg [31:0] PC_out_IDEX,//PC输出
        output reg[4:0] Rd_addr_out_IDEX,//目的地址输出
        output reg[31:0] Rs1_out_IDEX,//操作�?1输出
        output reg[31:0] Rs2_out_IDEX, //操作�?2输出
        output reg[31:0] Imm_out_IDEX , //立即数输�?
        output reg ALUSrc_B_out_IDEX , //ALU B选择
        output reg[3:0] ALU_control_out_IDEX, //ALU控制
        output reg Branch_out_IDEX, //Beq
        output reg BranchN_out_IDEX, //Bne
        output reg MemRW_out_IDEX, //存储器读�?
        output reg [1:0]Jump_out_IDEX, //Jal
        output reg [1:0] MemtoReg_out_IDEX, //写回
        output reg RegWrite_out_IDEX //寄存器堆读写
    ); 
	
    always @(posedge clk_IDEX or posedge rst_IDEX) begin
		if (rst_IDEX==1)  begin 
			PC_out_IDEX <= 0;	//PC寄存�?
			Rs1_out_IDEX <= 0;	//Rs1寄存�?
			Rs2_out_IDEX <= 0;	//Rs2寄存�?
			Imm_out_IDEX <= 0;	//Imm寄存�?
			Rd_addr_out_IDEX <= 0;		//Rd_addr寄存�?
			ALUSrc_B_out_IDEX <= 0;		//ALUSrc_B
			ALU_control_out_IDEX <= 0;	//ALUControl
			Branch_out_IDEX <= 0;		//Branch
			BranchN_out_IDEX <= 0;		//BranchN
			MemRW_out_IDEX <= 0;		//MemRW
			Jump_out_IDEX <= 0;			//Jump
			MemtoReg_out_IDEX <= 0;		//MemtoReg
			RegWrite_out_IDEX <= 0;		//RegWrite
			inst_out_IDEX <= 0;			//inst输出
			valid_out_IDEX <= 0;		//有效
		end
		else if (en_IDEX) begin
			if(NOP_IDEX) begin		/*insert nop and disable RegWrite ,MemRw*/
				PC_out_IDEX <= 0;		//PC寄存�?
				Rs1_out_IDEX <= 0;	//Rs1寄存�?
				Rs2_out_IDEX <= 0;	//Rs2寄存�?
				Imm_out_IDEX <= 0;	//Imm寄存�?
				Rd_addr_out_IDEX <= 0;		//Rd_addr寄存�?
				ALUSrc_B_out_IDEX <= 0;		//ALUSrc_B
				ALU_control_out_IDEX <= 0;//ALUControl
				Branch_out_IDEX <= 0;			//Branch
				BranchN_out_IDEX <= 0;		//BranchN
				MemRW_out_IDEX <= 0;						//MemRW
				Jump_out_IDEX <= 0;				//Jump
				MemtoReg_out_IDEX <= 0;		//MemtoReg
				RegWrite_out_IDEX <= 0;					//RegWrite
				inst_out_IDEX <= 32'h00000013;			//inst输出
				valid_out_IDEX <= 0;		//有效
			end else begin
				PC_out_IDEX <= PC_in_IDEX;	//PC寄存�?
				Rs1_out_IDEX <= Rs1_in_IDEX;//Rs1寄存�?
				Rs2_out_IDEX <= Rs2_in_IDEX;//Rs2寄存�?
				Imm_out_IDEX <= Imm_in_IDEX;//Imm寄存�?
				Rd_addr_out_IDEX <= Rd_addr_IDEX;			//Rd_addr寄存�?
				ALUSrc_B_out_IDEX <= ALUSrc_B_in_IDEX;		//ALUSrc_B
				ALU_control_out_IDEX <= ALU_control_in_IDEX;//ALUControl
				Branch_out_IDEX <= Branch_in_IDEX;			//Branch
				BranchN_out_IDEX <= BranchN_in_IDEX;		//BranchN
				MemRW_out_IDEX <= MemRW_in_IDEX;			//MemRW
				Jump_out_IDEX <= Jump_in_IDEX;				//Jump
				MemtoReg_out_IDEX <= MemtoReg_in_IDEX;		//MemtoReg
				RegWrite_out_IDEX <= RegWrite_in_IDEX;		//RegWrite
				inst_out_IDEX <= inst_in_IDEX;				//inst输出
				valid_out_IDEX <= valid_in_IDEX;			//有效
			end
		end
	end

endmodule

