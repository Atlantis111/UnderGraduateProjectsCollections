`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/25 20:36:09
// Design Name: 
// Module Name: JK_trigger
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


module JK_trigger(
    input J,
    input K,
    input CLK,
    output reg Q,
    output Q_
    );
    always @(posedge CLK)
    begin
        Q=(J&Q_)|(!K&Q);
    end
    assign Q_=~Q;
endmodule

