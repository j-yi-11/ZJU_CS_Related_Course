`timescale 1ns / 1ps
module Pipeline_CPU(
    input clk,
    input rst,
    input [31:0] Data_in,
    input [31:0] inst_IF,
    output [31:0] PC_out_IF,
    output [31:0] PC_out_ID, 
    output [31:0] inst_ID, 
    output [31:0] PC_out_Ex,
    output [31:0] MemRW_Ex, 
    output [31:0] MemRW_Mem,
    output [31:0] Addr_out,
    output [31:0] Data_out,
    output [31:0] Data_out_WB,
    
    output wire [31:0] x0,
    output wire [31:0] ra,
    output wire [31:0] sp,
    output wire [31:0] gp,
    output wire [31:0] tp,
    output wire [31:0] t0,
    output wire [31:0] t1,
    output wire [31:0] t2,
    output wire [31:0] s0,
    output wire [31:0] s1,
    output wire [31:0] a0,
    output wire [31:0] a1,
    output wire [31:0] a2,
    output wire [31:0] a3,
    output wire [31:0] a4,
    output wire [31:0] a5,
    output wire [31:0] a6,
    output wire [31:0] a7,
    output wire [31:0] s2,
    output wire [31:0] s3,
    output wire [31:0] s4,
    output wire [31:0] s5,
    output wire [31:0] s6,
    output wire [31:0] s7,
    output wire [31:0] s8,
    output wire [31:0] s9,
    output wire [31:0] s10,
    output wire [31:0] s11,
    output wire [31:0] t3,
    output wire [31:0] t4,
    output wire [31:0] t5,
    output wire [31:0] t6,
    output wire [31:0] IdEx_rd,
        output wire [31:0] IdEx_rs1_val,
        output wire [31:0] IdEx_rs2_val,
        output wire IdEx_reg_wen,
        output wire [31:0] IdEx_is_imm,
        output wire [31:0] IdEx_imm
    );
    wire [31:0] PC_in_IF;
    wire PCSrc;
    wire [31:0] PC_out_IF_PC_in_IFID;
    assign PC_out_IF = PC_out_IF_PC_in_IFID;
    Pipeline_IF Instruction_Fetch(
        .clk_IF(clk),
        .rst_IF(rst),
        .en_IF(1'b1),
        .PC_in_IF(PC_in_IF),
        .PCSrc(PCSrc),//mem acsess
        .PC_out_IF(PC_out_IF_PC_in_IFID)//PC_out_IF
    );
    wire [31:0] PC_out_IFID;
    assign PC_out_ID = PC_out_IFID;
    wire [31:0] inst_out_IFID;
    assign inst_ID = inst_out_IFID;
    IF_reg_ID IF_reg_ID(
        .clk_IFID(clk),
        .rst_IFID(rst),
        .en_IFID(1'b1),
        .PC_in_IFID(PC_out_IF_PC_in_IFID),//from Instruction_Fetch
        .inst_in_IFID(inst_IF),
        .PC_out_IFID(PC_out_IFID),//PC_out_ID
        .inst_out_IFID(inst_out_IFID)//inst_ID
    );
    wire RegWrite_in_ID;
    wire [4:0] Rd_addr_ID;
    wire [31:0] Wt_data_ID;
    wire [31:0] Rd_addr_out_ID;
    wire [31:0] Rs1_out_ID;
    wire [31:0] Rs2_out_ID;
    wire [31:0] Imm_out_ID;
    wire ALUSrc_B_ID;
    wire [2:0] ALU_control_ID;//2?  3?
    wire Branch_ID;
    wire BranchN_ID;
    wire MemRW_ID;
    wire Jump_ID;
    wire [1:0] MemtoReg_ID;
    wire RegWrite_out_ID;
    Pipeline_ID Instruction_Decoder(
        .clk_ID(clk),
        .rst_ID(rst),
        .RegWrite_in_ID(RegWrite_in_ID),
        .Rd_addr_ID(Rd_addr_ID),
        .Wt_data_ID(Wt_data_ID),//Data_out_WB
        .Inst_in_ID(inst_out_IFID),//from IF_reg_ID
        .Rd_addr_out_ID(Rd_addr_out_ID),
        .Rs1_out_ID(Rs1_out_ID),
        .Rs2_out_ID(Rs2_out_ID),
        .Imm_out_ID(Imm_out_ID),
        .ALUSrc_B_ID(ALUSrc_B_ID),
        .ALU_control_ID(ALU_control_ID),
        .Branch_ID(Branch_ID),
        .BranchN_ID(BranchN_ID),
        .MemRW_ID(MemRW_ID),
        .Jump_ID(Jump_ID),
        .MemtoReg_ID(MemtoReg_ID),
        .RegWrite_out_ID(RegWrite_out_ID),
        .x0            (  x0           ),
        .ra            (  ra           ),
        .sp            (  sp           ),
        .gp            (  gp           ),
        .tp            (  tp           ),
        .t0            (  t0           ),
        .t1            (  t1           ),
        .t2            (  t2           ),
        .s0            (  s0           ),
        .s1            (  s1           ),
        .a0            (  a0           ),
        .a1            (  a1           ),
        .a2            (  a2           ),
        .a3            (  a3           ),
        .a4            (  a4           ),
        .a5            (  a5           ),
        .a6            (  a6           ),
        .a7            (  a7           ),
        .s2            (  s2           ),
        .s3            (  s3           ),
        .s4            (  s4           ),
        .s5            (  s5           ),
        .s6            (  s6           ),
        .s7            (  s7           ),
        .s8            (  s8           ),
        .s9            (  s9           ),
        .s10           (  s10          ),
        .s11           (  s11          ),
        .t3            (  t3           ),
        .t4            (  t4           ),
        .t5            (  t5           ),
        .t6            (  t6           )
    );
    wire [31:0] PC_out_IDEX;
    wire [4:0] Rd_addr_out_IDEX;
    wire [31:0] Rs1_out_IDEX;
    wire [31:0] Rs2_out_IDEX;
    wire [31:0] Imm_out_IDEX;
    wire ALUSrc_B_out_IDEX;
    wire [2:0] ALU_control_out_IDEX;//2?  3?
    wire Branch_out_IDEX,BranchN_out_IDEX,MemRW_out_IDEX,Jump_out_IDEX,RegWrite_out_IDEX;
    assign MemRW_Ex = MemRW_out_IDEX;
    wire [1:0] MemtoReg_out_IDEX;
    ID_reg_Ex ID_reg_Ex(
        .clk_IDEX(clk),
        .rst_IDEX(rst),
        .en_IDEX(1'b1),//    imm
        .PC_in_IDEX(PC_out_IFID),//from IF_reg_ID
        .Rd_addr_IDEX(Rd_addr_out_ID),
        .Rs1_in_IDEx(Rs1_out_ID),
        .Rs2_in_IDEX(Rs2_out_ID),
        .Imm_in_IDEX(Imm_out_ID),
        .ALUSrc_B_in_IDEX(ALUSrc_B_ID),
        .ALU_control_in_IDEX(ALU_control_ID),
        .Branch_in_IDEX(Branch_ID),
        .BranchN_in_IDEX(BranchN_ID),
        .MemRW_in_IDEX(MemRW_ID),
        .Jump_in_IDEX(Jump_ID),
        .MemtoReg_in_IDEX(MemtoReg_ID),
        .RegWrite_in_IDEX(RegWrite_out_ID),
        .PC_out_IDEX(PC_out_IDEX),
        .Rd_addr_out_IDEX(Rd_addr_out_IDEX),
        .Rs1_out_IDEX(Rs1_out_IDEX),
        .Rs2_out_IDEX(Rs2_out_IDEX),
        .Imm_out_IDEX(Imm_out_IDEX),
        .ALUSrc_B_out_IDEX(ALUSrc_B_out_IDEX),
        .ALU_control_out_IDEX(ALU_control_out_IDEX),
        .Branch_out_IDEX(Branch_out_IDEX),
        .BranchN_out_IDEX(BranchN_out_IDEX),
        .MemRW_out_IDEX(MemRW_out_IDEX),
        .Jump_out_IDEX(Jump_out_IDEX),
        .MemtoReg_out_IDEX(MemtoReg_out_IDEX),
        .RegWrite_out_IDEX(RegWrite_out_IDEX)
    );
    assign IdEx_rd = Rd_addr_out_IDEX;
    assign IdEx_rs1_val = Rs1_out_IDEX;
    assign IdEx_rs2_val = Rs2_out_IDEX;
    assign IdEx_reg_wen = RegWrite_out_IDEX;
    assign IdEx_is_imm = ALUSrc_B_out_IDEX;
    assign IdEx_imm = Imm_out_IDEX;
    wire [31:0] PC_out_EX_PC_in_EXMem;  //jy 
    assign PC_out_EX = PC_out_EX_PC_in_EXMem;//output 
    wire [31:0] PC4_out_EX;
    wire zero_out_EX;
    wire [31:0] ALU_out_EX;
    wire [31:0] Rs2_out_EX;
    Pipeline_Ex Execute(
        .PC_in_Ex(PC_out_IDEX),//PC_in_EX
        .Rs1_in_Ex(Rs1_out_IDEX),//Rs1_in_EX
        .Rs2_in_Ex(Rs2_out_IDEX),//Rs2_in_EX
        .Imm_in_Ex(Imm_out_IDEX),//Imm_in_EX
        .ALUSrc_B_in_EX(ALUSrc_B_out_IDEX),
        .ALU_control_in_EX(ALU_control_out_IDEX),
        .PC_out_Ex(PC_out_EX_PC_in_EXMem),//PC_out_EX
        .PC4_out_Ex(PC4_out_EX),//PC4_out_EX
        .zero_out_Ex(zero_out_EX),//zero_out_EX
        .ALU_out_Ex(ALU_out_EX),//ALU_out_EX
        .Rs2_out_Ex(Rs2_out_EX)//Rs2_out_EX
    );
    wire [31:0] PC4_out_EXMem;
    wire [31:0] Rd_addr_out_EXMem;
    wire zero_out_EXMem,Branch_out_EXMem,BranchN_out_EXMem,Jump_out_EXMem,RegWrite_out_EXMem;
    wire [31:0] ALU_out_EXMem;
    wire [1:0] MemtoReg_out_EXMem;
    assign Addr_out = ALU_out_EXMem;
    Ex_reg_Mem Ex_reg_Mem(
        .clk_EXMem(clk),
        .rst_EXMem(rst),
        .en_EXMem(1'b1),
        .PC_in_EXMem(PC_out_EX_PC_in_EXMem),//PC_out_EX  
        .PC4_in_EXMem(PC4_out_EX),
        .Rd_addr_EXMem(Rd_addr_out_IDEX),
        .zero_in_EXMem(zero_out_EX),
        .ALU_in_EXMem(ALU_out_EX),
        .Rs2_in_EXMem(Rs2_out_EX),
        .Branch_in_EXMem(Branch_out_IDEX),
        .BranchN_in_EXMem(BranchN_out_IDEX),
        .MemRW_in_EXMem(MemRW_out_IDEX),
        .Junp_in_EXMem(Jump_out_IDEX),//jump  junp
        .MemtoReg_in_EXMem(MemtoReg_out_IDEX),
        .RegWrite_in_EXMem(RegWrite_out_IDEX),
        .PC_out_EXMem(PC_in_IF),
        .PC4_out_EXMem(PC4_out_EXMem),
        .Rd_addr_out_EXMem(Rd_addr_out_EXMem),
        .zero_out_EXMem(zero_out_EXMem),
        .ALU_out_EXMem(ALU_out_EXMem),//Addr_out
        .Rs2_out_EXMem(Data_out),
        .Branch_out_EXMem(Branch_out_EXMem),
        .BranchN_out_EXMem(BranchN_out_EXMem),
        .MemRW_out_EXMem(MemRW_Mem),
        .Jump_out_EXMem(Jump_out_EXMem),
        .MemtoReg_out_EXMem(MemtoReg_out_EXMem),
        .RegWrite_out_EXMem(RegWrite_out_EXMem)
    );
    Pipeline_Mem Memory_Access(
        .zero_in_Mem(zero_out_EXMem),
        .Branch_in_Mem(Branch_out_EXMem),
        .BranchN_in_Mem(BranchN_out_EXMem),
        .Jump_in_Mem(Jump_out_EXMem),
        .PCSrc(PCSrc)
    );
    wire [31:0] PC4_out_MemWB;
    wire [31:0] ALU_out_MemWB;
    wire [31:0] DMem_data_out_MemWB;
    wire [1:0] MemtoReg_out_MemWB;
    Mem_reg_WB Mem_reg_WB(
        .clk_MemWB(clk),
        .rst_MemWB(rst),
        .en_MemWB(1'b1),
        .PC4_in_MemWB(PC4_out_EXMem),
        .Rd_addr_MemWB(Rd_addr_out_EXMem),
        .ALU_in_MemWB(ALU_out_EXMem),
        .DMem_data_MemWB(Data_in),
        .MemtoReg_in_MemWB(MemtoReg_out_EXMem),
        .RegWrite_in_MemWB(RegWrite_out_EXMem),
        .PC4_out_MemWB(PC4_out_MemWB),
        .Rd_addr_out_MemWB(Rd_addr_ID),
        .ALU_out_MemWB(ALU_out_MemWB),
        .DMem_data_out_MemWB(DMem_data_out_MemWB),
        .MemtoReg_out_MemWB(MemtoReg_out_MemWB),
        .RegWrite_out_MemWB(RegWrite_in_ID)
    );
    wire [31:0] Wt_data_ID_Data_out_WB;
    assign Wt_data_ID = Wt_data_ID_Data_out_WB;
    assign Data_out_WB = Wt_data_ID_Data_out_WB;
    Pipeline_WB Write_Back(
        .PC4_in_WB(PC4_out_MemWB),
        .ALU_in_WB(ALU_out_MemWB),
        .DMem_data_WB(DMem_data_out_MemWB),
        .MemtoReg_in_WB(MemtoReg_out_MemWB),
        .Data_out_WB(Wt_data_ID_Data_out_WB)//Data_out_WB
    );
endmodule

//`timescale 1ns / 1ps
//module Pipeline_CPU(
//    input [31:0] Data_in,
//    input clk,
//    input rst,
//    input [31:0] inst_IF,
//    output [31:0] PC_out_Ex,
//    output [31:0] PC_out_ID,
//    output [31:0] inst_ID,
//    output [31:0] PC_out_IF,
//    output [31:0] Addr_out,
//    output [31:0] Data_out,
//    output [31:0] Data_out_WB,
//    output MemRW_Mem,
//    output MemRW_Ex,//MemRW_EX

