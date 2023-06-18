-makelib xcelium_lib/xpm -sv \
  "D:/vivado_xilinx/Vivado/2020.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "D:/vivado_xilinx/Vivado/2020.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/dist_mem_gen_v8_0_13 \
  "../../../ipstatic/simulation/dist_mem_gen_v8_0.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../lab4.gen/sources_1/ip/ROM_D/sim/ROM_D.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

