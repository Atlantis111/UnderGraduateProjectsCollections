`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/19 03:31:04
// Design Name: 
// Module Name: CPU_Design_three_sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CPU_Design_sim();
    reg rst_n,clk;
    wire [31:0] IM_addr,inst,W_Data_in,Reg_A,Reg_B,F,out_M_R_Data;
    wire [3:0] FR;
    CPU_Design_three Sim(
        .rst_n(rst_n),
        .clk(clk),
        .IM_addr(IM_addr),
        .inst(inst),
        .W_Data_in(W_Data_in),
        .Reg_A(Reg_A),
        .Reg_B(Reg_B),
        .FR(FR),
        .F(F),
        .out_M_R_Data(out_M_R_Data)
    );
    initial begin
        clk=0;
        rst_n=0;
        #10 rst_n=1;
    end
    always #50 clk=~clk;  //每50ns，时钟翻转一次
endmodule
