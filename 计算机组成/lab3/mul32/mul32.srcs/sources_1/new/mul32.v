`timescale 1ns / 1ps
module mul32( // 32bit�˷���
  input clk,
  input rst,
  input [31:0] multiplicand,// x
  input [31:0] multiplier,//y
  input start,//
  output [63:0] product,//
  output finish//
);
    reg  product_sign;	//
    reg  [31:0] temp_multiplicand;//x
    reg [63:0] product_temp;	//
    wire [63:0] partial_product;
    wire        op1_sign;      
    wire        op2_sign;     
    wire [31:0] op1_absolute;  
    wire [31:0] op2_absolute;  
    assign op1_sign = multiplicand[31];
    assign op2_sign = multiplier[31];
    assign op1_absolute = op1_sign ? (~multiplicand+1) : multiplicand;
    assign op2_absolute = op2_sign ? (~multiplier+1) : multiplier;  
    reg finishflag;
    assign finish = finishflag;
    reg [5:0] count;
    assign product = product_sign ? (~product_temp+1) : product_temp;//correct
    always @(posedge clk)/*initial the value*/
        begin
            if( rst == 1 )
                begin
                    finishflag<=0;
                    count <= 0;
                    product_temp <= 0;
                    product_sign <= 0;
                    temp_multiplicand <= 0;//x
                end
            else if( rst == 0 && start == 1 && finishflag == 0 )
                begin
                    finishflag <= 0;
                    count <= 0;
                    product_temp <= {32'b0,op2_absolute};//y
                    product_sign <= op1_sign^op2_sign;
                    temp_multiplicand <= op1_absolute;//x                  
                end
            else if( rst == 0 && start == 0 && finishflag == 0 )
                begin
                    if(count<=31)
                        begin
                            count = count + 1;//<=
                            if(product_temp[0] == 1)
                                begin
                                    product_temp = {temp_multiplicand,32'b0} + product_temp;
                                end
                            product_temp = {1'b0,product_temp[63:1]};
                        end
                    else 
                        begin
                            count <= 0;
                            finishflag <= 1;
                        end
                end
        end









    // reg  product_sign;	//�˻�����ķ���??
    // reg  [31:0] temp_multiplier;// y
    // reg  [63:0] temp_multiplicand;//x
    // reg [63:0] product_temp;		//��ʱ���??
    // wire [63:0] partial_product;
    // wire        op1_sign;      //������1�ķ���λ
    // wire        op2_sign;      //������2�ķ���λ
    // wire [31:0] op1_absolute;  //������1�ľ���ֵ
    // wire [31:0] op2_absolute;  //������2�ľ���ֵ
    // assign op1_sign = multiplicand[31];
    // assign op2_sign = multiplier[31];
    // assign op1_absolute = op1_sign ? (~multiplicand+1) : multiplicand;
    // assign op2_absolute = op2_sign ? (~multiplier+1) : multiplier;
    // assign partial_product = temp_multiplier[0] ? temp_multiplicand : 64'b0;       
    // reg finishflag;
    // assign finish = finishflag;//valid & ~(|temp_multiplier);
    // reg [5:0] count;
    // assign product = product_sign ? (~product_temp+1) : product_temp;
    // always @(posedge clk)/*initial the value*/
    //     begin
    //         if( rst == 1 )
    //             begin
    //                 finishflag<=0;//valid <= 0;
    //                 count <= 0;
    //                 product_temp <= 0;
    //                 product_sign <= 0;
    //                 temp_multiplicand <= 0;
    //                 temp_multiplier <= 0;
    //             end
    //         else if( rst == 0 && start == 1 && finishflag == 0 )
    //             begin
    //                 finishflag<=0;//valid <= 0;
    //                 count <= 0;
    //                 product_temp <= 0;
    //                 product_sign <= op1_sign^op2_sign;
    //                 temp_multiplicand <= multiplicand;
    //                 temp_multiplier <= multiplier;                    
    //             end
    //         else if( rst == 0 && start == 0 && finishflag == 0 )
    //             begin
    //                 if(count<=31)
    //                     begin
    //                         count = count + 1;//<=
    //                         product_temp = product_temp + partial_product;
    //                         temp_multiplicand = {temp_multiplicand[62:0],1'b0};
    //                         temp_multiplier = {1'b0,temp_multiplier[31:1]};
    //                     end
    //                 else 
    //                     begin
    //                         count <= 0;
    //                         finishflag <= 1;
    //                     end
    //                 // valid <= 1;

    //             end
    //     end
    
 

//https://blog.csdn.net/weixin_43074474/article/details/90473709    
endmodule
