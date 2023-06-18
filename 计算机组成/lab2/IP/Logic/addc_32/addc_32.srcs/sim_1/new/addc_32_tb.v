`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/02 11:40:02
// Design Name: 
// Module Name: addc_32_tb
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


module addc_32_tb;
    reg [31:0] A;
    reg [31:0] B;
    reg C0;
    wire [32:0] S;
    addc_32 addc_32_U(
        .A(A), 
        .B(B),
        .C0(C0),
        .S(S)
    );
    initial begin
        C0 = 0;//ADD
        A = 32'b0;
        B = 32'b1;
        #50;
        A = 32'b111111;
        B = 32'b11111111;
        #50;
        C0 = 1;//SUB
        A = 32'b0;
        B = 32'b1;
        #50;
        A = 32'b111111;
        B = 32'b11111111;
        #50;                
    end
endmodule
