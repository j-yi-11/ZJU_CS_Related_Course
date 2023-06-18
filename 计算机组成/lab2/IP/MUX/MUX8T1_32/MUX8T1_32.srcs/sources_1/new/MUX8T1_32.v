`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/01 23:25:09
// Design Name: 
// Module Name: MUX8T1_32
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


module MUX8T1_32(
    input [2:0] s,
    input [31:0] I0,
    input [31:0] I1,
    input [31:0] I2,
    input [31:0] I3,
    input [31:0] I4,
    input [31:0] I5,
    input [31:0] I6,
    input [31:0] I7,    
    output [31:0] o
    );
    reg [31:0] result;
    always @(*)
        case(s)
            3'b000: result = I0;
            3'b001: result = I1;    
            3'b010: result = I2;
            3'b011: result = I3;    
            3'b100: result = I4;
            3'b101: result = I5;    
            3'b110: result = I6;
            3'b111: result = I7;                      
        endcase 
     assign o = result;       
endmodule
