`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/01 23:12:39
// Design Name: 
// Module Name: MUX4T1_32
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


module MUX4T1_32(
    input [1:0] s,
    input [31:0] I0,
    input [31:0] I1,
    input [31:0] I2,
    input [31:0] I3,
    output [31:0] o
    );
    reg [31:0] result;
    always @(*)
        case(s)
            2'b00: result = I0;
            2'b01: result = I1;    
            2'b10: result = I2;
            2'b11: result = I3;          
        endcase 
     assign o = result;   
endmodule
