vlib work
vlib riviera

vlib riviera/xpm
vlib riviera/dist_mem_gen_v8_0_13
vlib riviera/xil_defaultlib

vmap xpm riviera/xpm
vmap dist_mem_gen_v8_0_13 riviera/dist_mem_gen_v8_0_13
vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xpm  -sv2k12 \
"D:/Vivado/Vivado/2019.2/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"D:/Vivado/Vivado/2019.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work dist_mem_gen_v8_0_13  -v2k5 \
"../../../ipstatic/simulation/dist_mem_gen_v8_0.v" \

vlog -work xil_defaultlib  -v2k5 \
"../../../../JZ_project_2.srcs/sources_1/ip/data_memory_ip/sim/data_memory_ip.v" \


vlog -work xil_defaultlib \
"glbl.v"

