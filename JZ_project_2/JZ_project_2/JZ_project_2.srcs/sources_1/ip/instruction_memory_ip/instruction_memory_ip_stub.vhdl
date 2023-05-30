-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
-- Date        : Tue May 23 20:21:19 2023
-- Host        : LAPTOP-BI96FENR running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub {d:/vivado
--               projects/JZ_project_2/JZ_project_2/JZ_project_2.srcs/sources_1/ip/instruction_memory_ip/instruction_memory_ip_stub.vhdl}
-- Design      : instruction_memory_ip
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity instruction_memory_ip is
  Port ( 
    clka : in STD_LOGIC;
    addra : in STD_LOGIC_VECTOR ( 13 downto 0 );
    douta : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );

end instruction_memory_ip;

architecture stub of instruction_memory_ip is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clka,addra[13:0],douta[31:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "blk_mem_gen_v8_4_4,Vivado 2019.2";
begin
end;
