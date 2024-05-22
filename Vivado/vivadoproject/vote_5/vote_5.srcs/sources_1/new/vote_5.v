`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/02 19:49:45
// Design Name: 
// Module Name: vote_5
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


module Vote_5(
    input A,
    input B,
    input C,
    input D,
    input E,
    output F
    );
    wire [10:1] T;
    and U1(T[1],A,B,C);
    and U2(T[2],A,B,D);
    and U3(T[3],A,B,E);
    and U4(T[4],A,C,D);
    and U5(T[5],A,C,E);
    and U6(T[6],A,D,E);
    and U7(T[7],B,C,D);
    and U8(T[8],B,D,E);
    and U9(T[9],C,D,E);
    and U10(T[10],B,C,E);
    or U11(F, T[1], T[2], T[3], T[4], T[5], T[6], T[7], T[8], T[9], T[10]);
endmodule
