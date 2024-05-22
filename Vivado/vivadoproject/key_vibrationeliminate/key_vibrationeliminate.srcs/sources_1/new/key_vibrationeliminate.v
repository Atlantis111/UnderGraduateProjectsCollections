`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/09 11:44:35
// Design Name: 
// Module Name: key_vibrationeliminate
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


module disp(                    //顶层模块
    _rst,clk_100M,_key,Out
    );
    input _rst,clk_100M,_key;
    output reg [7:0] Out;       //输出Out表示计数器的最后输出
    wire _key_pulse;
    
    key_vibrationeliminate ut(          //连接方式可见书的模块图中的顶层模块
        ._rst(_rst),
        .clk_100M(clk_100M),
        ._key(_key),
        ._key_pulse(_key_pulse)
    );
    
    initial begin
        Out=8'b0;
    end
    always @(negedge _key_pulse or negedge _rst)            //异步
    begin
        if(~_rst) Out=8'b0;
        else Out=Out+1;             //每次_key_pulse都让Out+1
    end
endmodule


module key_vibrationeliminate(              //按键消抖模块
    _rst,clk_100M,_key,_key_pulse           //_key是输入脉冲，_key_pulse是输出脉冲
    );
    input _rst,clk_100M,_key;
    output reg _key_pulse;
    parameter S0=3'b000,S1=3'b001,S2=3'b010,S3=3'b011,S4=3'b100,S5=3'b101;      //六个状态
    reg Cur_S;              //Cur_S指现在状态
    wire clk;
    
    DivFre ut(              //连接方式可见书的模块图中分频器模块
        ._rst(_rst),
        .clk_in(clk_100M),
        .clk_out(clk)
    );
    always @(posedge clk or negedge _rst)           //异步
    begin
        if(~_rst) Cur_S=S0;
        else
        case (Cur_S)
            S0:begin
                Cur_S=_key?S0:S1;       //S0表示按键稳定按下
                _key_pulse=1;           //现在状态与输入相同时，状态变为S0，不同时变为S1
            end
            S1:begin
                Cur_S=_key?S2:S5;       //S1表示按键松开
                _key_pulse=_key?1:0;
            end
            S2:begin
                Cur_S=_key?S0:S1;       //S2表示下沿抖动或干扰
                _key_pulse=1;
            end
            S3:begin
                Cur_S=_key?S0:S4;       //S3表示按键按下
                _key_pulse=_key?1:0;
            end
            S4:begin
                Cur_S=_key?S3:S5;       //S4表示上沿抖动或干扰
                _key_pulse=0;
            end
            S5:begin
                Cur_S=_key?S3:S5;       //S4表示按键稳定弹起
                _key_pulse=0;
            end
        endcase
    end
endmodule


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