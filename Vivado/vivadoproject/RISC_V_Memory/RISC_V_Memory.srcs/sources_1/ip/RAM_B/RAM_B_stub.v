// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (win64) Build 2902540 Wed May 27 19:54:49 MDT 2020
// Date        : Sun May 16 16:28:15 2021
// Host        : DESKTOP-J89QRPS running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               e:/vivadoproject/RISC_V_Memory/RISC_V_Memory.srcs/sources_1/ip/RAM_B/RAM_B_stub.v
// Design      : RAM_B
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tlcsg324-2L
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2020.1" *)
module RAM_B(clka, wea, addra, dina, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[0:0],addra[5:0],dina[31:0],douta[31:0]" */;
  input clka;
  input [0:0]wea;
  input [5:0]addra;
  input [31:0]dina;
  output [31:0]douta;
endmodule
