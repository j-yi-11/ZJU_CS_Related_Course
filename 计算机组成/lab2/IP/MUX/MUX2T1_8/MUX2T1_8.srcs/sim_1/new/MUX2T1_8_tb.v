`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/01 22:49:21
// Design Name: 
// Module Name: MUX2T1_8_tb
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


module MUX2T1_8_tb;
    reg [7:0] I0;
    reg [7:0] I1;
    reg s;
    wire [7:0] o;
    MUX2T1_8 MUX2T1_8_U(
        .I0(I0),
        .I1(I1),
        .s(s),
        .o(o)
    );
    initial begin
        s = 0;
        I0 = 8'b00000000;
        I1 = 8'b00000001;
        #50;
        s = 0;
        #50;
        s = 1;
        #50;
        I0 = 8'b10000000;
        I1 = 8'b10000001;
        s = 1;
        #50;
        s = 0;
        #50;
        s = 1;
        #50;
    end
endmodule
