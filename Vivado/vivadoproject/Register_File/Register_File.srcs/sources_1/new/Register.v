`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/12 11:15:32
// Design Name: 
// Module Name: Register
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

module Register(_rst,clk,inp_D,out_D);
    input [31:0] inp_D;
    input _rst,clk;
    output reg [31:0] out_D;
    always @(negedge _rst or posedge clk)
    begin
        if(~_rst) begin
            out_D<=0;
        end
        else begin
            out_D<=inp_D;
        end
    end
endmodule
