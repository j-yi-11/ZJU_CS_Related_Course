//`timescale 1ns / 1ps
//module SCPU_ctrl(
//    input [4:0] OPcode,
//    input [2:0] Fun3,
//    input Fun7,
//    input MIO_ready,
//    output reg [1:0] ImmSel,
//    output reg ALUSrc_B,
//    output reg [1:0] MemtoReg,
//    output reg Jump,
//    output reg Branch,
//    output reg RegWrite,
//    output reg MemRW,
//    output reg [2:0] ALU_Control,
//    output reg CPU_MIO
//    );
//    reg [1:0] ALUop;
//    `define CPU_ctrl_signals {ALUSrc_B,MemtoReg,RegWrite,MemRW,Branch,Jump,ALUop,ImmSel}
//    always @ * 
//    begin
//        case(OPcode)
//            5'b01100: begin `CPU_ctrl_signals = {1'b0,2'b00,1'b1,1'b0,1'b0,1'b0,2'b00,2'b00}; end //ALU
//            5'b00000: begin `CPU_ctrl_signals = {1'b1,2'b01,1'b1,1'b0,1'b0,1'b0,2'b01,2'b00}; end //load
//            5'b01000: begin `CPU_ctrl_signals = {1'b1,2'b00,1'b0,1'b1,1'b0,1'b0,2'b10,2'b01}; end //store
//            5'b11000: begin `CPU_ctrl_signals = {1'b0,2'b00,1'b0,1'b0,1'b1,1'b0,2'b11,2'b10}; end //beq
//            5'b11011: begin `CPU_ctrl_signals = {1'b0,2'b10,1'b1,1'b0,1'b0,1'b1,2'b00,2'b11}; end //jump
//            5'b00100: begin `CPU_ctrl_signals = {1'b1,2'b00,1'b1,1'b0,1'b0,1'b0,2'b01,2'b00}; end // addi
//        endcase
//    end
//    wire [3:0] Fun;
//    assign Fun = {Fun3,Fun7};
//    always @(*)
//    begin//bug
//        case(ALUop)
//            2'b10: ALU_Control = 3'b010 ;//add 计算地址
//            2'b11: ALU_Control = 3'b110 ;//sub 比较条件
//            2'b00://alu
//            case(Fun)
//                4'b0000: ALU_Control = 3'b010 ;//add
//                4'b0001: ALU_Control = 3'b110 ;//sub
//                4'b1110: ALU_Control = 3'b000 ;//and
//                4'b1100: ALU_Control = 3'b001 ;//or
//                4'b0100: ALU_Control = 3'b111 ;//slt
//                4'b1010: ALU_Control = 3'b101 ;//srl
//                4'b1000: ALU_Control = 3'b011 ;//xor
//                default: ALU_Control = 3'bx;
//            endcase
//            2'b01:
//            case(OPcode)
//                5'b00000: ALU_Control = 3'b010; //load
//                5'b00100://imm
//                case(Fun3)
//                    3'b010: ALU_Control=3'b111;//slt
//                    3'b000: ALU_Control=3'b010;//add
//                    3'b100: ALU_Control=3'b011;//xor
//                    3'b110: ALU_Control=3'b001;//or
//                    3'b111: ALU_Control=3'b000;//and
//                    3'b101: ALU_Control=3'b101;//srl
//                    default: ALU_Control=3'bx;
//                endcase
//                default: ALU_Control=3'bx;
//            endcase
//        endcase
//    end
//endmodule


`timescale 1ns / 1ps
module SCPU_ctrl(
    input [4:0] OPcode,
    input [2:0] Fun3,
    input Fun7,
    input MIO_ready,
    output reg [1:0] ImmSel,
    output reg ALUSrc_B,
    output reg [1:0] MemtoReg,
    output reg Jump,
    output reg Branch,
    output reg RegWrite,
    output reg MemRW,
    output reg [2:0] ALU_Control,
    output reg CPU_MIO
    );
    reg [1:0] ALUop;
    `define CPU_ctrl_signals {ALUSrc_B,MemtoReg,RegWrite,MemRW,Branch,Jump,ALUop,ImmSel}
    always @ * 
    begin
        case(OPcode)//ALUop modified to ppt

            5'b01100: begin `CPU_ctrl_signals = {1'b0,2'b00,1'b1,1'b0,1'b0,1'b0,2'b10,2'b00}; end //ALU(R)

            5'b00000: begin `CPU_ctrl_signals = {1'b1,2'b01,1'b1,1'b0,1'b0,1'b0,2'b00,2'b00}; end //load(I)

            5'b01000: begin `CPU_ctrl_signals = {1'b1,2'b00,1'b0,1'b1,1'b0,1'b0,2'b00,2'b01}; end //store(S)

            5'b11000: begin `CPU_ctrl_signals = {1'b0,2'b00,1'b0,1'b0,1'b1,1'b0,2'b01,2'b10}; end //beq(B)

            5'b11011: begin `CPU_ctrl_signals = {1'b0,2'b10,1'b1,1'b0,1'b0,1'b1,2'b00,2'b11}; end //jump, ALUop = xx

            5'b00100: begin `CPU_ctrl_signals = {1'b1,2'b00,1'b1,1'b0,1'b0,1'b0,2'b11,2'b00}; end //imm(I)
        endcase
    end
    wire [3:0] Fun;
    assign Fun = {Fun3,Fun7};
    always @(*)
    begin//bug
        case(ALUop)
            2'b00: ALU_Control = 3'b010 ;//add address for load and store and jump
            2'b01: ALU_Control = 3'b110 ;//sub for beq 
            2'b10://ALU 
            case(Fun)
                4'b0000: ALU_Control = 3'b010 ;//add
                4'b0001: ALU_Control = 3'b110 ;//sub
                4'b1110: ALU_Control = 3'b000 ;//and
                4'b1100: ALU_Control = 3'b001 ;//or
                4'b0100: ALU_Control = 3'b111 ;//slt
                4'b1010: ALU_Control = 3'b101 ;//srl
                4'b1000: ALU_Control = 3'b011 ;//xor
                default: ALU_Control = 3'bx;
            endcase
            2'b11://imm
            case(OPcode)
                5'b00000: ALU_Control = 3'b010; //load
                5'b00100://imm
                case(Fun3)
                    3'b010: ALU_Control=3'b111;//slt
                    3'b000: ALU_Control=3'b010;//add
                    3'b100: ALU_Control=3'b011;//xor
                    3'b110: ALU_Control=3'b001;//or
                    3'b111: ALU_Control=3'b000;//and
                    3'b101: ALU_Control=3'b101;//srl
                    default: ALU_Control=3'bx;
                endcase
                default: ALU_Control=3'bx;
            endcase
        endcase
    end
endmodule
