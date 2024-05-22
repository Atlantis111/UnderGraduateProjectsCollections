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

module PC0(_rst,clk,PC0_Write,inp_PC,out_PC);         //PC0寄存器
    input [31:0] inp_PC;
    input _rst,clk, PC0_Write;
    output reg [31:0] out_PC;
    always @(negedge _rst or posedge clk)
    begin
        if(~_rst) begin
            out_PC<=0;
        end
        else if (PC0_Write) begin
            out_PC<=inp_PC;
        end
        else begin
            out_PC<=out_PC;
        end 
    end
endmodule

module PC_addr_ADD(out_PC,immU,out_addr_PC);       //PC相对转移地址加法器
    input [31:0] out_PC;
    input [31:0] immU;
    output reg [31:0] out_addr_PC;
    always @(*)
    begin
        out_addr_PC = out_PC + immU;
    end
endmodule

module IR_Register(rst_n,clk_im,IR_Write,Inst_Code,inst);           //IR指令寄存器
    input rst_n,clk_im;
    input IR_Write;
    input [31:0] Inst_Code;
    output reg [31:0] inst;
    always @(negedge rst_n or posedge clk_im)      
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

module Code_Translation(inst,funct7,rs2,rs1,funct3,rd,opcode,I_fmt);        //初级译码器
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

module immU(I_fmt,inst,imm32);          //立即数拼接与扩展器
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

module ID2(opcode,funct3,funct7,IS_R,IS_IMM,IS_LUI,IS_JAL,IS_LW,IS_SW,IS_JALR,IS_BEQ,ALU_OP);     //二级译码器
    input [6:0] opcode;
    input [2:0] funct3;
    input [6:0] funct7;
    output reg IS_R, IS_IMM, IS_LUI, IS_JAL,IS_LW,IS_SW,IS_JALR,IS_BEQ ;
    output reg [3:0] ALU_OP;
    always @(*) begin
        case(opcode)
            7'b0110011:begin         //R型
                IS_R=1;
                IS_IMM=0;
                IS_LUI=0;
                IS_JAL=0;
                IS_LW=0;
                IS_SW=0;
                IS_JALR=0;
                IS_BEQ=0;
                ALU_OP={funct7[5],funct3};
            end
            7'b0010011:begin         //I型第一种
                IS_R=0;
                IS_IMM=1;
                IS_LUI=0;
                IS_JAL=0;
                IS_LW=0;
                IS_SW=0;
                IS_JALR=0;
                IS_BEQ=0;
                ALU_OP=(funct3==3'b101)?{funct7[5],funct3}:{1'b0,funct3};
            end
            7'b0000011:begin         //I型第二种，针对lw
                IS_R=0;
                IS_IMM=0;
                IS_LUI=0;
                IS_JAL=0;
                IS_LW=1;
                IS_SW=0;
                IS_JALR=0;
                IS_BEQ=0;
                ALU_OP=4'b0000;
            end
            7'b1100111:begin         //I型第三种，针对jalr
                IS_R=0;
                IS_IMM=0;
                IS_LUI=0;
                IS_JAL=0;
                IS_LW=0;
                IS_SW=0;
                IS_JALR=1;
                IS_BEQ=0;
                ALU_OP=4'b0000;
            end
            7'b0110111:begin         //U型，针对lui
                IS_R=0;
                IS_IMM=0;
                IS_LUI=1;
                IS_JAL=0;
                IS_LW=0;
                IS_SW=0;
                IS_JALR=0;
                IS_BEQ=0;
                ALU_OP=4'b0000;
            end
            7'b0100011:begin         //S型，针对sw
                IS_R=0;
                IS_IMM=0;
                IS_LUI=0;
                IS_JAL=0;
                IS_LW=0;
                IS_SW=1;
                IS_JALR=0;
                IS_BEQ=0;
                ALU_OP=4'b0000;
            end
            7'b1100011:begin         //B型，针对beq
                IS_R=0;
                IS_IMM=0;
                IS_LUI=0;
                IS_JAL=0;
                IS_LW=0;
                IS_SW=0;
                IS_JALR=0;
                IS_BEQ=1;
                ALU_OP=4'b0000;
            end
            7'b1100011:begin         //J型，针对jal
                IS_R=0;
                IS_IMM=0;
                IS_LUI=0;
                IS_JAL=1;
                IS_LW=0;
                IS_SW=0;
                IS_JALR=0;
                IS_BEQ=0;
                ALU_OP=4'b0000;
            end
            default:begin
                IS_R=IS_R;
                IS_IMM=IS_IMM;
                IS_LUI=IS_LUI;
                IS_JAL=IS_JAL;
                IS_LW=IS_LW;
                IS_SW=IS_SW;
                IS_JALR=IS_JALR;
                IS_BEQ=IS_BEQ;
                ALU_OP=ALU_OP;
            end
        endcase
    end
