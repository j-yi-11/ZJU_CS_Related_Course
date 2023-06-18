`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/02 12:09:25
// Design Name: 
// Module Name: SignalExt_32_tb
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


module SignalExt_32_tb;
    reg S;
    wire [31:0] So;
    SignalExt_32 SignalExt_32_U(
        .S(S),
        .So(So)
    );
    initial begin
        S = 0;
        #50;
        S = 1;
        #50;
    end
endmodule
