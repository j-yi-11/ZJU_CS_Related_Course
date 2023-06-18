`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/02 11:53:52
// Design Name: 
// Module Name: add_32_tb
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


module add_32_tb;
    reg [31:0] A;
    reg [31:0] B;
    wire [31:0] C;
    add_32 add_32_U(
        .A(A), 
        .B(B),
        .C(C)
    );
    initial begin
        A = 32'b011111;
        B = 32'b11101010;
        #50;
        A = 32'b11111111111111111111111111111111;
        B = 32'b1;
        #50;   
        A = 32'b11111111111111111111111111111111;
        B = 32'b0;
        #50;               
    end

    
endmodule
