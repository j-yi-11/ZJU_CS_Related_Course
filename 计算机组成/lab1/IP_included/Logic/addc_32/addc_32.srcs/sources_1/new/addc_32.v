`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/02 11:37:07
// Design Name: 
// Module Name: addc_32
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


module addc_32(
    input [31:0] A,
    input [31:0] B,
    input C0,
    output [32:0] S 
    );
    wire B_Notation = C0 ^ 1'b0;
    assign S = {1'b0,A} + {B_Notation,B } + C0;
endmodule
