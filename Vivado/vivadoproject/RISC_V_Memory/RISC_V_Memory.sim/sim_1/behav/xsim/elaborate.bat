@echo off
REM ****************************************************************************
REM Vivado (TM) v2020.1 (64-bit)
REM
REM Filename    : elaborate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for elaborating the compiled design
REM
REM Generated by Vivado on Thu May 20 19:28:57 +0800 2021
REM SW Build 2902540 on Wed May 27 19:54:49 MDT 2020
REM
REM Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
REM
REM usage: elaborate.bat
REM
REM ****************************************************************************
echo "xelab -wto 64f5e7cca66547a1a9e39de7e334df96 --incr --debug typical --relax --mt 2 -L blk_mem_gen_v8_4_4 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -L xpm --snapshot RISC_V_Memory_sim_behav xil_defaultlib.RISC_V_Memory_sim xil_defaultlib.glbl -log elaborate.log"
call xelab  -wto 64f5e7cca66547a1a9e39de7e334df96 --incr --debug typical --relax --mt 2 -L blk_mem_gen_v8_4_4 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -L xpm --snapshot RISC_V_Memory_sim_behav xil_defaultlib.RISC_V_Memory_sim xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
