`timescale 1ns / 1ps
module CSSTE(
    input clk_100mhz,
    input RSTN,
    input [3:0] BTN_y,
    input [15:0] SW,
    output [3:0] Blue,
    output [3:0] Green,
    output [3:0] Red,
    output HSYNC,
    output VSYNC,
    output LED_PEN,
    output SEG_PEN,
    output led_clk,
    output led_clrn,
    output led_sout,
    output seg_clk,
    output seg_clrn,
    output seg_sout//,
//    output wire [31:0] x0,
//    output wire [31:0] ra,
//    output wire [31:0] sp,
//    output wire [31:0] gp,
//    output wire [31:0] tp,
//    output wire [31:0] t0,
//    output wire [31:0] t1,
//    output wire [31:0] t2,
//    output wire [31:0] s0,
//    output wire [31:0] s1,
//    output wire [31:0] a0,
//    output wire [31:0] a1,
//    output wire [31:0] a2,
//    output wire [31:0] a3,
//    output wire [31:0] a4,
//    output wire [31:0] a5,
//    output wire [31:0] a6,
//    output wire [31:0] a7,
//    output wire [31:0] s2,
//    output wire [31:0] s3,
//    output wire [31:0] s4,
//    output wire [31:0] s5,
//    output wire [31:0] s6,
//    output wire [31:0] s7,
//    output wire [31:0] s8,
//    output wire [31:0] s9,
//    output wire [31:0] s10,
//    output wire [31:0] s11,
//    output wire [31:0] t3,
//    output wire [31:0] t4,
//    output wire [31:0] t5,
//    output wire [31:0] t6
    );
    wire [31:0] x0;
wire [31:0] ra;
wire [31:0] sp ;
wire [31:0] gp ;
wire [31:0] tp ;
wire [31:0] t0 ;
wire [31:0] t1 ;
wire [31:0] t2 ;
wire [31:0] s0 ;
wire [31:0] s1 ;
wire [31:0] a0 ;
 wire [31:0] a1 ;
 wire [31:0] a2 ;
 wire [31:0] a3 ;
 wire [31:0] a4 ;
 wire [31:0] a5 ;
 wire [31:0] a6 ;
 wire [31:0] a7 ;
 wire [31:0] s2 ;
 wire [31:0] s3 ;
 wire [31:0] s4 ;
 wire [31:0] s5 ;
 wire [31:0] s6 ;
 wire [31:0] s7 ;
 wire [31:0] s8 ;
 wire [31:0] s9 ;
 wire [31:0] s10 ;
 wire [31:0] s11 ;
 wire [31:0] t3 ;
 wire [31:0] t4 ;
 wire [31:0] t5 ;
wire [31:0] t6;
    
    
    
    
    
    wire rst;
    wire counter0_out;
    wire counter1_out;
    wire counter2_out;
    wire counter_we;
    wire GPIOf0000000_we;
    wire GPIOe0000000_we;
    wire U4_data_ram_we;
    wire MemRW_Ex;
    wire MemRW_Mem;
    wire [1:0] counter_set;
    wire [3:0] BTN_OK;
    wire [7:0] point;
    wire [7:0] LE_out;    
    wire [9:0] ram_addr;
    wire [15:0] SW_OK;
    wire [15:0] LED_out;
    wire [31:0] clkdiv;
    wire [31:0] counter_val;
    wire [31:0] counter_out;
    wire [31:0] Data_in;
    wire [31:0] Data_out;
    wire [31:0] Addr_out;
    wire [31:0] Peripheral_in;
    wire [31:0] ram_data_in;
    wire [31:0] RAM_B_0_douta;
    wire [31:0] Hexs;
    wire [31:0] Data_out_WB;
    wire [31:0] Inst_in;
    wire [31:0] PC_out;
    wire [31:0] PC_out_IF;
    wire [31:0] PC_out_ID;
    wire [31:0] inst_ID;
    wire [31:0] PC_out_Ex;
    wire [4:0] IdEx_rd_debug;
        wire [31:0] IdEx_rs1_val_debug;
        wire [31:0] IdEx_rs2_val_debug;
        wire IdEx_reg_wen_debug;
        wire IdEx_is_imm_debug;
        wire [31:0] IdEx_imm_debug;
    Pipeline_CPU U1(
    .clk(Clk_CPU),
    .rst(rst),
    //MIO_ready not used
    .inst_IF(Inst_in),//u2 out put spo
    .Data_in(Data_in),//u4 out Cpu_data4bus
    //output
    .PC_out_IF(PC_out_IF),
    .PC_out_ID(PC_out_ID),
    .inst_ID(inst_ID),
    .PC_out_Ex(PC_out_Ex),
    .MemRW_Ex(MemRW_Ex),
    .MemRW_Mem(MemRW_Mem),
    .Data_out(Data_out),
    .Addr_out(Addr_out),
    .Data_out_WB(Data_out_WB),
        .x0            (  x0           ),
        .ra            (  ra           ),
        .sp            (  sp           ),
        .gp            (  gp           ),
        .tp            (  tp           ),
        .t0            (  t0           ),
        .t1            (  t1           ),
        .t2            (  t2           ),
        .s0            (  s0           ),
        .s1            (  s1           ),
        .a0            (  a0           ),
        .a1            (  a1           ),
        .a2            (  a2           ),
        .a3            (  a3           ),
        .a4            (  a4           ),
        .a5            (  a5           ),
        .a6            (  a6           ),
        .a7            (  a7           ),
        .s2            (  s2           ),
        .s3            (  s3           ),
        .s4            (  s4           ),
        .s5            (  s5           ),
        .s6            (  s6           ),
        .s7            (  s7           ),
        .s8            (  s8           ),
        .s9            (  s9           ),
        .s10           (  s10          ),
        .s11           (  s11          ),
        .t3            (  t3           ),
        .t4            (  t4           ),
        .t5            (  t5           ),
        .t6            (  t6           ),
        .IdEx_rd(IdEx_rd_debug),
        .IdEx_rs1_val(IdEx_rs1_val_debug),
        .IdEx_rs2_val(IdEx_rs2_val_debug),
        .IdEx_reg_wen(IdEx_reg_wen_debug),
        .IdEx_is_imm(IdEx_is_imm_debug),
        .IdEx_imm(IdEx_imm_debug)
    );
    ROM U2(
    .a(PC_out_IF[11:2]),
    .spo(Inst_in)//to u1 inst_IF, u11 inst_IF, u5 data2
    );
    RAM_B U3(
    .addra(ram_addr),//u4 output ram_addr
    .clka(~clk_100mhz),
    .dina(ram_data_in),//u4 output
    .douta(RAM_B_0_douta),//to u4 ram_data_out
    .wea(U4_data_ram_we)//u4 output data_ram_we
    );  
    MIO_BUS U4(
    .clk(clk_100mhz),
    .rst(rst),
    .BTN(BTN_OK),
    .SW(SW_OK),
    .mem_w(MemRW_Mem),//u1 output MemRW_Mem
    .Cpu_data2bus(Data_out),//u1 output Data_out
    .addr_bus(Addr_out),//u1 output Addr_out
    .ram_data_out(RAM_B_0_douta),//u3 output douta
    .led_out(LED_out),//u7 output LED_out 
    .counter_out(counter_out),//u10 output
    .counter0_out(counter0_out),//u10 output
    .counter1_out(counter1_out),//u10 output
    .counter2_out(counter2_out),//u10 output
    //output
    .Cpu_data4bus(Data_in),//to u1 Data_in, u5 data6
    .ram_data_in(ram_data_in),//to u3
    .ram_addr(ram_addr), //to u3
    .data_ram_we(U4_data_ram_we),//to u3
    .GPIOf0000000_we(GPIOf0000000_we),//to u7 EN
    .GPIOe0000000_we(GPIOe0000000_we),//to u5 EN
    .counter_we(counter_we), //to u10
    .Peripheral_in(Peripheral_in)//to u5 Data_0, u7 P_Data, u10 counter_val
    );
    Multi_8CH32 U5(
    .clk(~Clk_CPU),
    .rst(rst),//u9 output rst
    .EN(GPIOe0000000_we),//u4 output GPIOe0000000_we
    .Test(SW_OK[7:5]),
    .point_in({clkdiv[31:0],clkdiv[31:0]}),
    .LES(64'b0),
    .Data0(Peripheral_in), 
    .data1({2'b0,PC_out_IF[31:2]}),//u1 out 
    .data2(Inst_in),//u2 output spo
    .data3(counter_out),//u10 output
    .data4(Addr_out),//u1 output Addr_out
    .data5(Data_out),//u1 output Data_out
    .data6(Data_in),//u4 output Cpu_data4bus 
    .data7(PC_out_IF),//u1 output PC_out_IF
    //output
    .point_out(point),//to u6 point
    .LE_out(LE_out),//to u6 LES
    .Disp_num(Hexs)//to u6 HEXS
    );
    SSeg7_Dev U6(
    .clk(clk_100mhz),
    .flash(clkdiv[25]),
    .Hexs(Hexs),
    .LES(LE_out),//u5 output LE_out
    .point(point),//u5 output point
    .rst(rst),
    .Start(clkdiv[20]),
    .SW0(SW_OK[0]),
    //ouiput
    .seg_clk(seg_clk),
    .seg_clrn(seg_clrn),
    .SEG_PEN(SEG_PEN),
    .seg_sout(seg_sout)
    );
    SPIO U7(
    .clk(~Clk_CPU),
    .rst(rst),
    .Start(clkdiv[20]),
    .EN(GPIOf0000000_we),//u4 output 
    .P_Data(Peripheral_in),
    //output
    .counter_set(counter_set),//to u10 counter_ch
    .LED_out(LED_out),//to u4 led_out
    .led_clk(led_clk),
    .led_sout(led_sout),
    .led_clrn(led_clrn),
    .LED_PEN(LED_PEN)
//GPIOf0[13:0] not used
    );
    clk_div U8(
        //input
    .clk(clk_100mhz),
    .rst(rst),
    .SW2(SW_OK[2]),
    .SW8(SW_OK[8]),
    .STEP(SW_OK[10]),
    //output
    .clkdiv(clkdiv),
    .Clk_CPU(Clk_CPU)
    );  
    SAnti_jitter U9(
    .clk(clk_100mhz),
    .RSTN(RSTN),
    .readn(1'b0),//no wire connected
    .Key_y(BTN_y),
    .SW(SW),
    //output
    .BTN_OK(BTN_OK),
    .SW_OK(SW_OK),
    .rst(rst)
    );
    Counter_x U10(
    .clk(~Clk_CPU),
    .rst(rst),
    .clk0(clkdiv[6]),
    .clk1(clkdiv[9]),
    .clk2(clkdiv[11]),
    .counter_we(counter_we),//u4 output
    .counter_val(Peripheral_in),//u4 output
    .counter_ch(counter_set),//u7 output
    //output
    .counter0_OUT(counter0_out),
    .counter1_OUT(counter1_out),
    .counter2_OUT(counter2_out),
    .counter_out(counter_out)
    );
    VGA U11(//_v1_0
    .clk_25m(clkdiv[1]),
    .clk_100m(clk_100mhz),
    .rst(rst),
    .PC_IF(PC_out_IF),//u1 out PC_out_IF
    .inst_IF(Inst_in),//u2 out spo
    .PC_ID(PC_out_ID),//u1 outPC_out_ID
    .inst_ID(inst_ID),//u1 out inst_ID
    .PC_Ex(PC_out_Ex),//u1 out PC_out_Ex
    .MemRW_Ex(MemRW_Ex),//u1 out MemRW_Ex
    .MemRW_Mem(MemRW_Mem),//u1 out MemRW_Mem
    .Data_out(Data_out),//u1 out Data_out
    .Addr_out(Addr_out),//u1 out Addr_out
    .Data_out_WB(Data_out_WB),//u1 out Data_out_WB
    .x0(x0),
        .ra(ra),
        .sp(sp),
        .gp(gp),
        .tp(tp),
        .t0(t0),
        .t1(t1),
        .t2(t2),
        .s0(s0),
        .s1(s1),
        .a0(a0),
        .a1(a1),
        .a2(a2),
        .a3(a3),
        .a4(a4),
        .a5(a5),
        .a6(a6),
        .a7(a7),
        .s2(s2),
        .s3(s3),
        .s4(s4),
        .s5(s5),
        .s6(s6),
        .s7(s7),
        .s8(s8),
        .s9(s9),
        .s10(s10),
        .s11(s11),
        .t3(t3),
        .t4(t4),
        .t5(t5),
        .t6(t6),
       
//        .IdEx_rs1(),
//        .IdEx_rs2(),
        .IdEx_rd(IdEx_rd_debug),
        .IdEx_rs1_val(IdEx_rs1_val_debug),
        .IdEx_rs2_val(IdEx_rs2_val_debug),
        .IdEx_reg_wen(IdEx_reg_wen_debug),
        .IdEx_is_imm(IdEx_is_imm_debug),
        .IdEx_imm(IdEx_imm_debug),
    //output
    .hs(HSYNC),
    .vs(VSYNC),
    .vga_r(Red),
    .vga_g(Green),
    .vga_b(Blue)
    );
endmodule
