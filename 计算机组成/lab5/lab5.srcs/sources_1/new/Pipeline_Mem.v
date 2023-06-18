`timescale 1ns / 1ps
module Pipeline_Mem(
    input zero_in_Mem,
    input Branch_in_Mem,
    input BranchN_in_Mem,
    input Jump_in_Mem,//[1:0] 
    output PCSrc
    );
    /*isbne = ~zero & BranchN*/
    wire       AND2_Res;
    AND AND2
           (.Op1(~zero_in_Mem),
            .Op2(BranchN_in_Mem),
            .Res(AND2_Res));
    /*isbeq = zero & Branch*/
    wire       AND3_Res;            
    AND AND3
           (.Op1(Branch_in_Mem),
            .Op2(zero_in_Mem),
            .Res(AND3_Res));
    /*beq | bne*/
    wire       or0_Res;
    OR or0
           (.Op1(AND2_Res),
            .Op2(AND3_Res),
            .Res(or0_Res));
	/*PCSrc = beq | bne | jal | jalr*/
	assign PCSrc = Jump_in_Mem | or0_Res;
//	assign PCSrc = Jump_in_Mem[0] | Jump_in_Mem[1] | or0_Res;
endmodule