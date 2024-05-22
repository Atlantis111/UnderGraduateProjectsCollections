`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/25 21:44:23
// Design Name: 
// Module Name: DivFre
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


module DivFre(                  //分频器模块
    _rst,clk_in,clk_out         //三个变量
    );
    input _rst,clk_in;
    output reg clk_out;
    reg [27:0] n;                       //n的位数满足2^n>1000000即可
    parameter num = 1_000_000;           //原本频率是10^8，现在选定10^7为一组，从而到达10ms的频率
    always @(negedge _rst or posedge clk_in)        //异步清零
    begin
        if(~_rst) begin n=28'b0;clk_out=0; end
        else
        begin
            if(n<num) n=n+1'b1;             //n到达10^7的数值后，让clk翻转
            else
            begin
                n=0;
                clk_out=~clk_out;
            end
        end
    end
endmodule
