`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/04 16:11:15
// Design Name: 
// Module Name: full_adder
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

module full_adder(      //�ײ�ģ�飬ʵ��һλȫ����
    A,B,CI,S,CO
    );
    input A,B,CI;       //��������������м����
    output S,CO;
    wire t1,t2,t3;
    
    xor u1(t1,A,B),     //���ýṹ��ģ�ķ�ʽ��д�߼�
        u2(S,t1,CI);
    and u3(t2,A,B),
        u4(t3,t1,CI);
    or u5(CO,t2,t3);
    
endmodule

module add_4(               //����ģ�飬���н�λ�ӷ���
    A,B,CI,CO,F
    );
    input [3:0] A,B;        //����4λ���������A,B
    input CI;               //�����ʾ��λ���������CI
    output [3:0] F;         //����4λ�����F
    output CO;              //�����ʾ���λ������������CO
    wire C1,C2,C3;
    
    full_adder A0(          //����һ��ȫ�����Ķ���A0
        .A(A[0]),
        .B(B[0]),
        .CI(CI),
        .S(F[0]),
        .CO(C1)
    );
    full_adder A1(          //����һ��ȫ�����Ķ���A1
        .A(A[1]),
        .B(B[1]),
        .CI(C1),
        .S(F[1]),
        .CO(C2)
    );
    full_adder A2(          //����һ��ȫ�����Ķ���A2
        .A(A[2]),
        .B(B[2]),
        .CI(C2),
        .S(F[2]),
        .CO(C3)
    );
    full_adder A3(          //����һ��ȫ�����Ķ���A3
        .A(A[3]),
        .B(B[3]),
        .CI(C3),
        .S(F[3]),
        .CO(CO)
    );
endmodule
