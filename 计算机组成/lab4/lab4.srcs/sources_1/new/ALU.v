`timescale 1ns / 1ps
module ALU(
    input [31:0] A,
    input [31:0] B,
    input [2:0] ALU_operation,
    output reg[31:0] res,
    output zero
    );
    parameter one = 32'h00000001;
    parameter zero_0 = 32'h00000000;
    always @ (*) begin
        case (ALU_operation)
        3'b000: res=A&B;//and
        3'b001: res=A|B;//or
        3'b010: res=A+B;//add
        3'b011: res=A^B;//xor
        3'b110: res=A-B;//sub
        3'b101: res=B>>1; // srl
        3'b111: res=($signed(A) < $signed(B)) ? one : zero_0;//slt
        default: res=32'h00000000;
        endcase
    end
    assign zero = (res==0)? 1: 0;    
endmodule