//    output wire valid_IFID ,
//    output wire [31:0]inst_out_IDEX,
//    output wire valid_out_IDEX,
//    output wire [4:0] Rd_addr_out_ID,
//    output wire [4:0] Rs1_addr_ID,
//    output wire [4:0] Rs2_addr_ID,
//    output wire [31:0] Rs1_out_ID,
//    output wire [31:0] Rs2_out_ID,
//    output wire [31:0] Imm_out_ID,
//    output wire [31:0] PC_out_EXMem,
//    output wire [31:0] inst_out_EXMem,
//    output wire valid_out_EXMem,
//    output [31:0] PC_out_MemWB,	/*PC输入*/
//	output [31:0] inst_out_MemWB,	/*inst输入*/
//	output 		 valid_out_MemWB,	/*有效*/


//    output wire [31:0] x0,
//    output wire [31:0] ra,
//    output wire [31:0] sp,
//    output wire [31:0] gp,
//    output wire [31:0] tp,
//    output wire [31:0] t0,
//    output wire [31:0] t1,
//    output wire [31:0] t2,
//    output wire [31:0] s0,
//    output wire [31:0] s1,
//    output wire [31:0] a0,
//    output wire [31:0] a1,
//    output wire [31:0] a2,
//    output wire [31:0] a3,
//    output wire [31:0] a4,
//    output wire [31:0] a5,
//    output wire [31:0] a6,
//    output wire [31:0] a7,
//    output wire [31:0] s2,
//    output wire [31:0] s3,
//    output wire [31:0] s4,
//    output wire [31:0] s5,
//    output wire [31:0] s6,
//    output wire [31:0] s7,
//    output wire [31:0] s8,
//    output wire [31:0] s9,
//    output wire [31:0] s10,
//    output wire [31:0] s11,
//    output wire [31:0] t3,
//    output wire [31:0] t4,
//    output wire [31:0] t5,
//    output wire [31:0] t6
//    );

