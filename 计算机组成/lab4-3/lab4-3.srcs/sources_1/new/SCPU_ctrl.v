`timescale 1ns / 1ps
module SCPU_ctrl(
    input [4:0] OPcode,
    input [2:0] Fun3,
    input Fun7,
    input MIO_ready,
    output reg [2:0] ImmSel,
    output reg ALUSrc_B,
    output reg [1:0] MemtoReg,
    output reg [1:0]Jump,
    output reg Branch, 
    output reg BranchN,
    output reg RegWrite,
    output reg MemRW,
    output reg [3:0] ALU_Control,
    output reg CPU_MIO
);
    reg [15:0] CPU_ctrl_signals;
    wire [3:0] Fun;
    `define CPU_ctrl_signals {ALUSrc_B,MemtoReg,RegWrite,MemRW,Branch,BranchN,Jump,ALU_Control,ImmSel}
    assign Fun = {Fun3,Fun7};
    always @(*) begin
        case(OPcode)
        5'b01100: //R-type add;;;
        begin 
            `CPU_ctrl_signals = {1'b0,2'b00,1'b1,1'b0,1'b0,1'b0,2'b00,4'bxxxx,3'b001};
            begin
                case(Fun)
                    4'b0000:ALU_Control = 4'b0010 ;//add
                    4'b0001:ALU_Control = 4'b0110;//sub
                    4'b0010:ALU_Control = 4'b1110 ;//sll
                    4'b0100:ALU_Control = 4'b0111;//slt
                    4'b0110: ALU_Control = 4'b1001;//sltu
                    4'b1000:ALU_Control = 4'b1100;//xor
                    4'b1010: ALU_Control = 4'b1101;//srl
                    4'b1011: ALU_Control = 4'b1111;//sra
                    4'b1100:ALU_Control = 4'b0001 ;//or
                    4'b1110:ALU_Control = 4'b0000;//and
                    default: ALU_Control = 4'b0010;
                endcase
            end
        end
        5'b00000: //I-type Lw 
        begin 
            `CPU_ctrl_signals = {1'b1,2'b01,1'b1,1'b0,1'b0,1'b0,2'b00,4'b0010,3'b001}; 
        end 
        5'b00100://I-type ALU(addi;;;)
        begin
            `CPU_ctrl_signals = {1'b1,2'b00,1'b1,1'b0,1'b0,1'b0,2'b00,4'bxxxx,3'b001};
            begin
                case(Fun3)
                3'b000: ALU_Control = 4'b0010 ;//add
                3'b010: ALU_Control = 4'b0111;//slt
                3'b011: ALU_Control = 4'b1001;//sltu
                3'b100: ALU_Control = 4'b1100;//xor
                3'b110: ALU_Control = 4'b0001;//or
                3'b111: ALU_Control = 4'b0000 ;//and
                3'b001: ALU_Control = 4'b1110 ;//sll
                3'b101:   
                    begin
                        case(Fun7)
                            1'b0: ALU_Control = 4'b1101;//srl
                            1'b1: ALU_Control = 4'b1111 ; //sra
                        endcase   
                    end
                default: ALU_Control = 4'bxxxx; 
                endcase                             
            end
        end
        5'b11001: //I-type jalr
        begin 
            `CPU_ctrl_signals = {1'b1,2'b10,1'b1,1'b0,1'b0,1'b0,2'b10,4'b0010,3'b001}; 
        end 
        5'b01000: //S-type Sw 
        begin 
            `CPU_ctrl_signals = {1'b1,2'b00,1'b0,1'b1,1'b0,1'b0,2'b00,4'b0010,3'b010}; 
        end 
        5'b11000://B-type beq,bne branch   buyiyyang
        begin
            `CPU_ctrl_signals = {1'b0,2'b00,1'b0,1'b0,1'b0,1'b0,2'b00,4'b0110,3'b011};
            begin
                case(Fun3)
                    3'b000:begin Branch = 1; BranchN = 0; end
                    3'b001:begin BranchN = 1; Branch = 0;end
                    default: begin Branch = 0;BranchN = 0; end
                endcase
            end
        end
        5'b11011: //J-type jal
        begin 
            `CPU_ctrl_signals = {1'b1,2'b10,1'b1,1'b0,1'b0,1'b0,2'b01,4'b0010,3'b100};
        end 
        5'b00101: //u-type 
        begin 
            `CPU_ctrl_signals = {1'bx,2'b11,1'b1,1'b0,1'b0,1'b0,2'b00,4'bxxxx,3'b000}; 
        end 
        5'b01101: //U-type lui 
        begin 
            `CPU_ctrl_signals = {1'b0,2'b11,1'b1,1'b0,1'b0,1'b0,2'b00,4'b0010,3'b000};
        end 
        default: 
        begin 
            `CPU_ctrl_signals = {1'b0,2'b00,1'b0,1'b0,1'b0,1'b0,2'b00,4'bxxxx,3'b000};
        end
        endcase
    end
endmodule