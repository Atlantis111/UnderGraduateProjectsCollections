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
    reg [3:0] A,B;      //创建4位输入变量A,B
    reg CI;             //创建表示进位的输入变量CI
    wire [3:0] F;       //定义4位的输出F
    wire CO;            //定义表示最高位输出的输出变量CO
    
    add_4 uut(          //创建四位串行加法器的对象uut
        .A(A),
        .B(B),
        .CI(CI),
        .CO(CO),
        .F(F)
    );
    
    initial begin       //从输入为A=0;B=0;CI=0开始，每隔#100的时间，每次使测试数据+1
        A=0;B=0;CI=0;
    end
    always #100 {CI,A,B}={CI,A,B}+1;
endmodule