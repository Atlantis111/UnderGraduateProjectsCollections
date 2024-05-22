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


module disp(                    //����ģ��
    _rst,clk_100M,_key,Out
    );
    input _rst,clk_100M,_key;
    output reg [7:0] Out;       //���Out��ʾ��������������
    wire _key_pulse;
    
    key_vibrationeliminate ut(          //���ӷ�ʽ�ɼ����ģ��ͼ�еĶ���ģ��
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


module key_vibrationeliminate(              //��������ģ��
    _rst,clk_100M,_key,_key_pulse           //_key���������壬_key_pulse���������
    );
    input _rst,clk_100M,_key;
    output reg _key_pulse;
    parameter S0=3'b000,S1=3'b001,S2=3'b010,S3=3'b011,S4=3'b100,S5=3'b101;      //����״̬
    reg Cur_S;              //Cur_Sָ����״̬
    wire clk;
    
    DivFre ut(              //���ӷ�ʽ�ɼ����ģ��ͼ�з�Ƶ��ģ��
        ._rst(_rst),
        .clk_in(clk_100M),
        .clk_out(clk)
    );
    always @(posedge clk or negedge _rst)           //�첽
    begin
        if(~_rst) Cur_S=S0;
        else
        case (Cur_S)
            S0:begin
                Cur_S=_key?S0:S1;       //S0��ʾ�����ȶ�����
                _key_pulse=1;           //����״̬��������ͬʱ��״̬��ΪS0����ͬʱ��ΪS1
            end
            S1:begin
                Cur_S=_key?S2:S5;       //S1��ʾ�����ɿ�
                _key_pulse=_key?1:0;
            end
            S2:begin
                Cur_S=_key?S0:S1;       //S2��ʾ���ض��������
                _key_pulse=1;
            end
            S3:begin
                Cur_S=_key?S0:S4;       //S3��ʾ��������
                _key_pulse=_key?1:0;
            end
            S4:begin
                Cur_S=_key?S3:S5;       //S4��ʾ���ض��������
                _key_pulse=0;
            end
            S5:begin
                Cur_S=_key?S3:S5;       //S4��ʾ�����ȶ�����
                _key_pulse=0;
            end
        endcase
    end
endmodule


module DivFre(                  //��Ƶ��ģ��
    _rst,clk_in,clk_out         //��������
    );
    input _rst,clk_in;
    output reg clk_out;
    reg [27:0] n;                       //n��λ������2^n>1000000����
    parameter num = 1_000_000;           //ԭ��Ƶ����10^8������ѡ��10^7Ϊһ�飬�Ӷ�����10ms��Ƶ��
    always @(negedge _rst or posedge clk_in)        //�첽����
    begin
        if(~_rst) begin n=28'b0;clk_out=0; end
        else
        begin
            if(n<num) n=n+1'b1;             //n����10^7����ֵ����clk��ת
            else
            begin
                n=0;
                clk_out=~clk_out;
            end
        end
    end
endmodule