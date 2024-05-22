`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/28 20:02:47
// Design Name: 
// Module Name: project_1
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

module project_1(A,B,CI,S,CO);
input A,B,CI;
output S,CO;
wire S1,S2;
xor u1(S1,A,B),
    u2(S2,S1,CI);
assign S=S2;
assign CO=(A&B)|(S1&CI);
endmodule

module project_2(A,B,CI,S,CO);
endmodule