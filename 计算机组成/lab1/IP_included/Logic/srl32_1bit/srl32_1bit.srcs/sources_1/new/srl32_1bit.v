`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/09 16:14:51
// Design Name: 
// Module Name: srl32_1bit
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


module srl32_1bit(
    input [31:0] A,
    input [31:0] B,
    output [31:0] res
    );
    assign res = B >> 1;
endmodule
