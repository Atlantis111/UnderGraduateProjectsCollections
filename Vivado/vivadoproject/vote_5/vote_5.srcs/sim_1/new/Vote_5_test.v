`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/02 20:20:28
// Design Name: 
// Module Name: Vote_5_test
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


module Vote_5_test;
    reg A,B,C,D,E;
    wire F;
    
    Vote_5 uut(
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .E(E),
        .F(F)
    );
    
    //Ã¶¾Ù
    initial
        {A,B,C,D,E}=5'b0;
    
    always
    begin
        #100;
        {A,B,C,D,E}={A,B,C,D,E}+1'b1;
    end
endmodule
