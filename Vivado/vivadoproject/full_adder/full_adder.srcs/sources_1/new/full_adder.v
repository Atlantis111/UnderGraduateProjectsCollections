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

module full_adder(      //底层模块，实现一位全加器
    A,B,CI,S,CO
    );
    input A,B,CI;       //定义输入输出和中间变量
    output S,CO;
    wire t1,t2,t3;
    
    xor u1(t1,A,B),     //利用结构建模的方式编写逻辑
        u2(S,t1,CI);
    and u3(t2,A,B),
        u4(t3,t1,CI);
    or u5(CO,t2,t3);
    
endmodule

module add_4(               //顶层模块，串行进位加法器
    A,B,CI,CO,F
    );
    input [3:0] A,B;        //定义4位的输入变量A,B
    input CI;               //定义表示进位的输入变量CI
    output [3:0] F;         //定义4位的输出F
    output CO;              //定义表示最高位输出的输出变量CO
    wire C1,C2,C3;
    
    full_adder A0(          //创建一个全加器的对象A0
        .A(A[0]),
        .B(B[0]),
        .CI(CI),
        .S(F[0]),
        .CO(C1)
    );
    full_adder A1(          //创建一个全加器的对象A1
        .A(A[1]),
        .B(B[1]),
        .CI(C1),
        .S(F[1]),
        .CO(C2)
    );
    full_adder A2(          //创建一个全加器的对象A2
        .A(A[2]),
        .B(B[2]),
        .CI(C2),
        .S(F[2]),
        .CO(C3)
    );
    full_adder A3(          //创建一个全加器的对象A3
        .A(A[3]),
        .B(B[3]),
        .CI(C3),
        .S(F[3]),
        .CO(CO)
    );
endmodule
