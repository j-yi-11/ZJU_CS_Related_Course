`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/02 11:05:03
// Design Name: 
// Module Name: and32_tb
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


module and32_tb;
    reg [31:0] A;
    reg [31:0] B;
    wire [31:0] res;
    and32 and32_U(
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
