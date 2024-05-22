`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/11 19:12:03
// Design Name: 
// Module Name: data_selector
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

module data_selector(A,B,C,D,EN_,S,Y);
    input [1:0] A;
    input [1:0] B;
    input [1:0] C;
    input [1:0] D;
    input EN_;
    input [1:0] S;
    output [1:0] Y;
    reg [1:0] Y;
    
    always @(*)
        if (!EN_)
            if (!S[1])
            begin
                if (!S[0])
                Y = A;
                else
                Y = B;
            end
            else begin
                if (!S[0])
                    Y = C;
                else
                    Y = D;
            end
        else begin
            Y[1] = 0;
            Y[0] = 0;
        end
endmodule
