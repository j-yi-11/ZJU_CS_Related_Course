`timescale 1ns / 1ps
module div32_tb();
      reg clk;
      reg rst;
      reg [31:0] dividend;
      reg [31:0] divisor;
      reg start;
      wire [31:0] quotient;
      wire [31:0] remainder;
      wire finish;
      //debug
//      wire [63:0] tempRemainder;
//      wire [31:0] tempQuotient;
      //debug
      div32   div32_U(
         .clk(clk),
         .rst(rst),
         .dividend(dividend),
         .divisor(divisor),
         .start(start),
         .quotient(quotient),
         .remainder(remainder),
         .finish(finish)//,debug
//         .tempRemainder(tempRemainder),
//         .tempQuotient(tempQuotient)
         //debug
      );
      always #5 clk = ~clk;
      
      initial begin
       clk =0;rst = 1;start = 0;#10
       rst = 0;start = 1;dividend = 32'd8;divisor = 32'd4;#50
       rst = 0;start = 0;dividend = 32'd8;divisor = 32'd4;       
           #335
       rst = 0;start = 1;dividend = 32'd100;divisor  = 32'd10;#50   
       rst = 0;start = 0;dividend = 32'd100;divisor  = 32'd10;
           #335     
       rst = 0;start = 1;dividend = 32'd9;divisor  = 32'd4;#50
       rst = 0;start = 0;dividend = 32'd9;divisor  = 32'd4; 
           #340            
       rst = 0;start = 1;dividend = 32'd100;divisor  = 32'd99;#50
       rst = 0;start = 0;dividend = 32'd100;divisor  = 32'd99;  
           #350 $stop();   
      
      end
endmodule