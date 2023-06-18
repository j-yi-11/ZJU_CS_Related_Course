//`timescale 1ns / 1ps
//module ALU(input [31:0]A, B, 
// 		  input[3:0] ALU_operation, 
//		  output reg[31:0]   res, 
//		  output zero, overflow
//    );
//     parameter one = 32'h00000001, zero_0 = 32'h00000000;
     
//always @ (*)
//         case (ALU_operation)
//                         4'b0000: res=A&B;    
//                         4'b0001: res=A|B;    
//                         4'b0010: res=A+B;    
//                         4'b1100: res=A^B;
//                         4'b0110: res=A-B;    
//                         4'b1101: res=A>>B[4:0];//srl
//                         4'b1111: res=$signed(A)>>>$signed(B[4:0]);//sra
//                         4'b1001: res=(A < B) ? one : zero_0;//sltu
//                         4'b0111: res=($signed(A) < $signed(B)) ? one : zero_0;
//                         4'b1110: res=A<<B[4:0];
//                         default: res=32'h00000000;
//         endcase
// assign zero = (res==0)? 1: 0;
    
//endmodule


`timescale 1ns / 1ps
module ALU(
    input [31:0] A,
    input [31:0] B,
    input [2:0] ALU_operation,
    output reg[31:0] res,
    output zero
    );
    parameter one = 32'h00000001;
    parameter zero_0 = 32'h00000000;
    always @ (*) begin
        case (ALU_operation)
        3'b000: res=A&B;//and
        3'b001: res=A|B;//or
        3'b010: res=A+B;//add
        3'b011: res=A^B;//xor
        3'b110: res=A-B;//sub
        3'b101: res = A>>B[4:0];//srl
        3'b111: res=($signed(A) < $signed(B)) ? one : zero_0;//slt
        default: res=32'h00000000;
        endcase
    end
    assign zero = (res==0)? 1: 0;    
endmodule
