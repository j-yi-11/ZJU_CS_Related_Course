`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/02 11:20:41
// Design Name: 
// Module Name: nor32_tb
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


module nor32_tb;
    reg [31:0] A;
    reg [31:0] B;
    wire [31:0] res;
    nor32 nor32_U(
        .A(A), 
        .B(B),
        .res(res)
    );
    initial begin
        A = 32'b0;
        B = 32'b1;
        #50;
        A = 32'b111111;
        B = 32'b1;
        #50;        
    end
endmodule
