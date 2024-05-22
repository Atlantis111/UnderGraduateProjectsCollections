-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
-- Date        : Thu Jun 17 23:14:06 2021
-- Host        : DESKTOP-J89QRPS running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub e:/vivadoproject/RISC_V_ZHZ.srcs/sources_1/ip/My_ROM/My_ROM_stub.vhdl
-- Design      : My_ROM
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tlcsg324-2L
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity My_ROM is
  Port ( 
    clka : in STD_LOGIC;
    addra : in STD_LOGIC_VECTOR ( 5 downto 0 );
    douta : out STD_LOGIC_VECTOR ( 31 downto 0 )
  );

end My_ROM;

architecture stub of My_ROM is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clka,addra[5:0],douta[31:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "blk_mem_gen_v8_4_4,Vivado 2020.1";
begin
end;
