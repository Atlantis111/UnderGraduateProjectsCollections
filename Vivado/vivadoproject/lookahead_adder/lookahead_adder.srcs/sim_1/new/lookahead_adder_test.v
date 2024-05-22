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
    
    lookaheadadd_4 uut(         //创建四位超前进位加法器对象uut
        .A(A),
        .B(B),
        .C0(C0),
        .C4(C4),
        .F(F)
    );
    
    initial begin
        A=0;B=0;C0=0;           //从输入为A=0;B=0;CI=0开始，每隔#100的时间，每次使测试数据+1
    end
    always #100 {C0,A,B}={C0,A,B}+1;
endmodule

