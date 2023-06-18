`timescale 1ns / 1ps
module DataPath(
    input wire clk,
    input wire rst,
    //control
    input wire Jump,
    input wire Branch,
    input wire [1:0] MemtoReg,
    input wire ALUSrc_B,
    input wire RegWrite,
    input wire [1:0] ImmSel,
    input wire [2:0] ALU_operation,
    //input data, inst
    input wire [31:0] Data_in,
    input wire [31:0] inst_field,// Inst_in
    //output
    output reg [31:0] PC_out,
    output reg [31:0] Data_out,
    output reg [31:0] ALU_out
    );
    //generate imm
    wire [31:0] Imm_out;
    ImmGen myImmGen(
        .ImmSel(ImmSel),
        .inst_field(inst_field),
        .Imm_out(Imm_out)
    );
    //pc
    wire rs_rt_equal;
    wire [31:0] PC_next;
    wire [31:0] PC_jump;
    assign PC_next = PC_out + 4;
    assign PC_jump = PC_out + Imm_out;
    always @(posedge clk or posedge rst) begin
        if(rst)//reset pc -> 0
        begin
            PC_out <= 0;
        end
        else if(Jump)
        begin
            PC_out <= PC_jump;
        end
        else if(Branch)
        begin
            PC_out <= (rs_rt_equal) ? PC_jump : PC_next;
        end
        else
        begin
            PC_out <= PC_next;
        end
    end
    //reg
    wire [4:0] Rs1_addr;
    wire [4:0] Rs2_addr;
    wire [4:0] Wt_addr;
    assign Rs1_addr = inst_field[19:15];
    assign Rs2_addr = inst_field[24:20];
    assign Wt_addr = inst_field[11:7];
    reg [31:0] Wt_data;
    wire [31:0] Rs1_data;
    wire [31:0] Rs2_data;
    always @(*) begin
        case(MemtoReg)
            2'b00: Wt_data = ALU_out;
            2'b01: Wt_data = Data_in;
            2'b10: Wt_data = PC_next;
            2'b11: Wt_data = PC_next;
        endcase
    end
    regs myRegs(
        .clk(clk),
        .rst(rst),
        .Rs1_addr(Rs1_addr),
        .Rs2_addr(Rs2_addr),
        .Wt_addr(Wt_addr),
        .Rs1_data(Rs1_data),
        .Rs2_data(Rs2_data),
        .Wt_data(Wt_data),
        .RegWrite(RegWrite)
    );
    assign rs_rt_equal = (Rs1_data == Rs2_data) ? 1 : 0;
    //alu
    reg [31:0] alu_a;
    reg [31:0] alu_b;
    wire zero;
    wire [31:0] alu_out;
    always @(*) begin
        alu_a = Rs1_data;
        case(ALUSrc_B)
            1'b0: alu_b = Rs2_data;
            1'b1: alu_b = Imm_out;
        endcase
    end
    ALU myALU(
        .A(alu_a),
        .B(alu_b),
        .ALU_operation(ALU_operation),
        .res(alu_out),
        .zero(zero)
    );
    //data out and slu out
    always @(*) begin
        Data_out = Rs2_addr;
        ALU_out = alu_out;
    end
endmodule
