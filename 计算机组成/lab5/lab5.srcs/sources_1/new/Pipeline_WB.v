`timescale 1ns / 1ps
module Pipeline_WB( 
    input[31:0]  PC4_in_WB, 
    input[31:0] ALU_in_WB,
    input[31:0] DMem_data_WB, 
    input[1:0] MemtoReg_in_WB, 
    output [31:0] Data_out_WB   
);
    MUX4T1_32 MUX4T1_32(
        .s(MemtoReg_in_WB),
		.I0(ALU_in_WB),
		.I1(DMem_data_WB),
		.I2(PC4_in_WB),
		.I3(PC4_in_WB),						
		.o(Data_out_WB)
    );
endmodule