//    wire [31:0] PC_imm_out_EXMem;
//    wire PCSrc;
//    wire en_IF;
//    /*Pipeline IF*/
//    Pipeline_IF IF(
//        .clk_IF(clk),
//        .rst_IF(rst),
//        .en_IF(en_IF),
//        .PC_in_IF(PC_imm_out_EXMem),
//        .PCSrc(PCSrc),
//        .PC_out_IF(PC_out_IF)
//    );

//    /*IF_REG_ID*/
//    wire en_IFID;
//    wire NOP_IFID;
//    // wire valid_IFID ;
//    IF_reg_ID IF_REG_ID(
//        .clk_IFID(clk),
//        .rst_IFID(rst),
//        .en_IFID(en_IFID),
//        .PC_in_IFID(PC_out_IF),
//        .inst_in_IFID(inst_IF),
//        .NOP_IFID(NOP_IFID),

//        .PC_out_IFID(PC_out_ID),
//        .inst_out_IFID(inst_ID),
//        .valid_IFID(valid_IFID)
//    );

//    /*Pipeline_ID*/
//    wire [4:0] Rd_addr_out_MemWB;
//    wire RegWrite_out_MemWB;
//    // wire [31:0] Rs1_out_ID;
//    // wire [31:0] Rs2_out_ID;
//    // wire [31:0] Imm_out_ID;
//    wire ALUSrc_B_ID;
//    wire [1:0] MemtoReg_ID;
//    wire [1:0]Jump_ID;
//    wire Branch_ID;
//    wire BranchN_ID;
//    wire RegWrite_out_ID;
//    wire MemRW_ID;
//    wire [3:0] ALU_Control_ID;
//    // wire [4:0] Rd_addr_out_ID;
//    // wire [4:0] Rs1_addr_ID;
//    // wire [4:0] Rs2_addr_ID;
//    wire Rs1_used;
//    wire Rs2_used;

