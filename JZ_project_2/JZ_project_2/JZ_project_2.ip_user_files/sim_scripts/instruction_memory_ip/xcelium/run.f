-makelib xcelium_lib/xpm -sv \
  "D:/Vivado/Vivado/2019.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib xcelium_lib/xpm \
  "D:/Vivado/Vivado/2019.2/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib xcelium_lib/blk_mem_gen_v8_4_4 \
  "../../../ipstatic/simulation/blk_mem_gen_v8_4.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  "../../../../JZ_project_2.srcs/sources_1/ip/instruction_memory_ip/sim/instruction_memory_ip.v" \
-endlib
-makelib xcelium_lib/xil_defaultlib \
  glbl.v
-endlib

