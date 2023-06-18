`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/09 16:34:11
// Design Name: 
// Module Name: seq_moore_tb
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


module seq_moore_tb(

    );
endmodule


module seq_moore_tb;
     reg clk;
	 reg reset;
	 reg in;
	 wire out;
	 
 always #20 clk = ~clk;
 
 //initial
   //  begin
	//end
	
 //011100101
 initial
     begin
         clk = 0;
		 reset = 0;
		 #20 
		 reset = 1;

	     in = 0;
		 #20
		 in = 1;
		 #40
		 in = 1;
		 #40
		 in = 1;
		 #40
		 in = 0;
		 #40
		 in = 0;
		 #40
		 in = 1;
		 #40
		 in = 0;
		 #40
		 in = 1;
		 #40
		 $finish;
		 end

 seq_moore seq_moore_U(
     .clk(clk),
	 .reset(reset),
	 .in(in),
	 .out(out)
	);
endmodule