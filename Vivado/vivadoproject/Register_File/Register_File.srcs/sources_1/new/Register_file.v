`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/12 10:02:35
// Design Name: 
// Module Name: Register_file
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


module Register_File(_rst,R_Addr_A,R_Addr_B,W_Addr,R_write,clk_R,W_Data,R_Data_A,R_Data_B);
    input _rst,R_write,clk_R;
    input [4:0] R_Addr_A,R_Addr_B,W_Addr;
    input [31:0] W_Data;
    output [31:0] R_Data_A,R_Data_B;
    reg [31:0] RegisterFile[31:0];
    always @(negedge _rst or posedge clk_R)
    begin
        if(~_rst) begin
            RegisterFile[0]<=0;
            RegisterFile[1]<=1;
            RegisterFile[2]<=2;
            RegisterFile[3]<=3;
            RegisterFile[4]<=4;
            RegisterFile[5]<=5;
            RegisterFile[6]<=6;
            RegisterFile[7]<=7;
            RegisterFile[8]<=8;
            RegisterFile[9]<=9;
            RegisterFile[10]<=10;
        end
        else if(R_write) begin
            if(W_Addr)  RegisterFile[W_Addr]<=W_Data;
        end
    end
    assign R_Data_A=RegisterFile[R_Addr_A];
    assign R_Data_B=RegisterFile[R_Addr_B];
endmodule
