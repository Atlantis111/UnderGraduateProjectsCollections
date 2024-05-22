`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/16 20:54:45
// Design Name: 
// Module Name: REG_simu
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


module REG_simu();
    reg _rst,R_write,clk_R;
    reg [4:0] R_Addr_A,R_Addr_B,W_Addr;
    reg [31:0] W_Data;
    wire [31:0] R_Data_A,R_Data_B;
    RegHeap Simu(
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
        
        #100
        R_Addr_A=5'b00000;
        R_Addr_B=5'b00001;
        W_Addr=5'b00010;
        R_write=1;
        W_Data=32'h11111111;
        clk_R=1;
        
        #100
        R_Addr_A=5'b00010;
        R_Addr_B=5'b00001;
        W_Addr=5'b00011;
        R_write=1;
        W_Data=32'h12345678;
        clk_R=1;
                
        #100
        R_Addr_A=5'b01001;
        R_Addr_B=5'b01000;
        W_Addr=0;
        R_write=0;
        W_Data=0;
        clk_R=1;
        
    end
endmodule

