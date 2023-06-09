`timescale 1ns / 1ps
module Pipeline_Ex(
    input [31:0] PC_in_Ex,
    input [31:0] Imm_in_Ex,
    input [31:0] Rs1_in_Ex,
    input [31:0] Rs2_in_Ex,
    input [2:0] ALU_control_in_EX,//[3:0]
    input ALUSrc_B_in_EX,
    output [31:0] PC4_out_Ex,
    output [31:0] PC_out_Ex,
    output [31:0] ALU_out_Ex,
    output zero_out_Ex,
    output [31:0] Rs2_out_Ex
    );

    add_32 add_32_1(
        .a(4),
        .b(PC_in_Ex),
        .c(PC4_out_Ex)
    );
    add_32 add_32_2(
        .a(PC_in_Ex),
        .b(Imm_in_Ex),
        .c(PC_out_Ex)
    );

    wire [31:0] MUX2T1_32_o;
    MUX2T1_32 MUX2T1_32_0(
        .I0(Rs2_in_Ex),
        .I1(Imm_in_Ex),
        .s(ALUSrc_B_in_EX),
        .o(MUX2T1_32_o)
    );

    ALU ALU_0(
        .A(Rs1_in_Ex),
        .B(MUX2T1_32_o), 
 		.ALU_operation(ALU_control_in_EX), 
		.res(ALU_out_Ex), 
		.zero(zero_out_Ex)
    );

    assign Rs2_out_Ex = Rs2_in_Ex;

endmodule

