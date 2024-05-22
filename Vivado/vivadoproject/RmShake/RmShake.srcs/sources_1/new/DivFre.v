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
