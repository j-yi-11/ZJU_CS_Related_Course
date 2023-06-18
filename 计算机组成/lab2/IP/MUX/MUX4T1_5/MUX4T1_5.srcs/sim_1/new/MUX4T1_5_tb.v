`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/01 23:04:55
// Design Name: 
// Module Name: MUX4T1_5_tb
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


module MUX4T1_5_tb;
    reg [1:0] s;
    reg [4:0] I0;
    reg [4:0] I1;
    reg [4:0] I2;
    reg [4:0] I3;
    wire [4:0] o;
    MUX4T1_5 MUX4T1_5_U(
        .s(s),
        .I0(I0),
        .I1(I1),
        .I2(I2),
        .I3(I3),
        .o(o) 
    );   
    initial begin
        s = 2'b00;
        I0 = 5'b00001;
        I1 = 5'b00010;
        I2 = 5'b00100;
        I3 = 5'b01000;        
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
