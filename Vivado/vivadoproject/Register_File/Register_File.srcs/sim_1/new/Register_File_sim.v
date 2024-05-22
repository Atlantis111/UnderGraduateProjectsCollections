`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/16 18:53:59
// Design Name: 
// Module Name: Register_File_sim
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


module Register_File_sim();
    reg _rst,R_write,clk_R;
    reg [4:0] R_Addr_A,R_Addr_B,W_Addr;
    reg [31:0] W_Data;
    wire [31:0] R_Data_A,R_Data_B;
    Register_File sim(
        ._rst(_rst),
        .R_Addr_A(R_Addr_A),
        .R_Addr_B(R_Addr_B),
        .W_Addr(W_Addr),
        .R_write(R_write),
        .clk_R(clk_R),
        .W_Data(W_Data),
        .R_Data_A(R_Data_A),
        .R_Data_B(R_Data_B)
    );
    initial begin
        _rst=0;
        clk_R=0;
        R_write=0;
        R_Addr_A=1;
        R_Addr_B=2;
        W_Addr=4;
        W_Data=0;
        #50
        _rst=1;
        R_write=1;
        #200
        W_Data=R_Data_A+R_Data_B;
        clk_R=1;
        #50
        clk_R=0;
        R_write=0;
        #200
        R_Addr_A=4;
        R_Addr_B=2;
        W_Addr=5;
        #50
        R_write=1;
        W_Data=R_Data_A<<R_Data_B;
        #200
        clk_R=1;
        #50
        clk_R=0;
        R_write=0;
        R_Addr_A=4;
        R_Addr_B=5;
    end
endmodule
