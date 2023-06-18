`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/01 22:38:40
// Design Name: 
// Module Name: MUX2T1_32_tb
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


module MUX2T1_32_tb;
    reg [31:0] I0;
    reg [31:0] I1;
    reg s;
    wire [31:0] o;
    MUX2T1_32 MUX2T1_32_U(
        .I0(I0),
        .I1(I1),
        .s(s),
        .o(o)
    );
    initial begin
        s = 0;
        I0 = 0;
        I1 = 1;
        #50;
        s = 0;
        #50;
        s = 1;
        #50;
        I0 = 1;
        I1 = 0;
        s = 1;
        #50;
        s = 0;
        #50;
        s = 1;
        #50;
    end
endmodule
