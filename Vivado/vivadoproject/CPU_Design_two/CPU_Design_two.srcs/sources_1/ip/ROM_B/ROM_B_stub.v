// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
// Date        : Fri Jun 18 20:40:41 2021
// Host        : DESKTOP-J89QRPS running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               e:/vivadoproject/CPU_Design_two/CPU_Design_two.srcs/sources_1/ip/ROM_B/ROM_B_stub.v
// Design      : ROM_B
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tlcsg324-2L
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2020.1" *)
module ROM_B(clka, addra, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,addra[5:0],douta[31:0]" */;
  input clka;
  input [5:0]addra;
  output [31:0]douta;
endmodule
