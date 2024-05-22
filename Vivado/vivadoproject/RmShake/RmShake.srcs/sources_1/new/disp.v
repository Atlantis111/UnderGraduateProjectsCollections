`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/01 21:19:18
// Design Name: 
// Module Name: disp
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


module disp(                    //����ģ��
    _rst,clk_100M,_key,Out
    );
    input _rst,clk_100M,_key;
    output reg [7:0] Out;       //���Out��ʾ��������������
    wire _key_pulse;
    
    ditheliminater ut(          //���ӷ�ʽ�ɼ����ģ��ͼ�еĶ���ģ��
        ._rst(_rst),
        .clk_100M(clk_100M),
        ._key(_key),
        ._key_pulse(_key_pulse)
    );
    
    initial begin
        Out=8'b0;
    end
    always @(negedge _key_pulse or negedge _rst)            //�첽
    begin
        if(~_rst) Out=8'b0;
        else Out=Out+1;             //ÿ��_key_pulse����Out+1
    end
endmodule
