`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/02 12:01:20
// Design Name: 
// Module Name: srl_32_tb
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


module srl_32_tb;
    reg [31:0] A;
    reg [31:0] B;
    wire [31:0] res;
    srl_32 srl_32_U(
        .A(A), 
        .B(B),
        .res(res)
    );
    initial begin
        A = 32'b11100010111;
        B = 32'b1111100000;
        #50;
        //A = 32'b111111;
        B = 32'b0001000000;
        #50;        
    end    
    
endmodule
