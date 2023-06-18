`timescale 1ns / 1ps
module stall(
    input rst_stall, 
    input RegWrite_out_IDEX, 
    input [4:0]Rd_addr_out_IDEX, 
    input RegWrite_out_EXMem, 
    input [4:0]Rd_addr_out_EXMem, 
    input [4:0]Rs1_addr_ID, 
    input [4:0]Rs2_addr_ID, 
    input Rs1_used, 
    input Rs2_used, 
    input Branch_ID, //beq
    input BranchN_ID, //bne
    input [1:0] Jump_ID, //jal
    input Branch_out_IDEX, //beq
    input BranchN_out_IDEX, //¡Œbne
    input [1:0] Jump_out_IDEX, //jal
    input Branch_out_EXMem, //beq
    input BranchN_out_EXMem, //bne
    input [1:0] Jump_out_EXMem, //jal
    output reg en_IF, //
    output reg en_IFID,
    output reg NOP_IFID,
    output reg NOP_IDEX
    );
    /*data hazard*/
    reg Data_stall;
    always @(*) begin
        /*-----------Mem hazard-----------*/
        if(RegWrite_out_EXMem && Rs1_used && (Rs1_addr_ID!=0) && (Rd_addr_out_EXMem == Rs1_addr_ID)) begin
            Data_stall = 1;
        end else begin
            if(RegWrite_out_EXMem && Rs2_used && (Rs2_addr_ID!=0) && (Rd_addr_out_EXMem == Rs2_addr_ID)) begin
                Data_stall = 1;
            end
            /*-----------Ex hazard-----------*/
            else begin
                if(RegWrite_out_IDEX && Rs1_used && (Rs1_addr_ID!=0) && (Rd_addr_out_IDEX == Rs1_addr_ID)) begin
                    Data_stall = 1;
                end
                else begin
                    if(RegWrite_out_IDEX && Rs2_used && (Rs2_addr_ID!=0) && (Rd_addr_out_IDEX == Rs2_addr_ID)) begin
                        Data_stall = 1;
                    end
                    else begin
                        Data_stall = 0;
                    end
                end
            end
        end
    end
    /*Control hazard*/
    reg Control_stall;
    always @(*) begin
        if((Branch_ID || BranchN_ID || Jump_ID[0] || Jump_ID[1]) || (Branch_out_IDEX || BranchN_out_IDEX || Jump_out_IDEX[0] || Jump_out_IDEX[1]) || (Branch_out_EXMem || BranchN_out_EXMem || Jump_out_EXMem[0] || Jump_out_EXMem[1])) begin
            Control_stall = 1;
        end else begin
            Control_stall = 0;
        end
    end
    /*Insert stall*/
    always @(*) begin
        if(rst_stall) begin
            en_IF = 1;
            en_IFID = 1;
            NOP_IDEX = 0;
            NOP_IFID = 0;
        end else begin
            if (Control_stall) begin
                NOP_IFID = 1;   //Insert nop
            end
            else begin
                NOP_IFID = 0;
            end
            if (Data_stall) begin
                en_IF= 0;
                en_IFID= 0;     //Hold pc and if/id reg
                NOP_IDEX= 1;    //insert nop and disable REGWrite,MemRW
            end
            else begin
                en_IF= 1;
                en_IFID= 1;
                NOP_IDEX=0;
            end
        end
    end
endmodule
