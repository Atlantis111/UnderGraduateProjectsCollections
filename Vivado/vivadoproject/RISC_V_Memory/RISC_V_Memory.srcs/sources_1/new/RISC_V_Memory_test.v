`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/16 14:09:28
// Design Name: 
// Module Name: RISC_V_Memory_test
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


module Data_select(M_W_Data_s,M_W_Data);
    input [1:0] M_W_Data_s;
    output reg [31:0] M_W_Data;
    always @(*)
    begin
        case (M_W_Data_s) 
            2'b00:begin 
                M_W_Data=32'h00000000;
            end
            2'b01:begin 
                M_W_Data=32'h11111111;
            end
            2'b10:begin   
                M_W_Data=32'h22222222;
            end
            2'b11:begin    
                M_W_Data=32'h33333333;   
            end    
        endcase
     end
endmodule


module Div(         //分频器模块
    _rst,
    clk_in,
    frequency,
    clk_out
    );
    input _rst;
    input clk_in;
    input [25:0] frequency;
    output clk_out;
    reg clk_out;
    reg [25:0] cnt;
    
    always @(negedge _rst or posedge clk_in)
    begin
        if(~_rst) begin 
            cnt<=14'b0;
            clk_out<=0;
        end
        else begin
            if(cnt == frequency/2-1) begin
                cnt<=0;
                clk_out<=~clk_out;
            end
            else cnt=cnt+1;
        end
    end
endmodule


module Display(_rst,clk_D,data,sel,seg);        //数码管显示模块
    input _rst,clk_D;
    input [31:0] data;
    output reg [7:0] sel,seg;
    reg [2:0] bit_sel;
    integer pls;
    always @(negedge _rst or posedge clk_D) begin
        if(~_rst) begin
            sel<=8'b11111111;
            seg<=8'b00000011;
            bit_sel=0;
        end
        else begin
            bit_sel=bit_sel+1;
            case (bit_sel)
                3'b000:begin sel=8'b01111111;pls=268435456; end
                3'b001:begin sel=8'b10111111;pls=16777216; end
                3'b010:begin sel=8'b11011111;pls=1048576; end
                3'b011:begin sel=8'b11101111;pls=65536; end
                3'b100:begin sel=8'b11110111;pls=4096; end
                3'b101:begin sel=8'b11111011;pls=256; end
                3'b110:begin sel=8'b11111101;pls=16; end
                3'b111:begin sel=8'b11111110;pls=1; end
            endcase
            case((data/pls)%16)
                4'b0000:seg[7:0]=8'b00000011;
                4'b0001:seg[7:0]=8'b10011111;
                4'b0010:seg[7:0]=8'b00100101;
                4'b0011:seg[7:0]=8'b00001101;
                4'b0100:seg[7:0]=8'b10011001;
                4'b0101:seg[7:0]=8'b01001001;
                4'b0110:seg[7:0]=8'b01000001;
                4'b0111:seg[7:0]=8'b00011111;
                4'b1000:seg[7:0]=8'b00000001;
                4'b1001:seg[7:0]=8'b00001001;
                4'b1010:seg[7:0]=8'b00010001;
                4'b1011:seg[7:0]=8'b11000001;
                4'b1100:seg[7:0]=8'b01100011;
                4'b1101:seg[7:0]=8'b10000101;
                4'b1110:seg[7:0]=8'b01100001;
                4'b1111:seg[7:0]=8'b01110001;
                default:seg[7:0]=8'b00010000;
            endcase
        end
    end
endmodule


module RISC_V_Memory_test(clk_100M, _rst , DM_addr, M_W_Data_s, clk_dm, Mem_Write, sel, seg);
    input clk_100M,_rst;
    input clk_dm;
    input Mem_Write;            //1是执行写操作，0执行读操作
    input [7:0] DM_addr;        //前六位指定32位地址，最后两位对应lw和sw指令
    input [1:0] M_W_Data_s;     //选择数据
    output [7:0] sel,seg;
    wire clk_D;
    wire [31:0] M_R_Data;
    wire [31:0] M_W_Data;
    
    Data_select(
        .M_W_Data_s(M_W_Data_s[1:0]),
        .M_W_Data(M_W_Data)
    );
    RAM_B Data_RAM(
        .clka(clk_dm),
        .wea(Mem_Write),
        .addra(DM_addr[7:2]),
        .dina(M_W_Data[31:0]),
        .douta(M_R_Data[31:0])
    );
    Div(
        ._rst(_rst),
        .clk_in(clk_100M),
        .frequency(15'd25000),
        .clk_out(clk_D)
    );
    Display(
        ._rst(_rst),
        .clk_D(clk_D),
        .data(M_R_Data[31:0]),
        .sel(sel),
        .seg(seg)
    );
endmodule

