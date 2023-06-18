`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/01 23:26:34
// Design Name: 
// Module Name: MUX8T1_32_tb
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


module MUX8T1_32_tb;
    reg [2:0] s;
    reg [31:0] I0;
    reg [31:0] I1;
    reg [31:0] I2;
    reg [31:0] I3;
    reg [31:0] I4;
    reg [31:0] I5;
    reg [31:0] I6;
    reg [31:0] I7;    
    wire [31:0] o;
    MUX8T1_32 MUX8T1_32_U(
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
        I0 = 32'b001010001;
        I1 = 32'b000110100;
        I2 = 32'b0010111110;
        I3 = 32'b111101000;  
        I4 = 32'b000000000001;
        I5 = 32'b1001111111010;
        I6 = 32'b1011111100100;
        I7 = 32'b101001000;                
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
