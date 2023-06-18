-makelib xcelium_lib/xpm -sv \
  "D:/vivado_xilinx/Vivado/2020.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "D:/vivado_xilinx/Vivado/2020.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/blk_mem_gen_v8_4_4 \
  "../../../ipstatic/simulation/blk_mem_gen_v8_4.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../lab4-3.gen/sources_1/ip/RAM_B/sim/RAM_B.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

