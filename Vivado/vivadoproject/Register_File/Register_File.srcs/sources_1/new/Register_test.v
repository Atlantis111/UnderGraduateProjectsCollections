`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/12 11:11:15
// Design Name: 
// Module Name: Register_test
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


module Register_File_test(clk_100M,_clk_WB,_clk_RR,_clk_F,_rst,R_addr_A,R_addr_B,W_addr,operation,Reg_Write,sel,seg,led);
    input clk_100M,_rst,_clk_WB,_clk_RR,_clk_F;
    input [4:0] R_addr_A;
    input [4:0] R_addr_B;
    input [4:0] W_addr;
    input [3:0] operation;
    input Reg_Write;
    output [7:0] sel,seg;
    output [3:0] led;
    wire clk_D;
    wire [31:0] R;
    wire [3:0] res_led;
    wire [31:0] data;
    wire [31:0] RA,RB,A,B,temp_F;
    reg [2:0] bit_sel;
    Register_File(
        ._rst(_rst),
        .R_Addr_A(R_addr_A[4:0]),
        .R_Addr_B(R_addr_B[4:0]),
        .W_Addr(W_addr[4:0]),
        .R_write(Reg_Write),
        .clk_R(~_clk_R),
        .W_Data(temp_F),
        .R_Data_A(RA),
        .R_Data_B(RB)
    );
    Register uut1(
        ._rst(_rst),
        .clk(~_clk_RR),
        .inp_D(RA),
        .out_D(A)
    );
    Register uut2(
        ._rst(_rst),
        .clk(~_clk_RR),
        .inp_D(RB),
        .out_D(B)
    );
    ALU(
        .A(A),
        .B(B),
        .ALU_OP(operation[3:0]),
        .R(R),
        .ZF(res_led[3]),
        .SF(res_led[2]),
        .CF(res_led[1]),
        .OF(res_led[0])
    );
    Register_R(
        ._rst(_rst),
        .clk(~_clk_F),
        .inp_D(R),
        .inp_M(res_led),
        .out_D(data),
        .out_M(led)
    );
    assign temp_F=data;
    Div(
        ._rst(_rst),
        .clk_in(clk_100M),
        .frequency(15'd25000),
        .clk_out(clk_D)
    );
    Display(
        ._rst(_rst),
        .clk_D(clk_D),
        .data(data),
        .sel(sel),
        .seg(seg)
    );
endmodule
 

