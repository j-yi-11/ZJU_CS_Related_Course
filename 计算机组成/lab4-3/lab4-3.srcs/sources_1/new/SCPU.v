`timescale 1ns / 1ps
module SCPU(
    input wire clk,
    input wire rst,
    input wire MIO_ready,
    input wire [31:0] inst_in,
    input wire [31:0] Data_in,
    output wire MemRW,
    output wire CPU_MIO,
    output wire [31:0] Addr_out,
    output wire [31:0] Data_out,
    output wire [31:0] PC_out
    );
    wire [2:0] ImmSel;//changed from [1:0]
    wire [1:0] MemtoReg;
    wire [3:0] ALU_Control;//changed from [3:0]
    wire [3:0] ALU_operation;
    assign ALU_operation = ALU_Control;
    wire [1:0] Jump;
    wire Branch,BranchN,RegWrite,ALUSrc_B;
    SCPU_ctrl mySCPU_ctrl(
        .OPcode(inst_in[6:2]),
        .Fun3(inst_in[14:12]),
        .Fun7(inst_in[30]),
        .MIO_ready(MIO_ready),
        .ImmSel(ImmSel),
        .ALUSrc_B(ALUSrc_B),
        .MemtoReg(MemtoReg),
        .Jump(Jump),
        .Branch(Branch),
        .BranchN(BranchN),
        .RegWrite(RegWrite),
        .MemRW(MemRW),
        .ALU_Control(ALU_Control),
        .CPU_MIO(CPU_MIO)
    );
    DataPath myDataPath(
        .ALUSrc_B(ALUSrc_B),
        .ALU_operation(ALU_operation),//ALU_Control ALU_Control
        .Branch(Branch),
        .BranchN(BranchN),
        .Data_in(Data_in),
        .ImmSel(ImmSel),
        .Jump(Jump),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .clk(clk),
        .rst(rst),
        .inst_field(inst_in),
        //output
        .ALU_out(Addr_out),
        .Data_out(Data_out),
        .PC_out(PC_out)
    );
endmodule
