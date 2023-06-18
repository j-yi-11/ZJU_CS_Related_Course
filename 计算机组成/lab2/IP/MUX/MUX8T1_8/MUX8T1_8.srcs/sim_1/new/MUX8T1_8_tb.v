`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/01 23:20:15
// Design Name: 
// Module Name: MUX8T1_8_tb
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


module MUX8T1_8_tb;
    reg [2:0] s;
    reg [7:0] I0;
    reg [7:0] I1;
    reg [7:0] I2;
    reg [7:0] I3;
    reg [7:0] I4;
    reg [7:0] I5;
    reg [7:0] I6;
    reg [7:0] I7;    
    wire [7:0] o;
    MUX8T1_8 MUX8T1_8_U(
        .s(s),
        .I0(I0),
        .I1(I1),
        .I2(I2),
        .I3(I3),
        .I4(I4),
        .I5(I5),
        .I6(I6),
        .I7(I7),        
        .o(o) 
    );   
    initial begin
        s = 3'b000;
        I0 = 8'b00001;
        I1 = 8'b00010;
        I2 = 8'b00100;
        I3 = 8'b01000;  
        I4 = 8'b00001;
        I5 = 8'b100010;
        I6 = 8'b1000100;
        I7 = 8'b10001000;                
        #50;
        s = 3'b000;
        #50;
        s = 3'b001;
        #50;
        s = 3'b010;
        #50;
        s = 3'b011;
        #50;
        s = 3'b100;
        #50;
        s = 3'b101;
        #50;
        s = 3'b110;
        #50;
        s = 3'b111;
        #50;
    end
endmodule
