`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/28 13:32:21
// Design Name: 
// Module Name: project_3
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


module project_3(A,B,F);
    input wire [1:0]A;
    input wire [1:0]B;
    output reg F;
    always @(*) begin
        if((A[0]==B[0])&&(A[1]==B[1])) F=1;
        else F=0;
    end
endmodule
