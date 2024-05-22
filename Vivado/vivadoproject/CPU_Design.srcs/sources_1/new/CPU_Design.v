`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/04 00:16:00
// Design Name: 
// Module Name: CPU_Design
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
    always @(negedge rst_n or posedge clk_im)
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
    always @(negedge rst_n or posedge clk_im)           ///neg
    begin
        if(~rst_n) begin
            inst <= 0;
        end
        else if (IR_Write) begin
            inst <= Inst_Code;
        end    
        else begin
            inst <= inst; 
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
    assign funct7 = inst[31:25];
    assign rs2 = inst[24:20];
    assign rs1 = inst[19:15];
    assign funct3 = inst[14:12];
    assign rd = inst[11:7];
    assign opcode = inst[6:0];
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
            default: I_fmt=I_fmt;
        endcase
    end
endmodule

module immU(I_fmt,inst,imm32);
    input [5:0] I_fmt;
    input [31:0] inst;
    output reg [31:0] imm32;
    always @(*)
    begin
        case(I_fmt)
            6'b100000:imm32[31:0]=0;        //R型,无立即数
            6'b010000:                      //I型
            begin
                if (inst[14:12]==3'b001||inst[14:12]==3'b101) imm32[31:0]={27'b0,inst[24:20]};
                else imm32[31:0]={ {20{inst[31]}},inst[31:20] };
            end
            6'b001000:imm32[31:0]={ {20{inst[31]}},inst[31:25],inst[11:7] };       //S型  
            6'b000100:imm32[31:0]={ {20{inst[31]}},inst[7],inst[30:25],inst[11:8],1'b0 };        //B型
            6'b000010:imm32[31:0]={ {inst[31:12]},12'b0 };        //U型
            6'b000001:imm32[31:0]={ {12{inst[31]}},inst[19:12],inst[20],inst[30:21],1'b0 };        //J型
            default:imm32=imm32;
        endcase
    end
endmodule

module ID2(opcode,funct3,funct7,IS_R,IS_IMM,IS_LUI,ALU_OP);
    input [6:0] opcode;
    input [2:0] funct3;
    input [6:0] funct7;
    output reg IS_R, IS_IMM, IS_LUI;
    output reg [3:0] ALU_OP;
    always @(*) begin
        case(opcode)
            7'b0110011:begin         //R型
                IS_R=1;
                IS_IMM=0;
                IS_LUI=0;
                ALU_OP={funct7[5],funct3};
            end
            7'b0010011:begin         //I型第一种
                IS_R=0;
                IS_IMM=1;
                IS_LUI=0;
                ALU_OP=(funct3==3'b101)?{funct7[5],funct3}:{1'b0,funct3};
            end
            7'b0000011:begin         //I型第二种
                IS_R=0;
                IS_IMM=1;
                IS_LUI=0;
                ALU_OP=(funct3==3'b101)?{funct7[5],funct3}:{1'b0,funct3};
            end
            7'b1100111:begin         //I型第三种
                IS_R=0;
                IS_IMM=1;
                IS_LUI=0;
                ALU_OP=(funct3==3'b101)?{funct7[5],funct3}:{1'b0,funct3};
            end
            7'b1110011:begin         //I型第四种
                IS_R=0;
                IS_IMM=1;
                IS_LUI=0;
                ALU_OP=(funct3==3'b101)?{funct7[5],funct3}:{1'b0,funct3};
            end
            7'b0110111:begin         //U型第一种
                IS_R=0;
                IS_IMM=0;
                IS_LUI=1;
                ALU_OP=0;
            end
            7'b0010111:begin         //U型第一种
                IS_R=0;
                IS_IMM=0;
                IS_LUI=1;
                ALU_OP=0;
            end
            default:begin
                IS_R=IS_R;
                IS_IMM=IS_IMM;
                IS_LUI=IS_LUI;
                ALU_OP=0;
            end
        endcase
    end
endmodule


module CU(clk,rst_n,IS_R,IS_IMM,IS_LUI,ALU_OP,PC_Write,IR_Write,Reg_Write,rs2_imm_s,w_data_s,ALU_OP_o);
    input clk,rst_n;
    input IS_R,IS_IMM,IS_LUI;
    input [3:0] ALU_OP;
    output reg PC_Write,IR_Write,Reg_Write,rs2_imm_s,w_data_s;
    output reg [3:0] ALU_OP_o;
    reg [2:0] Next_ST,ST;
    parameter Idle=3'b000,S1=3'b001,S2=3'b010,S3=3'b011,S4=3'b100,S5=3'b101,S6=3'b110;
    always @(negedge rst_n or posedge clk)      //第一段，状态转移
    begin
        if (~rst_n) ST<=Idle;
        else ST<=Next_ST;
    end
    always @(*)                                 //第二段，次态函数
    begin
        Next_ST=Idle;
        case(ST)
            Idle:Next_ST=S1;
            S1:begin
                if (IS_LUI) Next_ST=S6;
                else Next_ST=S2;
            end
            S2:begin
                if (IS_R) Next_ST=S3;
                if (IS_IMM) Next_ST=S5;
            end
            S3:Next_ST=S4;
            S4:Next_ST=S1;    
            S5:Next_ST=S4;
            S6:Next_ST=S1;
            default:Next_ST=S1;
        endcase            
    end
    always @(negedge rst_n or posedge clk)      //第三段，输出函数
    begin
        if (~rst_n)
        begin
            PC_Write<=1'b0;
            IR_Write<=1'b0;
            Reg_Write<=1'b0;
            ALU_OP_o<=4'b0000;
            rs2_imm_s<=1'b0;
            w_data_s<=1'b0;
        end
        else begin
            case(Next_ST)
                S1:begin
                    PC_Write<=1'b1;
                    IR_Write<=1'b1;
                    Reg_Write<=1'b0;
                    ALU_OP_o<=4'b0000;
                    rs2_imm_s<=1'b0;
                    w_data_s<=1'b0;
                end
                S2:begin
                    PC_Write<=1'b0;
                    IR_Write<=1'b0;
                    Reg_Write<=1'b0;
                    ALU_OP_o<=4'b0000;
                    rs2_imm_s<=1'b0;
                    w_data_s<=1'b0;
                end
                S3:begin
                    PC_Write<=1'b0;
                    IR_Write<=1'b0;
                    Reg_Write<=1'b0;
                    ALU_OP_o<=ALU_OP;
                    rs2_imm_s<=1'b0;
                    w_data_s<=1'b0;
                end
                S4:begin
                    PC_Write<=1'b0;
                    IR_Write<=1'b0;
                    Reg_Write<=1'b1;
                    ALU_OP_o<=4'b0000;
                    rs2_imm_s<=1'b0;
                    w_data_s<=1'b0;
                end
                S5:begin
                    PC_Write<=1'b0;
                    IR_Write<=1'b0;
                    Reg_Write<=1'b0;
                    ALU_OP_o<=ALU_OP;
                    rs2_imm_s<=1'b1;
                    w_data_s<=1'b0;
                end
                S6:begin
                    PC_Write<=1'b0;
                    IR_Write<=1'b0;
                    Reg_Write<=1'b1;
                    ALU_OP_o<=4'b0000;
                    rs2_imm_s<=1'b0;
                    w_data_s<=1'b1;
                end
            endcase
        end
    end  
endmodule

module Regs(_rst,R_Addr_A,R_Addr_B,W_Addr,R_write,clk_Regs,W_Data,R_Data_A,R_Data_B);
    input _rst,R_write,clk_Regs;
    input [4:0] R_Addr_A,R_Addr_B,W_Addr;
    input [31:0] W_Data;
    output [31:0] R_Data_A,R_Data_B;
    reg [31:0] RegisterFile[31:0];
    always @(negedge _rst or posedge clk_Regs)          //neg
    begin
        if(~_rst) begin
            RegisterFile[0]<=0;
        end
        else if(R_write) begin
            if(W_Addr) RegisterFile[W_Addr]<=W_Data;
        end
    end
    assign R_Data_A=RegisterFile[R_Addr_A];
    assign R_Data_B=RegisterFile[R_Addr_B];
endmodule


module Register_A_B(_rst,clk,inp_A,inp_B,out_A,out_B);
    input [31:0] inp_A;
    input [31:0] inp_B;
    input _rst,clk;
    output reg [31:0] out_A;
    output reg [31:0] out_B;
    always @(negedge _rst or posedge clk)
    begin
        if(~_rst) begin
            out_A<=0;
            out_B<=0;
        end
        else begin
            out_A<=inp_A;
            out_B<=inp_B;
        end
    end
endmodule


module ALU(A,B,ALU_OP,res_F,ZF,SF,CF,OF);
    input [31:0] A,B;
    input [3:0] ALU_OP;
    output reg [31:0] res_F;
    output reg ZF,SF,CF,OF;
    reg [32:0] F;
    parameter ADD=4'b0000,SLL=4'b0001,SLT=4'b0010,SLTU=4'b0011,XOR=4'b0100,SRL=4'b0101,OR=4'b0110,AND=4'b0111,SUB=4'b1000,SRA=4'b1101;
    /*
    ADD:加法
    SLL:左移
    SLT:有符号数比较
    SLTU:无符号数比较
    XOR:异或
    SRL:逻辑右移
    OR:按位或
    AND:按位与
    SUB:减法
    SRA:算术右移
    */
    always @(*)
    begin
        case (ALU_OP)
            ADD:begin
                F=A+B;
                res_F=F[31:0];
            end
            SLL:begin
                F=A<<B;
                res_F=F[31:0];
            end
            SLT:begin
                F=($signed (A) < $signed (B))?1:0;
                res_F=F[31:0];
            end
            SLTU:begin
                F=(A<B)?1:0;
                res_F=F[31:0];
            end
            XOR:begin
                F=A^B;
                res_F=F[31:0];
            end
            SRL:begin   
                F=A>>B;
                res_F=F[31:0];
            end
            OR:begin
                F=A|B;
                res_F=F[31:0];
            end
            AND:begin
                F=A&B;
                res_F=F[31:0];
            end
            SUB:begin
                F=A-B;
                res_F=F[31:0];
            end
            SRA:begin
                F=$signed(A)>>>B;
                res_F=F[31:0];
            end
            default:begin
                res_F=res_F;
            end
        endcase
        if (ALU_OP==ADD) begin
            CF=F[32];
            OF=(~A[31]&~B[31]&F[31])|(A[31]&B[31]&~F[31]);
        end
        else if(ALU_OP==SUB) begin
            CF=F[32];
            OF=(~A[31]&B[31]&F[31])|(A[31]&~B[31]&~F[31]);
        end
        ZF=res_F?0:1;
        SF=F[31];
    end
endmodule

module Register_F(_rst,clk,inp_D,inp_M,out_D,out_M);
    input [31:0] inp_D;
    input [3:0] inp_M;
    input _rst,clk;
    output reg [31:0] out_D;
    output reg [3:0] out_M;
    always @(negedge _rst or posedge clk)
    begin
        if(~_rst) begin
            out_D<=0;
            out_M<=0;
        end
        else begin
            out_D<=inp_D;
            out_M<=inp_M;
        end
    end
endmodule

module Div(_rst,clk_in,frequency,clk_out);
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

module CPU(rst_n,clk,clk_100M,SW,sel,seg,FR);
    input rst_n,clk,clk_100M;      
    input [2:0]SW;          
    output [7:0] sel,seg;
    output [3:0] FR;
    wire clk_D;
    wire PC_Write,IR_Write,Reg_Write,rs2_imm_s,w_data_s;
    wire [31:0] toPc_addr, IM_addr, inst, imm32;
    wire [6:0] funct7;
    wire [4:0] rs2,rs1,rd;
    wire [2:0] funct3;
    wire [6:0] opcode;
    wire [5:0] I_fmt;
    wire IS_R,IS_IMM,IS_LUI;
    wire [3:0] ALU_OP,ALU_OP_o;
    wire [31:0] R_Data_A,R_Data_B,Reg_A,Reg_B,result_F,F;
    wire [31:0] Inst_Code;
    wire [3:0] light;
    reg [31:0] data,W_Data_in,ALU_B;
    PC uut1(
        .rst_n(rst_n),
        .clk_im(clk),
        .PC_Write(PC_Write),
        .in_addr(toPc_addr),
        .out_addr(IM_addr)
    );
    PC_ADD uut2(
        .in_number(IM_addr),
        .out_number(toPc_addr)
    );
    ROM_B uut3(
        .clka(~clk),
        .addra(IM_addr[7:2]),
        .douta(Inst_Code)
    );
    IR_Register uut4(
        .rst_n(rst_n),
        .clk_im(clk),
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
    ID2 uut6(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .IS_R(IS_R),
        .IS_IMM(IS_IMM),
        .IS_LUI(IS_LUI),
        .ALU_OP(ALU_OP)
    );
    CU uut7(
        .clk(~clk),         //取反
        .rst_n(rst_n),
        .IS_R(IS_R),
        .IS_IMM(IS_IMM),
        .IS_LUI(IS_LUI),
        .ALU_OP(ALU_OP),
        .PC_Write(PC_Write),
        .IR_Write(IR_Write),
        .Reg_Write(Reg_Write),
        .rs2_imm_s(rs2_imm_s),
        .w_data_s(w_data_s),
        .ALU_OP_o(ALU_OP_o)
    );
    immU uut8(
        .I_fmt(I_fmt),
        .inst(inst),
        .imm32(imm32)
    );
    Regs uut9(
        ._rst(rst_n),
        .R_Addr_A(rs1),
        .R_Addr_B(rs2),
        .W_Addr(rd),
        .R_write(Reg_Write),
        .clk_Regs(clk),
        .W_Data(W_Data_in),
        .R_Data_A(R_Data_A),
        .R_Data_B(R_Data_B)
    );
    Register_A_B uut10(
        ._rst(rst_n),
        .clk(clk),
        .inp_A(R_Data_A),
        .inp_B(R_Data_B),
        .out_A(Reg_A),
        .out_B(Reg_B)
    );
    always @(*)
    begin
        if(rs2_imm_s) ALU_B=imm32;
        else ALU_B=Reg_B;
    end
    ALU uut13(
        .ALU_OP(ALU_OP_o),
        .A(Reg_A),
        .B(ALU_B),
        .res_F(result_F),
        .ZF(light[3]),
        .SF(light[2]),
        .CF(light[1]),
        .OF(light[0])
    );
    Register_F uut14(
        ._rst(rst_n),
        .clk(clk),
        .inp_D(result_F),
        .inp_M(light[3:0]),
        .out_D(F),
        .out_M(FR)
    );
    always @(*)
    begin
        if(w_data_s) W_Data_in=imm32;
        else W_Data_in=F;
    end
    always @(*) begin
        case(SW)
            3'b000:data= IM_addr[31:0];   
            3'b001:data= inst[31:0];   
            3'b010:data= W_Data_in[31:0];   
            3'b011:data= Reg_A[31:0];   
            3'b100:data= Reg_B[31:0]; 
            3'b101:data= F[31:0];       
            default:data=data;     
        endcase
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




module CPU_Design(rst_n,clk,IM_addr,inst,W_Data_in,Reg_A,Reg_B,FR,F);       //仿真模块
    input rst_n,clk;      
    output [31:0] IM_addr,inst,Reg_A,Reg_B,F;     
    output [3:0] FR;
    output reg [31:0] W_Data_in;  
    wire PC_Write,IR_Write,Reg_Write,rs2_imm_s,w_data_s;
    wire [31:0] toPc_addr, imm32,Inst_Code;
    wire [6:0] funct7;
    wire [4:0] rs2,rs1,rd;
    wire [2:0] funct3;
    wire [6:0] opcode;
    wire [5:0] I_fmt;
    wire IS_R,IS_IMM,IS_LUI;
    wire [3:0] ALU_OP,ALU_OP_o,light;
    wire [31:0] R_Data_A,R_Data_B,result_F;
    reg [31:0] ALU_B;
    PC uut1(
        .rst_n(rst_n),
        .clk_im(clk),
        .PC_Write(PC_Write),
        .in_addr(toPc_addr),
        .out_addr(IM_addr)
    );
    PC_ADD uut2(
        .in_number(IM_addr),
        .out_number(toPc_addr)
    );
    ROM_B uut3(
        .clka(~clk),
        .addra(IM_addr[7:2]),
        .douta(Inst_Code)
    );
    IR_Register uut4(
        .rst_n(rst_n),
        .clk_im(clk),
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
    ID2 uut6(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .IS_R(IS_R),
        .IS_IMM(IS_IMM),
        .IS_LUI(IS_LUI),
        .ALU_OP(ALU_OP)
    );
    CU uut7(
        .clk(~clk),         //取反
        .rst_n(rst_n),
        .IS_R(IS_R),
        .IS_IMM(IS_IMM),
        .IS_LUI(IS_LUI),
        .ALU_OP(ALU_OP),
        .PC_Write(PC_Write),
        .IR_Write(IR_Write),
        .Reg_Write(Reg_Write),
        .rs2_imm_s(rs2_imm_s),
        .w_data_s(w_data_s),
        .ALU_OP_o(ALU_OP_o)
    );
    immU uut8(
        .I_fmt(I_fmt),
        .inst(inst),
        .imm32(imm32)
    );
    Regs uut9(
        ._rst(rst_n),
        .R_Addr_A(rs1),
        .R_Addr_B(rs2),
        .W_Addr(rd),
        .R_write(Reg_Write),
        .clk_Regs(clk),
        .W_Data(W_Data_in),
        .R_Data_A(R_Data_A),
        .R_Data_B(R_Data_B)
    );
    Register_A_B uut10(
        ._rst(rst_n),
        .clk(clk),
        .inp_A(R_Data_A),
        .inp_B(R_Data_B),
        .out_A(Reg_A),
        .out_B(Reg_B)
    );
    always @(*)
    begin
        if(rs2_imm_s) ALU_B=imm32;
        else ALU_B=Reg_B;
    end
    ALU uut14(
        .ALU_OP(ALU_OP_o),
        .A(Reg_A),
        .B(ALU_B),
        .res_F(result_F),
        .ZF(light[3]),
        .SF(light[2]),
        .CF(light[1]),
        .OF(light[0])
    );
    Register_F uut15(
        ._rst(rst_n),
        .clk(clk),
        .inp_D(result_F),
        .inp_M(light[3:0]),
        .out_D(F),
        .out_M(FR)
    );
    always @(*)
    begin
        if(w_data_s) W_Data_in=imm32;
        else W_Data_in=F;
    end
endmodule