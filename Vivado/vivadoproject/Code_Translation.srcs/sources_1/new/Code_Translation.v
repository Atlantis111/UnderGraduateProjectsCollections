`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/30 21:03:09
// Design Name: 
// Module Name: Code_Translation
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


module PC(rst_n,clk_im,PC_Write,in_addr,out_addr);       //程序计数器PC
    input rst_n,clk_im,PC_Write;
    input [31:0] in_addr;
    output reg [31:0] out_addr;
    always @(negedge rst_n or negedge clk_im)
    begin
        if(~rst_n) begin
            out_addr<=0;
        end
        else if (PC_Write) begin
            out_addr<=in_addr;
        end
        else begin
             out_addr<=out_addr;
        end
    end
endmodule

module PC_ADD(in_number,out_number);       //PC自增计数器
    input [31:0] in_number;
    output reg [31:0] out_number;
    always @(*)
    begin
        out_number = in_number + 4'b100;
    end
endmodule

module IR_Register(rst_n,clk_im,IR_Write,Inst_Code,inst);
    input rst_n,clk_im;
    input IR_Write;
    input [31:0] Inst_Code;
    output reg [31:0] inst;
    always @(negedge rst_n or negedge clk_im)
    begin
        if(~rst_n) begin
            inst <= 0;
        end
        else if (IR_Write) begin
            inst <= Inst_Code;
        end
    end
endmodule


module Code_Translation(inst,funct7,rs2,rs1,funct3,rd,opcode,I_fmt);
    input [31:0] inst;
    output [6:0] funct7;
    output [4:0] rs2;
    output [4:0] rs1;
    output [2:0] funct3;
    output [4:0] rd;
    output [6:0] opcode;
    output reg [5:0] I_fmt;
    always @(*)
    begin
        case(opcode)
            7'b0110011:I_fmt[5:0]=6'b100000;        //R型
            7'b0010011:I_fmt[5:0]=6'b010000;        //I型
            7'b0000011:I_fmt[5:0]=6'b010000;
            7'b1100111:I_fmt[5:0]=6'b010000;
            7'b1110011:I_fmt[5:0]=6'b010000;
            7'b0100011:I_fmt[5:0]=6'b001000;        //S型  
            7'b1100011:I_fmt[5:0]=6'b000100;        //B型
            7'b0110111:I_fmt[5:0]=6'b000010;        //U型
            7'b0010111:I_fmt[5:0]=6'b000010;
            7'b1101111:I_fmt[5:0]=6'b000001;        //J型
        endcase
    end
    assign funct7 = inst[31:25];
    assign rs2 = inst[24:20];
    assign rs1 = inst[19:15];
    assign funct3 = inst[14:12];
    assign rd = inst[11:7];
    assign opcode = inst[6:0];
endmodule

module immU(I_fmt,inst,imm32);
    input [5:0] I_fmt;
    input [31:0] inst;
    output reg [31:0] imm32;
    always @(*)
    begin
        case(I_fmt)
            6'b100000:imm32[31:0]=0;        //R型,无立即数
            6'b010000:imm32[31:0]={ {20{inst[31]}},inst[31:20] };        //I型
            6'b001000:imm32[31:0]={ {20{inst[31]}},inst[31:25],inst[11:7] };       //S型  
            6'b000100:imm32[31:0]={ {20{inst[31]}},inst[7],inst[30:25],inst[11:8],1'b0 };        //B型
            6'b000010:imm32[31:0]={ {inst[31:12]},12'b0 };        //U型
            6'b000001:imm32[31:0]={ {12{inst[31]}},inst[19:12],inst[20],inst[30:21],1'b0 };        //J型
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


module Code_Translation_test(clk_100M,IR_Write,PC_Write,clk_im,rst_n,SW,sel,seg,light);
    input IR_Write, PC_Write;       //IR开关，PC开关
    input clk_im,rst_n,clk_100M;      //存储器，PC，IR按键
    input [2:0] SW;                  //最高位控制显示灯，低两位控制数码管
    output [7:0] sel,seg;
    output reg [19:0] light;
    wire [31:0] toPc_addr;
    wire [31:0] IM_addr;
    wire [31:0] Inst_Code;
    wire [31:0] inst;
    wire [6:0] funct7;
    wire [4:0] rs2;
    wire [4:0] rs1;
    wire [2:0] funct3;
    wire [4:0] rd;
    wire [6:0] opcode;
    wire [5:0] I_fmt;
    wire [31:0] imm32;
    wire clk_D;
    reg [31:0] data;
    
    PC uut1(
        .rst_n(rst_n),
        .clk_im(clk_im),
        .PC_Write(PC_Write),
        .in_addr(toPc_addr),
        .out_addr(IM_addr)
    );
    PC_ADD uut2(
        .in_number(IM_addr),
        .out_number(toPc_addr)
    );
    ROM_B uut3(
        .clka(~clk_im),
        .addra(IM_addr[7:2]),
        .douta(Inst_Code)
    );
    IR_Register uut4(
        .rst_n(rst_n),
        .clk_im(clk_im),
        .Inst_Code(Inst_Code),
        .IR_Write(IR_Write),
        .inst(inst)
    );
    Code_Translation uut5(
        .inst(inst),
        .funct7(funct7),
        .rs2(rs2),
        .rs1(rs1),
        .funct3(funct3),
        .rd(rd),
        .opcode(opcode),
        .I_fmt(I_fmt)
    );
    immU uut6(
        .I_fmt(I_fmt),
        .inst(inst),
        .imm32(imm32)
    );
    always @(*) begin
        begin
            case(SW[1:0])
                2'b00:data={ IM_addr[31:0] };     
                2'b01:data={ inst[31:0] };
                2'b10:data={ imm32[31:0] };
                default:data=data;     
            endcase
        end
        begin
            case(SW[2])
                1'b0:light = {{rs1[4:0]},{rs2[4:0]},{rd[4:0]},5'b00000};     
                1'b1:light = {{opcode[6:0]},{funct3[2:0]},{funct7[6:0]},3'b000}; 
                default:data=data;         
            endcase
        end
    end
    Div(
        ._rst(rst_n),
        .clk_in(clk_100M),
        .frequency(15'd25000),
        .clk_out(clk_D)
    );
    Display(
        ._rst(rst_n),
        .clk_D(clk_D),
        .data(data),
        .sel(sel),
        .seg(seg)
    );
endmodule



//以下为仿真模块
module Code_Translation_pack(IR_Write,PC_Write,clk_im,rst_n,inst);
    input IR_Write, PC_Write;       //IR开关，PC开关
    input clk_im,rst_n;      //存储器，PC，IR按键
    output [31:0] inst;
    wire [31:0] toPc_addr;
    wire [31:0] IM_addr;
    wire [31:0] Inst_Code;
    PC uut10(
        .rst_n(rst_n),
        .clk_im(clk_im),
        .PC_Write(PC_Write),
        .in_addr(toPc_addr),
        .out_addr(IM_addr)
    );
    PC_ADD uut11(
        .in_number(IM_addr),
        .out_number(toPc_addr)
    );
    ROM_B uut12(
        .clka(clk_im),
        .addra(IM_addr[7:2]),
        .douta(Inst_Code)
    );
    IR_Register uut13(
        .rst_n(rst_n),
        .clk_im(clk_im),
        .Inst_Code(Inst_Code),
        .IR_Write(IR_Write),
        .inst(inst)
    );
endmodule

