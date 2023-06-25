-makelib xcelium_lib/xpm -sv \
  "D:/Vivado/Vivado/2019.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "D:/Vivado/Vivado/2019.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/dist_mem_gen_v8_0_13 \
  "../../../ipstatic/simulation/dist_mem_gen_v8_0.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../JZ_project_2.srcs/sources_1/ip/data_memory_ip/sim/data_memory_ip.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