endmodule


module CU(clk,rst_n,IS_R,IS_IMM,IS_LUI,IS_JAL,IS_LW,IS_SW,IS_JALR,IS_BEQ,ALU_OP,PC_Write,PC0_Write,IR_Write,Reg_Write,Mem_Write,rs2_imm_s,w_data_s,PC_s,ALU_OP_o,FR);    //指令控制器
    input clk,rst_n;
    input IS_R,IS_IMM,IS_LUI,IS_JAL,IS_LW,IS_SW,IS_JALR,IS_BEQ;
    input [3:0] ALU_OP,FR;
    output reg PC_Write,PC0_Write,IR_Write,Reg_Write,Mem_Write,rs2_imm_s;
    output reg [1:0]w_data_s,PC_s;
    output reg [3:0] ALU_OP_o;
    reg [3:0] Next_ST,ST;
    parameter Idle=4'b0000,S1=4'b0001,S2=4'b0010,S3=4'b0011,S4=4'b0100,S5=4'b0101,S6=4'b0110,S7=4'b0111,S8=4'b1000,S9=4'b1001,S10=4'b1010,S11=4'b1011,S12=4'b1100,S13=4'b1101,S14=4'b1110;
    always @(negedge rst_n or posedge clk)      //第一段，状态转移
    begin
        if (~rst_n) ST<=Idle;
        else ST<=Next_ST;
    end
    always @(*)                                 //第二段，次态函数
    begin
        Next_ST=Idle;
        case(ST)
            Idle:begin
                Next_ST=S1;
            end
            S1:begin
                if (IS_LUI) Next_ST=S6;
                else if (IS_LW|IS_SW|IS_JALR|IS_BEQ) Next_ST=S2;
                else Next_ST=S11;
            end
            S2:begin
                if (IS_R) Next_ST=S3;
                else if (IS_IMM) Next_ST=S5;
                else if (IS_LW|IS_SW|IS_JALR) Next_ST=S7;
                else Next_ST=S13;
            end
            S3:begin
                if (IS_R) Next_ST=S4;  
            end
            S4:begin
                Next_ST=S1;
            end
            S5:begin
                if (IS_IMM) Next_ST=S4;  
            end
            S6:begin
                Next_ST=S1;
            end
            S7:begin
                if (IS_LW) Next_ST=S8;
                else if (IS_SW) Next_ST=S10;
                else Next_ST=S12;
            end
            S8:begin
                if (IS_LW) Next_ST=S9;  
            end
            S9:begin
                Next_ST=S1;
            end
            S10:begin
                Next_ST=S1;
            end
            S11:begin
                Next_ST=S1;
            end
            S12:begin
                Next_ST=S1;
            end
            S13:begin
                if (IS_BEQ) Next_ST=S14;  
            end
            S14:begin
                Next_ST=S1;
            end
            default:Next_ST=S1;
        endcase            
    end
    always @(negedge rst_n or posedge clk)      //第三段，输出函数
    begin
        if (~rst_n)
        begin
            PC_Write<=1'b0;
            PC0_Write<=1'b0;
            IR_Write<=1'b0;
            Reg_Write<=1'b0;
            Mem_Write<=1'b0;
            ALU_OP_o<=4'b0000;
            rs2_imm_s<=1'b0;
            w_data_s<=2'b00;
            PC_s<=2'b00;
        end
        else begin
            case(Next_ST)
                S1:begin
                    PC_Write<=1'b1;
                    PC0_Write<=1'b1;
                    IR_Write<=1'b1;
                    Reg_Write<=1'b0;
                    Mem_Write<=1'b0;
                    ALU_OP_o<=4'b0000;
                    rs2_imm_s<=1'b0;
                    w_data_s<=2'b00;
                    PC_s<=2'b00;
                end
                S2:begin
                    PC_Write<=1'b0;
                    PC0_Write<=1'b0;
                    IR_Write<=1'b0;
                    Reg_Write<=1'b0;
                    Mem_Write<=1'b0;
                    ALU_OP_o<=4'b0000;
                    rs2_imm_s<=1'b0;
                    w_data_s<=2'b00;
                    PC_s<=2'b00;
                end
                S3:begin
                    PC_Write<=1'b0;
                    PC0_Write<=1'b0;
                    IR_Write<=1'b0;
                    Reg_Write<=1'b0;
                    Mem_Write<=1'b0;
                    ALU_OP_o<=ALU_OP;
                    rs2_imm_s<=1'b0;
                    w_data_s<=2'b00;
                    PC_s<=2'b00;
                end
                S4:begin
                    PC_Write<=1'b0;
                    PC0_Write<=1'b0;
                    IR_Write<=1'b0;
                    Reg_Write<=1'b1;
                    Mem_Write<=1'b0;
                    ALU_OP_o<=4'b0000;
                    rs2_imm_s<=1'b0;
                    w_data_s<=2'b00;
                    PC_s<=2'b00;
                end
                S5:begin
                    PC_Write<=1'b0;
                    PC0_Write<=1'b0;
                    IR_Write<=1'b0;
                    Reg_Write<=1'b0;
                    Mem_Write<=1'b0;
                    ALU_OP_o<=ALU_OP;
                    rs2_imm_s<=1'b1;
                    w_data_s<=2'b00;
                    PC_s<=2'b00;
                end
                S6:begin
                    PC_Write<=1'b0;
                    PC0_Write<=1'b0;
                    IR_Write<=1'b0;
                    Reg_Write<=1'b1;
                    Mem_Write<=1'b0;
                    ALU_OP_o<=4'b0000;
                    rs2_imm_s<=1'b0;
                    w_data_s<=2'b01;
                    PC_s<=2'b00;
                end
                S7:begin
                    PC_Write<=1'b0;
                    PC0_Write<=1'b0;
                    IR_Write<=1'b0;
                    Reg_Write<=1'b0;
                    Mem_Write<=1'b0;
                    ALU_OP_o<=4'b0000;
                    rs2_imm_s<=1'b1;
                    w_data_s<=2'b00;
                    PC_s<=2'b00;
                end
                S8:begin
                    PC_Write<=1'b0;
                    PC0_Write<=1'b0;
                    IR_Write<=1'b0;
                    Reg_Write<=1'b0;
                    Mem_Write<=1'b0;
                    ALU_OP_o<=4'b0000;
                    rs2_imm_s<=1'b0;
                    w_data_s<=2'b00;
                    PC_s<=2'b00;
                end
                S9:begin
                    PC_Write<=1'b0;
                    PC0_Write<=1'b0;
                    IR_Write<=1'b0;
                    Reg_Write<=1'b1;
                    Mem_Write<=1'b0;
                    ALU_OP_o<=4'b0000;
                    rs2_imm_s<=1'b0;
                    w_data_s<=2'b10;
                    PC_s<=2'b00;
                end
                S10:begin
                    PC_Write<=1'b0;
                    PC0_Write<=1'b0;
                    IR_Write<=1'b0;
                    Reg_Write<=1'b0;
                    Mem_Write<=1'b1;
                    ALU_OP_o<=4'b0000;
                    rs2_imm_s<=1'b0;
                    w_data_s<=2'b00;
                    PC_s<=2'b00;
                end
                S11:begin
                    PC_Write<=1'b1;
                    PC0_Write<=1'b0;
                    IR_Write<=1'b0;
                    Reg_Write<=1'b1;
                    Mem_Write<=1'b0;
                    ALU_OP_o<=4'b0000;
                    rs2_imm_s<=1'b0;
                    w_data_s<=2'b11;
                    PC_s<=2'b01;
                end
                S12:begin
                    PC_Write<=1'b1;
                    PC0_Write<=1'b0;
                    IR_Write<=1'b0;
                    Reg_Write<=1'b1;
                    Mem_Write<=1'b0;
                    ALU_OP_o<=4'b0000;
                    rs2_imm_s<=1'b0;
                    w_data_s<=2'b11;
                    PC_s<=2'b10;
                end
                S13:begin
                    PC_Write<=1'b0;
                    PC0_Write<=1'b0;
                    IR_Write<=1'b0;
                    Reg_Write<=1'b0;
                    Mem_Write<=1'b0;
                    ALU_OP_o<=4'b1000;
                    rs2_imm_s<=1'b0;
                    w_data_s<=2'b00;
                    PC_s<=2'b00;
                end
                S14:begin
                    PC_Write<=FR[3];
                    PC0_Write<=1'b0;
                    IR_Write<=1'b0;
                    Reg_Write<=1'b0;
                    Mem_Write<=1'b0;
                    ALU_OP_o<=4'b0000;
                    rs2_imm_s<=1'b0;
                    w_data_s<=2'b00;
                    PC_s<=2'b01;
                end
            endcase
        end
    end  