//    Pipeline_ID ID(
//        .clk_ID(clk),
//        .rst_ID(rst),
//        .Rd_addr_ID(Rd_addr_out_MemWB),
//        .Wt_data_ID(Data_out_WB),
//        .RegWrite_in_ID(RegWrite_out_MemWB),
//        .inst_in_ID(inst_ID),

//        .Rs1_out_ID(Rs1_out_ID),
//        .Rs2_out_ID(Rs2_out_ID),
//        .Rs1_addr_ID(Rs1_addr_ID),  //寄存器地�?1
//        .Rs2_addr_ID(Rs2_addr_ID),  //寄存器地�?2
//        .Rs1_used(Rs1_used),        //Rs1被使�?
//        .Rs2_used(Rs2_used),        //Rs2被使�?
//        .Imm_out_ID(Imm_out_ID),
//        .ALUSrc_B_ID(ALUSrc_B_ID),
//        .MemtoReg_ID(MemtoReg_ID),
//        .Jump_ID(Jump_ID),
//        .Branch_ID(Branch_ID),
//        .BranchN_ID(BranchN_ID),
//        .RegWrite_out_ID(RegWrite_out_ID),
//        .MemRW_ID(MemRW_ID),
//        .ALU_Control_ID(ALU_Control_ID),
//        .Rd_addr_out_ID(Rd_addr_out_ID),
//        .x0            (  x0           ),
//        .ra            (  ra           ),
//        .sp            (  sp           ),
//        .gp            (  gp           ),
//        .tp            (  tp           ),
//        .t0            (  t0           ),
//        .t1            (  t1           ),
//        .t2            (  t2           ),
//        .s0            (  s0           ),
//        .s1            (  s1           ),
//        .a0            (  a0           ),
//        .a1            (  a1           ),
//        .a2            (  a2           ),
//        .a3            (  a3           ),
//        .a4            (  a4           ),
//        .a5            (  a5           ),
//        .a6            (  a6           ),
//        .a7            (  a7           ),
//        .s2            (  s2           ),
//        .s3            (  s3           ),
//        .s4            (  s4           ),
//        .s5            (  s5           ),
//        .s6            (  s6           ),
//        .s7            (  s7           ),
//        .s8            (  s8           ),
//        .s9            (  s9           ),
//        .s10           (  s10          ),
//        .s11           (  s11          ),
//        .t3            (  t3           ),
//        .t4            (  t4           ),
//        .t5            (  t5           ),
//        .t6            (  t6           )
//    );


