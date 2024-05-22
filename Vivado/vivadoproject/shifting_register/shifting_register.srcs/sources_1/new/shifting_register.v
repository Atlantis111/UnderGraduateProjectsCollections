`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/02 19:02:00
// Design Name: 
// Module Name: shifting_register
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


module shifting_register(
    input OE_,
    input CLK,
    input [1:0] S,
    input [3:0] D,
    output reg [3:0] Q
    );
    
    always @(posedge CLK or posedge OE_)
        begin
        if (OE_) begin
            Q<=4'bzzzz;
        end
    
        else begin    
        case (S)
            2'b00:begin
                Q <= Q;
            end
            2'b01:begin
                Q <= { Q[2:0],Q[3]};
            end
            2'b10:begin
                Q <= { Q[0],Q[3:1]};
            end
            2'b11:begin
                Q <= { D[3:0]};
            end
        endcase
        end
     end
endmodule