endmodule

module Regs(_rst,R_Addr_A,R_Addr_B,W_Addr,R_write,clk_Regs,W_Data,R_Data_A,R_Data_B);        //寄存器堆
    input _rst,R_write,clk_Regs;
    input [4:0] R_Addr_A,R_Addr_B,W_Addr;
    input [31:0] W_Data;
    output [31:0] R_Data_A,R_Data_B;
    reg [31:0] RegisterFile[31:0];
    always @(negedge _rst or posedge clk_Regs) 
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


module Register_A_B(_rst,clk,inp_A,inp_B,out_A,out_B);            //A,B暂存器
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


module ALU(A,B,ALU_OP,res_F,ZF,SF,CF,OF);           //ALU逻辑运算器
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

module Register_F(_rst,clk,inp_D,inp_M,out_D,out_M);            //运算结果与标志符暂存器
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

module MDR(_rst,clk,inp_data,out_data);         //数据存储器结果暂存器
    input [31:0] inp_data;
    input _rst,clk;
    output reg [31:0] out_data;
    always @(negedge _rst or posedge clk)
    begin
        if(~_rst) begin
            out_data<=0;
        end
        else begin
            out_data<=inp_data;
        end
    end
endmodule

module Div(_rst,clk_in,frequency,clk_out);          //数码管分频器
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


