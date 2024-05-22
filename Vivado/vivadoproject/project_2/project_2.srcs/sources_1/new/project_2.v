`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/28 12:46:11
// Design Name: 
// Module Name: project_2
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


module project_2(A,B,F);
    input [1:0]A;
    input [1:0]B;
    wire F1,F2;
    output F;
    xnor s1(F1,A[0],B[0]);
    xnor s2(F2,A[1],B[1]);
    and s(F,F1,F2);
endmodule
