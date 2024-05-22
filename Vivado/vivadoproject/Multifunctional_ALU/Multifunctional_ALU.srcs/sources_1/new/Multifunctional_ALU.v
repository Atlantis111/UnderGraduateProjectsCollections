`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/29 21:22:39
// Design Name: 
// Module Name: Multifunctional_ALU
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



module ALU(ALU_OP,A,B,R,ZF,SF,CF,OF);       //ALU逻辑功能模块
    input [31:0] A,B;
    input [3:0] ALU_OP;
    output reg [31:0] R;
    output reg ZF;
    output reg SF;
    output reg CF;
    output reg OF;
    reg [32:0] F;

    always @(*)
    begin
        case (ALU_OP) 
            4'b0000:begin          //加法
                F <= A + B;
                OF =(~A[31]&~B[31]&F[31])|(A[31]&B[31]&~F[31]);    //排除正数+正数=负数或负数+负数=正数
            end
            4'b0001:begin          //左移
                F <= A<<B;
                OF = 0;
            end
            4'b0010:begin          //有符号数比较(A<B)?1:0
                F <= ( $signed (A) < $signed (B))?1:0;
                OF = 0;
            end
            4'b0011:begin          //无符号数比较(A<B)?1:0
                F <= ( A < B )?1:0;
                OF = 0;
            end
            4'b0100:begin          //异或
                F <= A^B;
                OF = 0;
            end
            4'b0101:begin          //逻辑右移   
                F <= A>>B;
                OF = 0;
            end
            4'b0110:begin          //按位或
                F <= A|B;
                OF = 0;
            end
            4'b0111:begin          //按位与
                F <= A&B;
                OF = 0;
            end
            4'b1000:begin          //减法A-B
                F <= A-B;
                OF = (~A[31]&B[31]&F[31])|(A[31]&~B[31]&~F[31]);
            end
            4'b1101:begin          //算术右移 高位补A
                F <= $signed(A)>>>B;
                OF = 0;
            end
        endcase
        
        CF = F[32];
        SF = F[31];
        ZF = R?0:1;
        R <= F[31:0];
    end
endmodule


module Multifunctional_ALU(clk_100M,_clk_A,_clk_B,_clk_F,_rst,number,operation,sel,seg,F);      //顶层测试模块
    input clk_100M,_clk_A,_clk_B,_clk_F,_rst;
    input [15:0] number;
    input [3:0] operation;
    output [7:0] sel,seg;
    output reg [3:0] F;
   
    wire clk_D;
    wire [31:0] R;
    wire [3:0] light;
    reg [31:0] data;
    reg [31:0] A,B;
    
    Div A0(
        ._rst(_rst),
          .clk_in(clk_100M),
        .frequency(15'd25000),
        .clk_out(clk_D)
    );

    always @(negedge _rst or negedge _clk_A)
    begin
        if(~_rst) begin
            A = 0;
        end
        else if(~operation[3]) begin       //后16位赋值
            A[15:0]<=number[15:0];
        end
        else begin                         //前16位赋值
            A[31:16]<=number[15:0];
        end
    end

    always @(negedge _rst or negedge _clk_B)
    begin
        if(~_rst) begin
            B<=0;
        end
        else if(~operation[3]) begin
            B[15:0]<=number[15:0];
        end
        else begin
            B[31:16]<=number[15:0];
        end
    end
    
    ALU(
        .A(A),
        .B(B),
        .ALU_OP(operation[3:0]),
        .R(R),
        .ZF(light[3]),
        .SF(light[2]),
        .CF(light[1]),
        .OF(light[0])
        );
    
    always @(negedge _rst or negedge _clk_F)
    begin
        if(~_rst) begin
            data<=0;
            F<=0;
        end
        else begin
            data<=R;
            F<=light;
        end
    end

    Display(
        ._rst(_rst),
        .clk_D(clk_D),
        .data(data),
        .sel(sel),
        .seg(seg)
    );
endmodule
