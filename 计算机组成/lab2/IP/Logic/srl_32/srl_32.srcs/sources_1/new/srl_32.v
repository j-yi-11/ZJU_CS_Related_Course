`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/02 11:58:22
// Design Name: 
// Module Name: srl_32
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


module srl_32(
    input [31:0] A,
    input [31:0] B,
    output [31:0] res
    );
    wire [4:0] offset;
    assign offset = B[10:6];
    assign res = B >> 1;
endmodule