//    /*ID_REG_EX*/
//    wire [31:0]PC_out_IDEX;
//    wire [4:0] Rd_addr_out_IDEX;
//    wire [31:0] Rs1_out_IDEX;
//    wire [31:0] Rs2_out_IDEX;
//    wire [31:0] Imm_out_IDEX;
//    wire ALUSrc_B_out_IDEX;
//    wire [3:0]ALU_control_out_IDEX;
//    wire Branch_out_IDEX;
//    wire BranchN_out_IDEX;
//    wire [1:0]Jump_out_IDEX;
//    wire [1:0]MemtoReg_out_IDEX;
//    wire RegWrite_out_IDEX;
//    /*wire MemRW_out_IDEX : .MemRW_out_IDEX(MemRW_Ex), //存储器读�?*/
//    wire NOP_IDEX;
//    // wire [31:0]inst_out_IDEX;
//    // wire valid_out_IDEX;
//    ID_reg_Ex ID_REG_EX( 
//        .clk_IDEX(clk), //寄存器时�?
//        .rst_IDEX(rst), //寄存器复�?
//        .en_IDEX(1), //寄存器使�?
//        .NOP_IDEX(NOP_IDEX),            /*NOP_IDEX：插入nop*/
//        .valid_in_IDEX(valid_IFID),	    /*有效*/
//		.inst_in_IDEX(inst_ID),         /*指令输入*/

