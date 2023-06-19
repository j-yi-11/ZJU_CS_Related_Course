`timescale 1ns / 1ps
module div32(
        input    clk,
		input    rst,
        input    start,
        input    [31:0] dividend, 
        input    [31:0] divisor,
        output    finish,
        output    [31:0] quotient,
        output    [31:0] remainder//,
//        output    [63:0] tempRemainder,
//        output    [31:0] tempQuotient
); 
    reg [63:0] temp_divisor;
    reg [31:0] temp_quotient;
//    assign tempQuotient = temp_remainder[31:0];//
    reg [63:0] temp_remainder;
//    assign tempRemainder = temp_remainder;
    reg remainder_sign;
    reg quotient_sign;
    reg [5:0] count;
    wire        op1_sign;      //
    wire        op2_sign;      //
    wire [31:0] op1_absolute;  //
    wire [31:0] op2_absolute;  //
    assign op1_sign = dividend[31];
    assign op2_sign = divisor[31];
    assign op1_absolute = op1_sign ? (~dividend+1) : dividend;
    assign op2_absolute = op2_sign ? (~divisor+1) : divisor;
    assign remainder = remainder_sign ? (~temp_remainder[63:32]+1) : temp_remainder[63:32];
    assign quotient = quotient_sign ? (~temp_remainder[31:0]+1) : temp_remainder[31:0];//temp_quotient
    reg finishflag;
    assign finish = finishflag;
    always @(posedge clk) 
    begin
        if(rst==1)
            begin
                temp_quotient <= 0;
                temp_remainder <= 0;
                temp_divisor <= 0;
                finishflag <= 0;
            end
        else if(rst==0 && start==1)
            begin
                finishflag <= 0;
                count <= 0;
                remainder_sign <= op1_sign;
                quotient_sign <= op1_sign^op2_sign;
                temp_remainder <= {31'b0,op1_absolute,1'b0};//,1'b0 shift remainder left 1 bit
                temp_divisor <= {op2_absolute[31:0],32'b0};
                temp_quotient <= 0; 
            end
        else if(rst==0 && start==0 && finishflag==0)
            begin
                if(count<=31)//31
                    begin
                        count = count + 1;//<=
                        temp_remainder = temp_remainder - temp_divisor;//+ (~temp_divisor) + 1         remainder-divisor
                        if( temp_remainder[63] == 0 )//r>=0
                            begin
                                //temp_quotient <= {temp_quotient[30:0],1'b1};//
                                temp_remainder = {temp_remainder[62:0],1'b1};
                            end 
                        else if( temp_remainder[63] == 1 )//r<0
                            begin
                                temp_remainder = temp_remainder + temp_divisor;
                                temp_remainder = {temp_remainder[62:0],1'b0};
                                //temp_quotient <= {temp_quotient[30:0],1'b0};
                            end
                      //temp_divisor = {1'b0,temp_divisor[63:1]};//shift temp_divisor right 1 bit
                    end
                else
                    begin
                        count <= 0;
                        finishflag <= 1;
                        temp_remainder <= {1'b0,temp_remainder[63:33],temp_remainder[31:0]};
                    end

            end
    end
		
    
    
	endmodule




// module div32
// (
//     input clk,
//     input rst,
//     input start,
//     input[31:0] dividend,// a
//     input[31:0] divisor,//b
//     output [31:0] quotient,//reg yshang
//     output [31:0] remainder,//reg yyushu
//     output finish//reg calc_done
// );
//     reg[31:0] tempa;
//     reg[31:0] tempb;
//     reg[63:0] temp_a;
//     reg[63:0] temp_b;
//     reg [5:0] counter;
//     always @(dividend or divisor)
//     begin
//         tempa <= dividend;
//         tempb <= divisor;
//     end
//     always @(posedge clk)
//     begin
//         if(rst==1)
//             begin
//                 temp_a <= 64'h0000_0000_0000_0000;
//                 temp_b <= 64'h0000_0000_0000_0000;	
//                 finish <= 1'b0;//calc_done
//             end
//         else if(rst==0 && start==0)
//             begin
//                 if(counter <= 31)
//                     begin
//                         temp_a <= {temp_a[62:0],1'b0};
//                         if(temp_a[63:32] >= tempb)
//                             begin
//                                 temp_a <= temp_a - temp_b + 1'b1;
//                             end
//                         else
//                             begin
//                                 temp_a <= temp_a;
//                             end
//                         counter <= counter + 1;
//                         finish <= 1'b0;//calc_done
//                     end
//                 else
//                     begin
//                         counter <= 0;
//                         finish <= 1'b1;//calc_done
//                         temp_a <= {32'h00000000,tempa};
//                         temp_b <= {tempb,32'h00000000}; 
//                         quotient <= temp_a[31:0];//yshang
//                         remainder <= temp_a[63:32];//yyushu
//                     end
//             end
//         else if(rst==0 && start==1)
//             begin
//                 finish <= 1'b0;//calc_done
//                 temp_a <= tempa;
//                 temp_b <= tempb;
//                 quotient <= dividend;
//                 remainder <= 0;
//             end
    
//     end
 
// endmodule
 
/*************** EOF ******************/
