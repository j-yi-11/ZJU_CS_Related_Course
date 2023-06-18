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
    output seg_sout    
    );
    wire [3:0] BTN_OK;
    wire [15:0] SW_OK;
    wire rst;
    wire OR_0;
    assign OR_0 = (SW_OK[10] | BTN_OK[0]);
    wire [31:0] PC_out;
    wire MemRW;
    wire [31:0] clkdiv;
    wire [31:0] Inst_in;
    wire Clk_CPU;
    wire counter_we;//u4 output
    wire [31:0] Peripheral_in;//u4 output
    wire [1:0] counter_set;//u7 output
    wire counter0_out;
    wire counter1_out;
    wire counter2_out;
    wire [31:0] counter_out;    
    wire [31:0] Data_out;
    wire [31:0] Data_in;
    wire [31:0] Addr_out;
    wire [31:0] RAM_B_0_douta;
    wire [15:0] LED_out;
    wire [31:0] ram_data_in;
    wire [9:0] ram_addr;
    wire U4_data_ram_we;
    wire GPIOf0000000_we;
    wire [7:0] point;
    wire [7:0] LE_out;
    wire [31:0] Hexs;
    SCPU U1(
    .Addr_out(Addr_out),    
    .Data_in(Data_in),//u4 output
    .Data_out(Data_out),
    .MIO_ready(1'b0),
    .MemRW(MemRW),
    .PC_out(PC_out),
    .clk(Clk_CPU),
    .inst_in(Inst_in),
    .rst(rst)
    );
    ROM_D U2(
    .a(PC_out[11:2]),
    .spo(Inst_in)
    );
    RAM_B U3(
    .addra(ram_addr),
    .clka(~clk_100mhz),
    .dina(ram_data_in),
    .douta(RAM_B_0_douta),
    .wea(U4_data_ram_we)
    );  
    MIO_BUS U4(
    .clk(clk_100mhz),
    .rst(rst),
    .BTN(BTN_OK),
    .SW(SW_OK),
    .mem_w(MemRW),
    .Cpu_data2bus(Data_out),//u1 output
    .addr_bus(Addr_out),//u1 output
    .ram_data_out(RAM_B_0_douta),//u3 output
    .led_out(LED_out),//u7 output 
    .counter_out(counter_out),//u10 output
    .counter0_out(counter0_out),//u10 output
    .counter1_out(counter1_out),//u10 output
    .counter2_out(counter2_out),//u10 output
    .Cpu_data4bus(Data_in),
    .ram_data_in(ram_data_in),//[31:0]
    .ram_addr(ram_addr), //[9:0]
    .data_ram_we(U4_data_ram_we),
    .GPIOf0000000_we(GPIOf0000000_we),//
    .GPIOe0000000_we(GPIOe0000000_we),//to
    .counter_we(counter_we), //to u10
    .Peripheral_in(Peripheral_in)    //to u10
    );
    Multi_8CH32 U5(
    .clk(~Clk_CPU),
    .rst(rst),//u9 output
    .EN(GPIOe0000000_we),//u4 output
    .Test(SW_OK[7:5]),
    .point_in({clkdiv[31:0],clkdiv[31:0]}),//64'b0
    .LES(64'b0),
    .Data0(Peripheral_in), 
    .data1({2'b0,PC_out[31:2]}),//
    .data2(Inst_in),//[31:0]
    .data3(counter_out),//u10 output
    .data4(Addr_out),
    .data5(Data_out),
    .data6(Data_in),
    .data7(PC_out),
    .point_out(point),//to u6
    .LE_out(LE_out),
    .Disp_num(Hexs)
    );
    SSeg7_Dev U6(
    .clk(clk_100mhz),
    .flash(clkdiv[25]),
    .Hexs(Hexs),
    .LES(LE_out),//u5 output
    .point(point),
    .rst(rst),
    .Start(clkdiv[20]),
    .SW0(SW_OK[0]),
    .seg_clk(seg_clk),
    .seg_clrn(seg_clrn),
    .SEG_PEN(SEG_PEN),
    .seg_sout(seg_sout)
    );
    SPIO U7(
    .clk(~Clk_CPU),
    .rst(rst),
    .Start(clkdiv[20]),
    .EN(GPIOf0000000_we),
    .P_Data(Peripheral_in),
    .counter_set(counter_set),
    .LED_out(LED_out),
    .led_clk(led_clk),
    .led_sout(led_sout),
    .led_clrn(led_clrn),
    .LED_PEN(LED_PEN)
//GPIOf0[13:0] not used
    );

    clk_div U8(
    .clk(clk_100mhz),
    .rst(rst),
    .SW2(SW_OK[2]),
    .SW8(SW_OK[8]),
    .STEP(OR_0),
    .clkdiv(clkdiv),
    .Clk_CPU(Clk_CPU)
    );    
    SAnti_jitter U9(
    .clk(clk_100mhz),
    .RSTN(RSTN),
    .readn(1'b0),//no wire connected
    .Key_y(BTN_y),
    .SW(SW),
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
    .counter0_OUT(counter0_out),
    .counter1_OUT(counter1_out),
    .counter2_OUT(counter2_out),
    .counter_out(counter_out)
    );
    VGA U11(//_v1_0
    .clk_25m(clkdiv[1]),
    .clk_100m(clk_100mhz),
    .rst(rst),
    .pc(PC_out),  //[31:0]
    .inst(Inst_in),
    .alu_res(Addr_out),//Data_out
    .mem_wen(MemRW),
    .dmem_o_data(RAM_B_0_douta),  //u3 output
    .dmem_i_data(ram_data_in),//u4 output
    .dmem_addr(Addr_out),//Data_out
    .hs(HSYNC),
    .vs(VSYNC),
    .vga_r(Red),
    .vga_g(Green),
    .vga_b(Blue)
    );
endmodule