//        .PC_in_IDEX(PC_out_ID), //PC输入
//        .Rd_addr_IDEX(Rd_addr_out_ID), //写目的地�?输入
//        .Rs1_in_IDEX(Rs1_out_ID),
//        .Rs2_in_IDEX(Rs2_out_ID), 
//        .Imm_in_IDEX(Imm_out_ID) , //立即数输�?
//        .ALUSrc_B_in_IDEX(ALUSrc_B_ID) , //ALU B
//        .ALU_control_in_IDEX(ALU_Control_ID), //ALU
//        .Branch_in_IDEX(Branch_ID), //Beq
//        .BranchN_in_IDEX(BranchN_ID), //Bne
//        .MemRW_in_IDEX(MemRW_ID), //存储器读�?
//        .Jump_in_IDEX(Jump_ID), //Jal
//        .MemtoReg_in_IDEX(MemtoReg_ID), //写回选择
//        .RegWrite_in_IDEX(RegWrite_out_ID), //寄存器堆读写
        
//        .PC_out_IDEX(PC_out_IDEX),//PC输出
//        .Rd_addr_out_IDEX(Rd_addr_out_IDEX),//目的地址输出
//        .Rs1_out_IDEX(Rs1_out_IDEX),//操作�?1输出
//        .Rs2_out_IDEX(Rs2_out_IDEX), //操作�?2输出
//        .Imm_out_IDEX(Imm_out_IDEX) , //立即数输�?
//        .ALUSrc_B_out_IDEX(ALUSrc_B_out_IDEX) , //ALU B选择
//        .ALU_control_out_IDEX(ALU_control_out_IDEX), //ALU控制
//        .Branch_out_IDEX(Branch_out_IDEX), //Beq
//        .BranchN_out_IDEX(BranchN_out_IDEX), //Bne
//        .MemRW_out_IDEX(MemRW_Ex), //存储器读�?
//        .Jump_out_IDEX(Jump_out_IDEX), //Jal
//        .MemtoReg_out_IDEX(MemtoReg_out_IDEX), //写回
//        .RegWrite_out_IDEX(RegWrite_out_IDEX), //寄存器堆读写

//        .inst_out_IDEX(inst_out_IDEX),	        //inst输出
//		.valid_out_IDEX(valid_out_IDEX)			    //有效
//    ); 

//    /*Pipeline_EX*/
//    wire [31:0] PC4_out_Ex;
//    wire zero_out_Ex;
//    wire [31:0] ALU_out_Ex;
//    wire [31:0] Rs2_out_Ex;
//    Pipeline_Ex Ex(
//        .PC_in_Ex(PC_out_IDEX),
//        .Imm_in_Ex(Imm_out_IDEX),
//        .Rs1_in_Ex(Rs1_out_IDEX),
//        .Rs2_in_Ex(Rs2_out_IDEX),
//        .ALU_control_in_EX(ALU_control_out_IDEX),
//        .ALUSrc_B_in_EX(ALUSrc_B_out_IDEX),

//        .PC4_out_Ex(PC4_out_Ex),
//        .PC_out_Ex(PC_out_Ex),
//        .ALU_out_Ex(ALU_out_Ex),
//        .zero_out_Ex(zero_out_Ex),
//        .Rs2_out_Ex(Rs2_out_Ex)
//    );

