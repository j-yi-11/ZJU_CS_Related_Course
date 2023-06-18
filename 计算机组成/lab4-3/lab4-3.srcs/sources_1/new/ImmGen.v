`timescale 1ns / 1ps
module ImmGen(
    input wire [2:0] ImmSel,
    input wire [31:0] inst_field,
    output reg [31:0] Imm_out
    );
    always @(*) begin
        case (ImmSel)
            3'b000://u-type
                Imm_out = {inst_field[31:12],12'h000};
            3'b001://i
                Imm_out = { {20{inst_field[31]}}, inst_field[31:20]};
            3'b010://s
                Imm_out = { {20{inst_field[31]}}, inst_field[31:25], inst_field[11:7]};
            3'b011://b
                Imm_out = { {20{inst_field[31]}}, inst_field[7], inst_field[30:25], inst_field[11:8], 1'b0};
                //20 + 1 + 6 + 4 + 1 == 32
            3'b100://j
                Imm_out = { {12{inst_field[31]}}, inst_field[19:12], inst_field[20], inst_field[30:21], 1'b0};
            default:
                Imm_out = 32'hxxxxxxxx;
        endcase
    end
endmodule
