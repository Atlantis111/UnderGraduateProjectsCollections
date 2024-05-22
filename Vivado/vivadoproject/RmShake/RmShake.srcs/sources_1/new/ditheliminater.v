`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/25 23:49:19
// Design Name: 
// Module Name: ditheliminater
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


module ditheliminater(              //按键消抖模块
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