//    /*Ex_REG_Mem*/
//    wire [31:0] PC4_out_EXMem;
//    wire [4:0] Rd_addr_out_EXMem;
//    wire zero_out_EXMem;
//    wire [31:0] ALU_out_EXMem;
//    // wire [31:0] Rs2_out_EXMem;
//    wire Branch_out_EXMem;
//    wire BranchN_out_EXMem;
//    /*wire MemRW_out_EXMem;.MemRW_out_EXMem(MemRW_Mem), */
//    wire [1:0] Jump_out_EXMem;
//    wire [1:0] MemtoReg_out_EXMem;
//    wire RegWrite_out_EXMem;
//    // wire [31:0] inst_out_EXMem;
//    // wire valid_out_EXMem;
//    // wire [31:0] PC_out_EXMem;

//    Ex_reg_Mem Ex_REG_Mem( 
//        .clk_EXMem(clk),//寄存器时�?
//        .rst_EXMem(rst), //寄存器复�?
//        .en_EXMem(1), //寄存器使�?
//        .PC_in_EXMem(PC_out_IDEX), //PC输入
//        .PC4_in_EXMem(PC4_out_Ex), //PC+4输入
//        .Rd_addr_EXMem(Rd_addr_out_IDEX), //写目的寄存器地址输入
//        .zero_in_EXMem(zero_out_Ex), //zero
//        .ALU_in_EXMem(ALU_out_Ex), //ALU输入
//        .Rs2_in_EXMem(Rs2_out_Ex), //操作�?2输入
//        .Branch_in_EXMem(Branch_out_IDEX), //Beq
//        .BranchN_in_EXMem(BranchN_out_IDEX), //Bne
//        .MemRW_in_EXMem(MemRW_Ex), //MemRW_EX
//        .Jump_in_EXMem(Jump_out_IDEX), //Jal
//        .MemtoReg_in_EXMem(MemtoReg_out_IDEX), //写回
//        .RegWrite_in_EXMem(RegWrite_out_IDEX), //寄存器堆读写

//        .PC_imm_EXMem(PC_out_Ex),	            /*PC输入(imm+pc)*/ 
//		.valid_in_EXMem(valid_out_IDEX),		/*有效*/
//		.inst_in_EXMem(inst_out_IDEX),	        /*指令输入*/

//        .PC_out_EXMem(PC_out_EXMem),  //PC输出
//        .PC4_out_EXMem(PC4_out_EXMem), //PC+4输出
//        .Rd_addr_out_EXMem(Rd_addr_out_EXMem), //写目的寄存器输出
//        .zero_out_EXMem(zero_out_EXMem), //zero
//        .ALU_out_EXMem(ALU_out_EXMem),        //ALU输出
//        .Rs2_out_EXMem(Data_out),         //操作�?2输出
//        .Branch_out_EXMem(Branch_out_EXMem),     //Beq
//        .BranchN_out_EXMem(BranchN_out_EXMem),     //Bne
//        .MemRW_out_EXMem(MemRW_Mem),       //存储器读�?
//        .Jump_out_EXMem(Jump_out_EXMem),        //Jal
//        .MemtoReg_out_EXMem(MemtoReg_out_EXMem), 	  //写回
//        .RegWrite_out_EXMem(RegWrite_out_EXMem),    //寄存器堆读写

//        .PC_imm_out_EXMem(PC_imm_out_EXMem),	    /*PC输出(imm+pc)*/
//		.valid_out_EXMem(valid_out_EXMem),			/*有效*/
//		.inst_out_EXMem(inst_out_EXMem)	            /*inst输出*/
//    );

//    /*Pipeline_Mem*/
//    Pipeline_Mem Mem(
//        . zero_in_Mem(zero_out_EXMem),
//        . Branch_in_Mem(Branch_out_EXMem),
//        . BranchN_in_Mem(BranchN_out_EXMem),
//        . Jump_in_Mem(Jump_out_EXMem),
//        .PCSrc(PCSrc)
//    );

