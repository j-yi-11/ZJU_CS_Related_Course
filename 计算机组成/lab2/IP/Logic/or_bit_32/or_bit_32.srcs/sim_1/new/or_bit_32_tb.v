`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/02 11:32:53
// Design Name: 
// Module Name: or_bit_32_tb
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


module or_bit_32_tb;
    reg [31:0] A;
    wire o;
    or_bit_32 or_bit_32_U(
        .A(A), 
        .o(o)
    );
    initial begin
        A = 32'b0;
        #50;
        A = 32'b111111;
        #50;        
    end
endmodule
