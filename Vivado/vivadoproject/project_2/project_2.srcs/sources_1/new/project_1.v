`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/14 20:15:48
// Design Namem// Module Name: project_1
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


module project_1(A,B,F);
    input [1:0]A;
    input [1:0]B;
    output F;
    assign F=((~A[1])&(~B[1])|(A[1]&B[1]))&((~A[0])&(~B[0])|(A[0]&B[0]));
endmodule