//    /*Mem_REG_WB*/
//    wire [31:0] PC4_out_MemWB;
//    // wire [4:0] Rd_addr_out_MemWB
//    wire [31:0] ALU_out_MemWB;
//    wire [31:0] DMem_data_out_MemWB;
//    wire [1:0] MemtoReg_out_MemWB;
//    // wire RegWrite_out_MemWB;
//    Mem_reg_WB Mem_REG_WB( 
//        .clk_MemWB(clk),//寄存器时
//        .rst_MemWB(rst), //寄存器复�?
//        .en_MemWB(1), //寄存器使�?

//        .PC_in_MemWB(PC_out_EXMem),	    /*PC输入*/
//        .inst_in_MemWB(inst_out_EXMem),	/*inst输入*/
//        .valid_in_MemWB(valid_out_EXMem),	/*有效*/

//        .PC4_in_MemWB(PC4_out_EXMem), //PC+4输入
//        .Rd_addr_MemWB(Rd_addr_out_EXMem), //写目的地�?输入
//        .ALU_in_MemWB(ALU_out_EXMem),     //ALU输入
//        .Dmem_data_MemWB(Data_in),   //存储器数据输�?
//        .MemtoReg_in_MemWB(MemtoReg_out_EXMem),     //写回
//        .RegWrite_in_MemWB(RegWrite_out_EXMem),     //寄存器堆读写

//        .PC_out_MemWB(PC_out_MemWB),	/*not used*/
//        .inst_out_MemWB(inst_out_MemWB),	/*inst输入*/
//        .valid_out_MemWB(valid_out_MemWB),	/*有效*/

//        .PC4_out_MemWB(PC4_out_MemWB), //PC+4
//        .Rd_addr_out_MemWB(Rd_addr_out_MemWB), //写目的地�?输出
//        .ALU_out_MemWB(ALU_out_MemWB),     //ALU输出
//        .DMem_data_out_MemWB(DMem_data_out_MemWB),    //存储器数据输�?
//        .MemtoReg_out_MemWB(MemtoReg_out_MemWB),     //写回
//        .RegWrite_out_MemWB(RegWrite_out_MemWB)    //寄存器堆读写
//    ); 

//    /*Pipeline_WB*/
//    Pipeline_WB WB( 
//        .PC4_in_WB(PC4_out_MemWB), //PC+4输入
//        .ALU_in_WB(ALU_out_MemWB), //ALU结果输出
//        .Dmem_data_WB(DMem_data_out_MemWB), //存储器数据输�?
//        .MemtoReg_in_WB(MemtoReg_out_MemWB), //写回选择控制
//        .Data_out_WB(Data_out_WB)    //写回数据输出
//    );

//    /*stall*/
//    stall stall_0(
//        .rst_stall(rst), //复位
//        .RegWrite_out_IDEX(RegWrite_out_IDEX), //执行阶段寄存器写控制
//        .Rd_addr_out_IDEX(Rd_addr_out_IDEX), //执s行阶段寄存器写地�?
//        .RegWrite_out_EXMem(RegWrite_out_EXMem), //访存阶段寄存器写控制
//        .Rd_addr_out_EXMem(Rd_addr_out_EXMem), //访存阶段寄存器写地址
//        .Rs1_addr_ID(Rs1_addr_ID), //译码阶段寄存器读地址1
//        .Rs2_addr_ID(Rs2_addr_ID), //译码阶段寄存器读地址2
//        .Rs1_used(Rs1_used), //Rs1被使�?
//        .Rs2_used(Rs2_used), //Rs2被使�?
//        .Branch_ID(Branch_ID), //译码阶段beq
//        .BranchN_ID(BranchN_ID), //译码阶段bne
//        .Jump_ID(Jump_ID), //译码阶段jal
//        .Branch_out_IDEX(Branch_out_IDEX), //执行阶段beq
//        .BranchN_out_IDEX(BranchN_out_IDEX), //执行阶段bne
//        .Jump_out_IDEX(Jump_out_IDEX), //执行阶段jal
//        .Branch_out_EXMem(Branch_out_EXMem), //访存阶段beq
//        .BranchN_out_EXMem(BranchN_out_EXMem), //访存阶段bne
//        .Jump_out_EXMem(Jump_out_EXMem), //访存阶段jal
//        .en_IF(en_IF), //流水线寄存器的使能及NOP信号
//        .en_IFID(en_IFID),
//        .NOP_IFID(NOP_IFID),
//        .NOP_IDEX(NOP_IDEX)
//    );
//    assign Addr_out = ALU_out_EXMem;
//endmodule
