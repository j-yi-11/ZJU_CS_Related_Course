`timescale 1ns / 1ps

module ImmGen(
              input  wire [1:0] ImmSel,//[2:0]
	          input  wire [31:0] inst_field,
	          output reg  [31:0] Imm_out
    );
    always @(*) begin
        case (ImmSel)
            2'b00 : Imm_out = { {20 {inst_field[31]} }, inst_field[31:20]};//addi/lw(I)
            2'b01 : Imm_out = { {20 {inst_field[31]} }, inst_field[31:25], inst_field[11:7]};//sw(s)
            2'b10 : Imm_out = { {19 {inst_field[31]} }, inst_field[31], inst_field[30:25], inst_field[11:8], 1'b0};//beq(sb)
            2'b11 : Imm_out = { {11 {inst_field[31]} }, inst_field[31], inst_field[19:12], inst_field[20], inst_field[30:21], 1'b0};//jal(uj) 
            default: Imm_out = 32'b0;
        endcase
    end
//    always @(*) begin
//       case(ImmSel)
//           3'b000:Imm_out = {inst_field[31:12],12'h000};//lui
//           3'b001:Imm_out = {{20{inst_field[31]}},inst_field[31:20]};//addi\lw(I)\jalr
//           3'b010:Imm_out = {{20{inst_field[31]}},inst_field[31:25],inst_field[11:7]};//sw(s)
//           3'b011:Imm_out = {{19{inst_field[31]}},inst_field[31],inst_field[7],inst_field[30:25],inst_field[11:8],1'b0};//beq\bne(b)
//           3'b100:Imm_out = {{11{inst_field[31]}},inst_field[31],inst_field[19:12],inst_field[20],inst_field[30:21],1'b0};//jal(j)
//           default:Imm_out = 32'b0;
//       endcase
//     end
endmodule
