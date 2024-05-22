`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/16 00:42:41
// Design Name: 
// Module Name: Register_result
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


module Register_R(_rst,clk,inp_D,inp_M,out_D,out_M);
    input [31:0] inp_D;
    input [3:0] inp_M;
    input _rst,clk;
    output reg [31:0] out_D;
    output reg [3:0] out_M;
    always @(negedge _rst or posedge clk)
    begin
        if(~_rst) begin
            out_D<=0;
            out_M<=0;
        end
        else begin
            out_D<=inp_D;
            out_M<=inp_M;
        end
    end
endmodule
