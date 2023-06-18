`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/07 16:35:16
// Design Name: 
// Module Name: regs_tb
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


module regs_tb;
    reg clk , rst , RegWrite;
    reg [4:0] Rs1_addr, Rs2_addr,Wt_addr;
    reg [31:0] Wt_data;
    wire [31:0] Rs1_data, Rs2_data;
    regs regs_tb_U(
        .clk(clk),
        .rst(rst),
        .RegWrite(RegWrite),
        .Rs1_addr(Rs1_addr),
        .Rs2_addr(Rs2_addr),
        .Wt_addr(Wt_addr),
        .Wt_data(Wt_data),
        .Rs1_data(Rs1_data),
        .Rs2_data(Rs2_data)
    );
    always #10 clk = ~clk;
    initial begin
        clk = 0;
        rst = 1; RegWrite = 0;
        Rs1_addr = 0; Rs2_addr = 0; Wt_addr = 0;
        Wt_data = 0;
        #100;//initial
        rst = 0;RegWrite = 1;
        Wt_addr = 5'b00101;
        Wt_data = 32'ha5a5a5a5;
        #50;
        Wt_addr = 5'b01010;
        Wt_data = 32'h5a5a5a5a;
        #50;
        RegWrite = 0;
        Rs1_addr = 5'b00101;
        Rs2_addr = 5'b01010;
        #100;
        $finish;
    end
endmodule
