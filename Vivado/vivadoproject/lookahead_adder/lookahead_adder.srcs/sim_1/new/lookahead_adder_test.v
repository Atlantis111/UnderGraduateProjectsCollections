`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/04 19:37:50
// Design Name: 
// Module Name: lookahead_adder_test
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


module lookahead_adder_test(
    );
    reg [3:0] A,B;
    reg C0;
    wire [3:0] F;
    wire C4;
    
    lookaheadadd_4 uut(         //������λ��ǰ��λ�ӷ�������uut
        .A(A),
        .B(B),
        .C0(C0),
        .C4(C4),
        .F(F)
    );
    
    initial begin
        A=0;B=0;C0=0;           //������ΪA=0;B=0;CI=0��ʼ��ÿ��#100��ʱ�䣬ÿ��ʹ��������+1
    end
    always #100 {C0,A,B}={C0,A,B}+1;
endmodule

