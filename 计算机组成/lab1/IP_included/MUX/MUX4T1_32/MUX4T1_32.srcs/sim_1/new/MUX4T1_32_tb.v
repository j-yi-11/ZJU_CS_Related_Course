`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/01 23:14:43
// Design Name: 
// Module Name: MUX4T1_32_tb
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


module MUX4T1_32_tb;
    reg [1:0] s;
    reg [31:0] I0;
    reg [31:0] I1;
    reg [31:0] I2;
    reg [31:0] I3;
    wire [31:0] o;
    MUX4T1_32 MUX4T1_32_U(
        .s(s),
        .I0(I0),
        .I1(I1),
        .I2(I2),
        .I3(I3),
        .o(o) 
    );   
    initial begin
        s = 2'b00;
        I0 = 32'b000010101001;
        I1 = 32'b000010101010;
        I2 = 32'b001000000000;
        I3 = 32'b1111000;        
        #50;
        s = 2'b00;
        #50;
        s = 2'b01;
        #50;
        s = 2'b10;
        #50;
        s = 2'b11;
        #50;
        s = 2'b10;
        #50;
    end
endmodule

