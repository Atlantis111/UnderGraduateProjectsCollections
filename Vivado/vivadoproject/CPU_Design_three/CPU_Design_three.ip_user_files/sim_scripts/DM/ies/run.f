-makelib ies_lib/xpm -sv \
  "E:/vivado/Vivado/2020.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \
-endlib
-makelib ies_lib/xpm \
  "E:/vivado/Vivado/2020.1/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies_lib/blk_mem_gen_v8_4_4 \
  "../../../ipstatic/simulation/blk_mem_gen_v8_4.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  "../../../../CPU_Design_three.srcs/sources_1/ip/DM/sim/DM.v" \
-endlib
-makelib ies_lib/xil_defaultlib \
  glbl.v
-endlib

