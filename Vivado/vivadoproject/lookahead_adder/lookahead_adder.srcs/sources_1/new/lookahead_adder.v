`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/08 17:23:06
// Design Name: 
// Module Name: lookahead_adder
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


module full_adder(          //�ײ�ģ�飬ʵ��һλȫ����      
    A,B,CI,S,CO
    );
    input A,B,CI;           //��������������м����
    output S,CO;
    wire t1,t2,t3;
    xor u1(t1,A,B),         //���ýṹ��ģ�ķ�ʽ��д�߼�
        u2(S,t1,CI);
    and u3(t2,A,B),
        u4(t3,t1,CI);
    or u5(CO,t2,t3);
endmodule


module lookahead_adder(A,B,C0,C1,C2,C3,C4);         //�ڶ���ģ�飬��λ��ǰ��λ�ӷ���
    input [3:0] A,B;            //������λ�������A,B
    input C0;                   //�����������CO
    output C1,C2,C3,C4;         //�����м������C1,C2,C3,C4
    wire [3:0] G,P;
    assign G= A & B;            //�����������ķ�ʽд����������ı��ʽ
    assign P= A | B;
    assign C1= G[0] | (P[0] & C0);
    assign C2= G[1] | (P[1] & G[0])| (P[1] & P[0] & C0);
    assign C3= G[2] | (P[2] & G[1])| (P[2] & P[1] & G[0])| (P[2] & P[1] & P[0] & C0);
    assign C4= G[3] | (P[3] & G[2])| (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & C0);
endmodule



module lookaheadadd_4(
    A,B,C0,F,C4
    );
    input [3:0] A,B;            //�����������A,B,CO
    input C0;
    output [3:0] F;             //�����������F��C4
    output C4;
    wire C1,C2,C3;
    
    lookahead_adder uut(        //������λ��ǰ��λ�ӷ������󣬴Ӷ���������C1��C4
        .A(A),
        .B(B),
        .C0(C0),
        .C1(C1),
        .C2(C2),
        .C3(C3),
        .C4(C4)
    );
    
    full_adder A0(
        .A(A[0]),
        .B(B[0]),
        .CI(C0),
        .S(F[0]),
        .CO()
    );
    full_adder A1(
        .A(A[1]),
        .B(B[1]),
        .CI(C1),
        .S(F[1]),
        .CO()
    );
    full_adder A2(
        .A(A[2]),
        .B(B[2]),
        .CI(C2),
        .S(F[2]),
        .CO()
    );
    full_adder A3(
        .A(A[3]),
        .B(B[3]),
        .CI(C3),
        .S(F[3]),
        .CO()
);

endmodule

