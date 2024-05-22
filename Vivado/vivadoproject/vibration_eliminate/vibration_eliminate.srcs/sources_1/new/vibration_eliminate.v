`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/16 16:14:43
// Design Name: 
// Module Name: vibration_eliminate
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


module disp(
    _rst,clk_100M,_key,Out
    );
    input _rst,clk_100M,_key;
    output reg [7:0] Out;
    
    
    wire _key_pulse;
    
    ditheliminater uut(
        ._rst(_rst),
        .clk_100M(clk_100M),
        ._key(_key),
        ._key_pulse(_key_pulse)
    );
    initial begin
        Out=8'b0;
    end
    always @(negedge _key_pulse or negedge _rst)
    begin
        if(~_rst) Out=8'b0;
        else Out=Out+1;
    end
endmodule



module ditheliminater(
    _rst,clk_100M,_key,_key_pulse
    );
    input _rst,clk_100M,_key;
    output reg _key_pulse;
    parameter S0=3'b000,S1=3'b001,S2=3'b010,S3=3'b011,S4=3'b100,S5=3'b101;
    reg Cur_S;
    wire clk_10M;
    
    DivFre uut(
        ._rst(_rst),
        .clk_in(clk_100M),
        .clk_out(clk_10M)
    );
    always @(posedge clk_10M or negedge _rst)
    begin
        if(~_rst) Cur_S=S0;
        else
        case (Cur_S)
            S0:begin
                Cur_S=_key?S0:S1;
                _key_pulse=1;
            end
            S1:begin
                Cur_S=_key?S2:S5;
                _key_pulse=_key?1:0;
            end
            S2:begin
                Cur_S=_key?S0:S1;
                _key_pulse=1;
            end
            S3:begin
                Cur_S=_key?S0:S4;
                _key_pulse=_key?1:0;
            end
            S4:begin
                Cur_S=_key?S3:S5;
                _key_pulse=0;
            end
            S5:begin
                Cur_S=_key?S3:S5;
                _key_pulse=0;
            end
        endcase
    end
endmodule




module DivFre(
    _rst,clk_in,clk_out
    );
    input _rst,clk_in;
    output reg clk_out;
    reg [27:0] n;
    parameter num = 1_000_000;
    always @(negedge _rst or posedge clk_in)
    begin
        if(~_rst) begin n=28'b0;clk_out=0; end
        else
        begin
            if(n<num) n=n+1'b1;
            else
            begin
                n=0;
                clk_out=~clk_out;
            end
        end
    end
endmodule