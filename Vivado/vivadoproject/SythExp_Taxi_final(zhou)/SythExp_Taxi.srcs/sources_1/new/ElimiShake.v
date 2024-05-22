`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/23 20:11:56
// Design Name: 
// Module Name: ElimiShake
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


module ElimiShake(
    _rst,clk_100M,_key,_key_pulse
    );
    input _rst,clk_100M,_key;
    output reg _key_pulse;
    parameter S0=3'b000,S1=3'b001,S2=3'b010,S3=3'b011,S4=3'b100,S5=3'b101; //״̬��
    /*S0:��ʾ�����ȶ�����
    S1:��ʾ��������
    S2:��ʾ��������ʱ����
    S3:��ʾ�����ɿ�
    S4:��ʾ�����ɿ�ʱ����
    S5:��ʾ�����ȶ�����*/
    reg [2:0]Cur_S; //��ǰ״̬
    wire clk;
    DivFreq_Erase ut(._rst(_rst),.clk_in(clk_100M),.clk_out(clk));
    always @(posedge clk or negedge _rst)
    begin
        if(~_rst) Cur_S=S0;
        else
        case (Cur_S)
            S0:begin
                Cur_S=_key?S0:S1;
                _key_pulse=1;
            end
            S1:begin
                Cur_S=_key?S2:S5;
                _key_pulse=_key?1:0;
            end
            S2:begin
                Cur_S=_key?S0:S1;
                _key_pulse=1;
            end
            S3:begin
                Cur_S=_key?S0:S4;
                _key_pulse=_key?1:0;
            end
            S4:begin
                Cur_S=_key?S3:S5;
                _key_pulse=0;
            end
            S5:begin
                Cur_S=_key?S3:S5;
                _key_pulse=0;
            end
        endcase
    end
endmodule
