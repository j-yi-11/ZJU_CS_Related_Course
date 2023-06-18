`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/02 12:20:28
// Design Name: 
// Module Name: Ext_imm16_tb
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


module Ext_imm16_tb;
    reg [15:0] imm_16;
    wire [31:0] Imm_32;
    Ext_imm16 Ext_imm16_U(
        .imm_16(imm_16),
        .Imm_32(Imm_32)
    );
    initial begin
        imm_16 = 16'b0;
        #50
        imm_16 = 16'b1000000000000000;
    end
endmodule
