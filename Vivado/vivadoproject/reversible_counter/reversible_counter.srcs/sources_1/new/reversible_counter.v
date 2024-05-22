`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/09 16:32:06
// Design Name: 
// Module Name: reversible_counter
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

module reversible_counter(
    input MR,
    input Load_,
    input EN,
    input UpDown,
    input CLK,
    input [3:0] D,
    output reg CO,
    output reg [3:0] Q
    );
    
    always @(posedge CLK or posedge MR)
        begin
        
            if (MR) begin
                Q<=4'b0000;
                CO=0;
            end
            
            else if (!Load_)
            begin
                Q<=D;
                CO=0;
            end
            
            else if (EN)
                if (UpDown)
                begin
                Q<=Q+1'b1;
                    if (Q==4'b1111)
                        CO=1;
                    else
                        CO=0;
                end
                
                else begin
                Q<=Q-1'b1;
                    if (Q==4'b0000) 
                        CO=1;
                    else 
                        CO=0;
                end
                
            else begin
                Q<=Q;
                CO=CO;
            end
        end
    endmodule

