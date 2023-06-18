`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/02 10:53:14
// Design Name: 
// Module Name: MUX2T1_64
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


module MUX2T1_64(
    input [63:0] I0,
    input [63:0] I1,
    input s,
    output [63:0] o
    );
    assign o = s ? I1 : I0;
endmodule
