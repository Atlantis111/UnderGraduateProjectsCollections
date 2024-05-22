`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/04 16:15:57
// Design Name: 
// Module Name: full_adder_test
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


module full_adder_test(
    );
    reg [3:0] A,B;      //����4λ�������A,B
    reg CI;             //������ʾ��λ���������CI
    wire [3:0] F;       //����4λ�����F
    wire CO;            //�����ʾ���λ������������CO
    
    add_4 uut(          //������λ���мӷ����Ķ���uut
        .A(A),
        .B(B),
        .CI(CI),
        .CO(CO),
        .F(F)
    );
    
    initial begin       //������ΪA=0;B=0;CI=0��ʼ��ÿ��#100��ʱ�䣬ÿ��ʹ��������+1
        A=0;B=0;CI=0;
    end
    always #100 {CI,A,B}={CI,A,B}+1;
endmodule