module Display(_rst,clk_D,data,sel,seg);        //数码管显示
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


module CPU(rst_n,clk,clk_100M,SW,sel,seg,FR);           //顶层模块
    input rst_n,clk,clk_100M;      
    input [2:0]SW;          
    output [7:0] sel,seg;
    output [3:0] FR;
    wire clk_D;
    wire PC_Write,IR_Write,Reg_Write,rs2_imm_s,w_data_s,PC0_Write,PC_s,Mem_Write;
    wire [31:0] IM_addr, inst, imm32;
    wire [6:0] funct7;
    wire [4:0] rs2,rs1,rd;
    wire [2:0] funct3;
    wire [6:0] opcode;
    wire [5:0] I_fmt;
    wire IS_R,IS_IMM,IS_LUI,IS_JAL,IS_LW,IS_SW,IS_JALR,IS_BEQ;
    wire [3:0] ALU_OP,ALU_OP_o;
    wire [31:0] R_Data_A,R_Data_B,Reg_A,Reg_B,result_F,F;
    wire [31:0] Inst_Code;
    wire [31:0] out_PC,out_addr_PC,out_PC_ADD,M_R_Data,out_M_R_Data;
    wire [3:0] light;
    reg [31:0] data,W_Data_in,ALU_B,toPc_addr;
    PC uut1(                        
        .rst_n(rst_n),
        .clk_im(clk),
        .PC_Write(PC_Write),
        .in_addr(toPc_addr),
        .out_addr(IM_addr)
    );
    PC_ADD uut2(
        .in_number(IM_addr),
        .out_number(out_PC_ADD)
    );
    PC0 uut3(
        ._rst(rst_n),
        .clk(clk),
        .PC0_Write(PC0_Write),
        .inp_PC(IM_addr),
        .out_PC(out_PC)
    );  
    PC_addr_ADD uut4(
        .out_PC(out_PC),
        .immU(imm32),
        .out_addr_PC(out_addr_PC)
    ); 
    always @(*)
    begin
        if (PC_s==00) toPc_addr=out_PC_ADD;
        else if (PC_s==01) toPc_addr=out_addr_PC;
        else toPc_addr=F;
    end
    ROM_B uut5(
        .clka(~clk),
        .addra(IM_addr[7:2]),
        .douta(Inst_Code)
    );
    IR_Register uut6(
        .rst_n(rst_n),
        .clk_im(clk),
        .Inst_Code(Inst_Code),
        .IR_Write(IR_Write),
        .inst(inst)
    );
    Code_Translation uut7(
        .inst(inst),
        .funct7(funct7),
        .rs2(rs2),
        .rs1(rs1),
        .funct3(funct3),
        .rd(rd),
        .opcode(opcode),
        .I_fmt(I_fmt)
    );
    ID2 uut8(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .IS_R(IS_R),
        .IS_IMM(IS_IMM),
        .IS_LUI(IS_LUI),
        .IS_JAL(IS_JAL),
        .IS_LW(IS_LW),
        .IS_SW(IS_SW),
        .IS_JALR(IS_JALR),
        .IS_BEQ(IS_BEQ),
        .ALU_OP(ALU_OP)
    );
    CU uut9(
        .clk(~clk), 
        .rst_n(rst_n),
        .IS_R(IS_R),
        .IS_IMM(IS_IMM),
        .IS_LUI(IS_LUI),
        .IS_JAL(IS_JAL),
        .IS_LW(IS_LW),
        .IS_SW(IS_SW),
        .IS_JALR(IS_JALR),
        .IS_BEQ(IS_BEQ),
        .ALU_OP(ALU_OP),
        .PC_Write(PC_Write),
        .PC0_Write(PC0_Write),
        .IR_Write(IR_Write),
        .Reg_Write(Reg_Write),
        .Mem_Write(Mem_Write),
        .rs2_imm_s(rs2_imm_s),
        .w_data_s(w_data_s),
        .PC_s(PC_s),
        .FR(FR),
        .ALU_OP_o(ALU_OP_o)
    ); 
    immU uut10(
        .I_fmt(I_fmt),
        .inst(inst),
        .imm32(imm32)
    );
    Regs uut11(
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
    Register_A_B uut12(
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
    DM uut15(
        .clka(~clk),
        .wea(Mem_Write),
        .addra(F[7:2]),
        .dina(Reg_B),
        .douta(M_R_Data)
    );
    MDR uut16(
        ._rst(rst_n),
        .clk(clk),
        .inp_data(M_R_Data),
        .out_data(out_M_R_Data)
    );
    always @(*)
    begin
        if(w_data_s==00) W_Data_in=F;
        else if(w_data_s==01) W_Data_in=imm32;
        else if(w_data_s==10) W_Data_in=out_M_R_Data;
        else W_Data_in=IM_addr;
    end
    always @(*) begin
        case(SW)
            3'b000:data= IM_addr[31:0];   
            3'b001:data= inst[31:0];   
            3'b010:data= W_Data_in[31:0];   
            3'b011:data= Reg_A[31:0];   
            3'b100:data= ALU_B[31:0]; 
            3'b101:data= F[31:0];   
            3'b110:data= out_M_R_Data[31:0];     
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











module CPU_Design_three(rst_n,clk,IM_addr,inst,W_Data_in,Reg_A,Reg_B,FR,F,out_M_R_Data);           //仿真模块
    input rst_n,clk;  
    output [31:0] IM_addr,inst,Reg_A,Reg_B,F,out_M_R_Data;     
    output [3:0] FR;
    output reg [31:0] W_Data_in;             
    wire PC_Write,IR_Write,Reg_Write,rs2_imm_s,w_data_s,PC0_Write,PC_s,Mem_Write;
    wire [31:0] IM_addr, inst, imm32;
    wire [6:0] funct7;
    wire [4:0] rs2,rs1,rd;
    wire [2:0] funct3;
    wire [6:0] opcode;
    wire [5:0] I_fmt;
    wire IS_R,IS_IMM,IS_LUI,IS_JAL,IS_LW,IS_SW,IS_JALR,IS_BEQ;
    wire [3:0] ALU_OP,ALU_OP_o;
    wire [31:0] R_Data_A,R_Data_B,Reg_A,Reg_B,result_F,F;
    wire [31:0] Inst_Code;
    wire [31:0] out_PC,out_addr_PC,out_PC_ADD,M_R_Data;
    wire [3:0] light;
    reg [31:0] data,ALU_B,toPc_addr;
    PC uut1(                        
        .rst_n(rst_n),
        .clk_im(clk),
        .PC_Write(PC_Write),
        .in_addr(toPc_addr),
        .out_addr(IM_addr)
    );
    PC_ADD uut2(
        .in_number(IM_addr),
        .out_number(out_PC_ADD)
    );
    PC0 uut3(
        ._rst(rst_n),
        .clk(clk),
        .PC0_Write(PC0_Write),
        .inp_PC(IM_addr),
        .out_PC(out_PC)
    );  
    PC_addr_ADD uut4(
        .out_PC(out_PC),
        .immU(imm32),
        .out_addr_PC(out_addr_PC)
    ); 
    always @(*)
    begin
        if (PC_s==00) toPc_addr=out_PC_ADD;
        else if (PC_s==01) toPc_addr=out_addr_PC;
        else toPc_addr=F;
    end
    ROM_B uut5(
        .clka(~clk),
        .addra(IM_addr[7:2]),
        .douta(Inst_Code)
    );
    IR_Register uut6(
        .rst_n(rst_n),
        .clk_im(clk),
        .Inst_Code(Inst_Code),
        .IR_Write(IR_Write),
        .inst(inst)
    );
    Code_Translation uut7(
        .inst(inst),
        .funct7(funct7),
        .rs2(rs2),
        .rs1(rs1),
        .funct3(funct3),
        .rd(rd),
        .opcode(opcode),
        .I_fmt(I_fmt)
    );
    ID2 uut8(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .IS_R(IS_R),
        .IS_IMM(IS_IMM),
        .IS_LUI(IS_LUI),
        .IS_JAL(IS_JAL),
        .IS_LW(IS_LW),
        .IS_SW(IS_SW),
        .IS_JALR(IS_JALR),
        .IS_BEQ(IS_BEQ),
        .ALU_OP(ALU_OP)
    );
    CU uut9(
        .clk(~clk), 
        .rst_n(rst_n),
        .IS_R(IS_R),
        .IS_IMM(IS_IMM),
        .IS_LUI(IS_LUI),
        .IS_JAL(IS_JAL),
        .IS_LW(IS_LW),
        .IS_SW(IS_SW),
        .IS_JALR(IS_JALR),
        .IS_BEQ(IS_BEQ),
        .ALU_OP(ALU_OP),
        .PC_Write(PC_Write),
        .PC0_Write(PC0_Write),
        .IR_Write(IR_Write),
        .Reg_Write(Reg_Write),
        .Mem_Write(Mem_Write),
        .rs2_imm_s(rs2_imm_s),
        .w_data_s(w_data_s),
        .PC_s(PC_s),
        .FR(FR),
        .ALU_OP_o(ALU_OP_o)
    ); 
    immU uut10(
        .I_fmt(I_fmt),
        .inst(inst),
        .imm32(imm32)
    );
    Regs uut11(
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
    Register_A_B uut12(
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
    DM uut15(
        .clka(~clk),
        .wea(Mem_Write),
        .addra(F[7:2]),
        .dina(Reg_B),
        .douta(M_R_Data)
    );
    MDR uut16(
        ._rst(rst_n),
        .clk(clk),
        .inp_data(M_R_Data),
        .out_data(out_M_R_Data)
    );
    always @(*)
    begin
        if(w_data_s==00) W_Data_in=F;
        else if(w_data_s==01) W_Data_in=imm32;
        else if(w_data_s==10) W_Data_in=out_M_R_Data;
        else W_Data_in=IM_addr;
    end
endmodule
