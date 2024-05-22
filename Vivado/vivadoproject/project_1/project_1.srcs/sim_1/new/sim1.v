`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/25 14:12:59
// Design Name: 
// Module Name: sim1
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
    reg A,B,C;
    test1 u1(A,B,C,F);
    initial
    begin
      A=0; B=0; C=0;
    end
    always #10 {A,B,C} ={A,B,C} +1;
endmodule
