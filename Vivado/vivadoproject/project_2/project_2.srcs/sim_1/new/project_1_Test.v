`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/14 20:51:53
// Design Name: 
// Module Name: project_1_Test
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


module sim1(
    );
    reg [1:0] A,B;
    wire F1,F2,F3;
    project_1 u1(
      .A(A),
      .B(B),
      .F(F1)
      );
    project_2 u2(
      .A(A),
      .B(B),
      .F(F2)
      );
    project_3 u3(
      .A(A),
      .B(B),
      .F(F3)
      );
    initial
    begin
      A=1; B=0;
    end
    always #100 {A,B} = {A,B} + 1;
endmodule
        