`timescale 1ns / 1ps
module SCPU_ctrl_tb();
    reg[4:0] OPcode; //OPcode
    reg[2:0] Fun3; //Function
    reg Fun7; //Function
    reg MIO_ready; //CPU Wait
    wire [2:0]ImmSel;
    wire ALUSrc_B;
    wire [1:0] MemtoReg;
    wire [1:0] Jump;
    wire Branch;
    wire BranchN;
    wire RegWrite;
    wire MemRW;
    wire [3:0]ALU_Control;
    wire CPU_MIO;
    SCPU_ctrl SCPU_ctrl_U(
        .OPcode (OPcode ),
        .Fun3 (Fun3),
        .Fun7 (Fun7),
        .MIO_ready (MIO_ready),
        .ImmSel (ImmSel),
        .ALUSrc_B (ALUSrc_B),
        .MemtoReg (MemtoReg),
        .Jump (Jump ),
        .Branch (Branch),
        .BranchN(BranchN),
        .RegWrite (RegWrite ),
        .MemRW (MemRW ),
        .ALU_Control (ALU_Control),
        .CPU_MIO (CPU_MIO )
    );
    initial begin
        OPcode = 0;
        Fun3 = 0;
        Fun7 = 0;
        MIO_ready = 0;
        #40;
        OPcode = 5'b01100; //R
        Fun3 = 3'b000;Fun7 = 1'b0; //add
        #20;
        Fun3 = 3'b000;Fun7 = 1'b1; //sub
        #20;
        Fun3 = 3'b111;Fun7 = 1'b0; //and
        #20;
        Fun3 = 3'b110;Fun7 = 1'b0; //or
        #20;
        Fun3 = 3'b010;Fun7 = 1'b0; //slt
        #20;
        Fun3 = 3'b101;Fun7 = 1'b0; //srl
        #20;
        Fun3 = 3'b100;Fun7 = 1'b0; //xor
        #20;
        Fun3 = 3'b111;Fun7 = 1'b1;
        #20;
        OPcode = 5'b00000; //load
        #20;
        OPcode = 5'b01000; //store
        #20;
        OPcode = 5'b11000; //beq
        #20;
        OPcode = 5'b11011; //jal
        #40;
        OPcode = 5'b00100; //I
        Fun3 = 3'b000; //addi
        #20;
        Fun3 = 3'b111; //andi
        
        #20;
        Fun3 = 3'b110; //ori
        #20;
        Fun3 = 3'b010; //slti
        #20;
        Fun3 = 3'b101; //srli
        #20;
        Fun3 = 3'b100; //xori
        #20
        OPcode = 5'h1f;
        Fun3 = 3'b000;
        Fun7 = 1'b0;
    end
endmodule