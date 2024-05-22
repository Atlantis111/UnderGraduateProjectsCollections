`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/23 18:19:24
// Design Name: 
// Module Name: DivFreq
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

//数码管扫描分频信号
module DivFreq_Display(
    _rst,clk_in,clk_out
    );
    input _rst,clk_in;
    output reg clk_out;
    reg [13:0] n;
    parameter num = 1_00_00;
    always @(negedge _rst or posedge clk_in)
    begin
        if(~_rst) begin n<=14'b0;clk_out<=0; end
        else
        begin
            if(n<num) n<=n+1'b1;
            else
            begin
                n<=0;
                clk_out<=~clk_out;
            end
        end
    end
endmodule

//汽车计时分频信号
module DivFreq_Plus(
    _rst,clk_in,clk_out
    );
    input _rst,clk_in;
    output reg clk_out;
    reg [25:0] n;
    parameter num = 5_000_0000;
    always @(negedge _rst or posedge clk_in)
    begin
        if(~_rst) begin n<=26'b0;clk_out<=0; end
        else
        begin
            if(n<num) n<=n+1'b1;
            else
            begin
                n<=0;
                clk_out<=~clk_out;
            end
        end
    end
endmodule

//按键消抖分频信号
module DivFreq_Erase(
    _rst,clk_in,clk_out
    );
    input _rst,clk_in;
    output reg clk_out;
    reg [19:0] n;
    parameter num = 1_000_000;
    always @(negedge _rst or posedge clk_in)
    begin
        if(~_rst) begin n<=20'b0;clk_out<=0; end
        else
        begin
            if(n<num) n<=n+1'b1;
            else
            begin
                n<=0;
                clk_out<=~clk_out;
            end
        end
    end
endmodule