`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/17 23:07:44
// Design Name: 
// Module Name: RISC_V_ZHZ
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


module DivFre(_rst,clk_in,clk_out);
    input _rst,clk_in;
    output reg clk_out;
    reg [20:0] n;
    parameter num = 1_000_000;
    always @(negedge _rst or posedge clk_in)
    begin
        if(~_rst) begin n<=20'b0;clk_out<=0; end
        else
        begin
            if(n<num) n<=n+1'b1;
            else
            begin
                n<=0;
                clk_out<=~clk_out;
            end
        end
    end
endmodule
 
 
module ditheliminater(_rst,clk_100M,_key,_key_pulse);
    input _rst,clk_100M,_key;
    output reg _key_pulse;
    parameter S0=3'b000,S1=3'b001,S2=3'b010,S3=3'b011,S4=3'b100,S5=3'b101;
    reg [2:0]Cur_S;
    wire clk;
    DivFre ut(
        ._rst(_rst),
        .clk_in(clk_100M),
        .clk_out(clk)
    );
    always @(posedge clk or negedge _rst)
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
 
module IR(_rst,clk_im,IR_Write,Inst_code,inst);
    input _rst,clk_im,IR_Write;
    input [31:0] Inst_code;
    output reg [31:0] inst;
    always @(negedge _rst or negedge clk_im)
    begin
        if(~_rst) begin
            inst<=0;
        end
        else begin
            if(IR_Write) inst<=Inst_code;
            else inst<=inst;
        end
    end
endmodule
 
module PC_add(Addr_in,Addr_out);
    input [31:0] Addr_in;
    output [31:0] Addr_out;
    assign Addr_out=Addr_in+4;
endmodule
 
module PC(_rst,clk_im,PC_Write,Addr_out);
    input _rst,clk_im,PC_Write;
    output reg [31:0] Addr_out;
    reg [31:0] addr_tempin;
    wire [31:0] addr_tempout;
    PC_add(.Addr_in(addr_tempin),.Addr_out(addr_tempout));
    always @(negedge _rst or negedge clk_im)
    begin
        if(~_rst) begin
            addr_tempin<=0;
            Addr_out<=0;
        end
        else begin
            if(PC_Write) begin
                Addr_out<=addr_tempout;
                addr_tempin<=addr_tempout;
            end
            else begin
                Addr_out<=Addr_out;
                addr_tempin<=addr_tempin;
            end
        end
    end
endmodule
 
module InstrFetch(_rst,clk_im,PC_Write,IR_Write,inst,out_addr);
    input _rst,clk_im,PC_Write,IR_Write;
    output [31:0] inst,out_addr;
    wire [31:0] tempout_addr,temp_inst;
    PC(._rst(_rst),.clk_im(~clk_im),.PC_Write(PC_Write),.Addr_out(tempout_addr));
    My_ROM your_instance_name (
        .clka(~clk_im),    // input wire clka
        .addra(tempout_addr[7:2]),  // input wire [5 : 0] addra
        .douta(temp_inst)  // output wire [31 : 0] douta
    );
    IR(._rst(_rst),.clk_im(~clk_im),.IR_Write(IR_Write),.Inst_code(temp_inst),.inst(inst));
    assign out_addr=tempout_addr;
endmodule
 
module ImmU(inst,I_fmt,imm32);
    input [5:0] I_fmt;
    input [31:0] inst;
    output reg [31:0] imm32;
    parameter Rtype=6'b100000,Itype=6'b010000,Stype=6'b001000,Btype=6'b000100,Utype=6'b000010,Jtype=6'b000001;
    always @(*)
    begin
    case (I_fmt)
        Rtype:imm32=0;
        Itype:begin
            if(inst[14:12]==3'b001||inst[14:12]==3'b101) imm32={{27{1'b0}},inst[24:20]};
            else imm32={{20{inst[31]}},inst[31:20]};
        end
        Stype:imm32={{20{inst[31]}},inst[31:25],inst[11:7]};
        Btype:imm32={{20{inst[31]}},inst[7],inst[30:25],inst[11:8],1'b0};
        Utype:imm32={inst[31:12],{12{1'b0}}};
        Jtype:imm32={{12{inst[31]}},inst[19:12],inst[20],inst[30:21],1'b0};
        default:imm32=imm32;
    endcase
    end
endmodule
 
module InstrDec(inst,rs1,rs2,rd,imm32,opcode,func3,func7);
    input [31:0] inst;
    output [2:0] func3;
    output [4:0] rs1,rs2,rd;
    output [6:0] opcode,func7;
    output [31:0] imm32;
    reg [5:0] I_fmt;
    assign rs2=inst[24:20];
    assign rs1=inst[19:15];
    assign rd=inst[11:7];
    assign func3=inst[14:12];
    assign func7=inst[31:25];
    assign opcode=inst[6:0];
    parameter R_code=7'b0110011,I_code1=7'b0010011,I_code2=7'b0000011,S_code=7'b0100011,B_code=7'b1100011,U_code1=7'b0110111,U_code2=7'b0010111,J_code1=7'b1101111,J_code2=7'b1100111;
    always @(*)
    begin
    case (opcode)
        R_code:I_fmt=6'b100000;
        I_code1:I_fmt=6'b010000;
        I_code2:I_fmt=6'b010000;
        S_code:I_fmt=6'b001000;
        B_code:I_fmt=6'b000100;
        U_code1:I_fmt=6'b000010;
        U_code2:I_fmt=6'b000010;
        J_code1:I_fmt=6'b000001;
        J_code2:I_fmt=6'b000001;
        default: I_fmt=I_fmt;
    endcase
    end
    ImmU(.inst(inst),.I_fmt(I_fmt),.imm32(imm32));
endmodule
 
module ID2(opcode,func3,func7,IS_R,IS_IMM,IS_LUI,ALU_OP);
    input [2:0] func3;
    input [6:0] opcode,func7;
    output reg IS_R,IS_IMM,IS_LUI;
    output reg [3:0] ALU_OP;
    parameter R_code=7'b0110011,I_code1=7'b0010011,I_code2=7'b0000011,S_code=7'b0100011,B_code=7'b1100011,U_code1=7'b0110111,U_code2=7'b0010111,J_code1=7'b1101111,J_code2=7'b1100111;
    always @(*) begin
        case(opcode)
            R_code:begin
                IS_R=1;
                IS_IMM=0;
                IS_LUI=0;
                ALU_OP={func7[5],func3};
            end
            I_code1:begin
                IS_R=0;
                IS_IMM=1;
                IS_LUI=0;
                ALU_OP=(func3==3'b101)?{func7[5],func3}:{0,func3};
            end
            U_code1:begin
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
 
module CU(_rst,clk,IS_R,IS_IMM,IS_LUI,ALU_OP,PC_Write,IR_Write,Reg_Write,rs2_imm_s,w_data_s,ALU_OP_o);
    input _rst,clk,IS_R,IS_IMM,IS_LUI;
    input [3:0] ALU_OP;
    output reg PC_Write,IR_Write,Reg_Write,rs2_imm_s,w_data_s;
    output reg [3:0] ALU_OP_o;
    reg [2:0] NEXT_ST,ST;
    parameter Idle=3'b000,S1=3'b001,S2=3'b010,S3=3'b011,S4=3'b100,S5=3'b101,S6=3'b110;
    always @(negedge _rst or posedge clk)
    begin
        if(~_rst) ST=Idle;
        else ST=NEXT_ST;
    end
    always @(*)
    begin
        NEXT_ST=Idle;
        case (ST)
            Idle:NEXT_ST=S1;
            S1:begin
                if(IS_LUI) NEXT_ST=S6;
                else NEXT_ST=S2;
            end
            S2:begin
                if(IS_R) NEXT_ST=S3;
                else NEXT_ST=S5;
            end
            S3:NEXT_ST=S4;
            S4:NEXT_ST=S1;
            S5:NEXT_ST=S4;
            S6:NEXT_ST=S1;
            default:NEXT_ST=S1;
        endcase
    end
    always @(negedge _rst or posedge clk)
    begin
        if(~_rst) begin
            PC_Write<=0;
            IR_Write<=0;
            Reg_Write<=0;
            rs2_imm_s<=0;
            w_data_s<=0;
            ALU_OP_o<=0;
        end
        else begin
            case (NEXT_ST)
                S1:begin
                    PC_Write<=1;
                    IR_Write<=1;
                    Reg_Write<=0;
                    rs2_imm_s<=0;
                    w_data_s<=0;
                    ALU_OP_o<=0;
                end
                S2:begin
                    PC_Write<=0;
                    IR_Write<=0;
                    Reg_Write<=0;
                    rs2_imm_s<=0;
                    w_data_s<=0;
                    ALU_OP_o<=0;
                end
                S3:begin
                    PC_Write<=0;
                    IR_Write<=0;
                    Reg_Write<=0;
                    rs2_imm_s<=0;
                    w_data_s<=0;
                    ALU_OP_o<=ALU_OP;
                end
                S4:begin
                    PC_Write<=0;
                    IR_Write<=0;
                    Reg_Write<=1;
                    rs2_imm_s<=0;
                    w_data_s<=0;
                    ALU_OP_o<=0;
                end
                S5:begin
                    PC_Write<=0;
                    IR_Write<=0;
                    Reg_Write<=0;
                    rs2_imm_s<=1;
                    w_data_s<=0;
                    ALU_OP_o<=ALU_OP;
                end
                S6:begin
                    PC_Write<=0;
                    IR_Write<=0;
                    Reg_Write<=1;
                    rs2_imm_s<=0;
                    w_data_s<=1;
                    ALU_OP_o<=0;
                end
                default:begin
                    PC_Write<=PC_Write;
                    IR_Write<=IR_Write;
                    Reg_Write<=Reg_Write;
                    rs2_imm_s<=rs2_imm_s;
                    w_data_s<=w_data_s;
                    ALU_OP_o<=ALU_OP_o;
                end
            endcase
        end
    end
endmodule
 
module RegHeap(_rst,R_Addr_A,R_Addr_B,W_Addr,R_write,clk_R,W_Data,R_Data_A,R_Data_B);
    input _rst,R_write,clk_R;
    input [4:0] R_Addr_A,R_Addr_B,W_Addr;
    input [31:0] W_Data;
    output [31:0] R_Data_A,R_Data_B;
    reg [31:0] REG_Heap[31:0];
    always @(negedge _rst or posedge clk_R)
    begin
        if(~_rst) begin
            REG_Heap[0]<=0;
        end
        else if(R_write) begin
            if(W_Addr) REG_Heap[W_Addr]<=W_Data;
        end
    end
    assign R_Data_A=REG_Heap[R_Addr_A];
    assign R_Data_B=REG_Heap[R_Addr_B];
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
 
module Reg_Temp(_rst,clk,inp_D,out_D);
    input [31:0] inp_D;
    input _rst,clk;
    output reg [31:0] out_D;
    always @(negedge _rst or posedge clk)
    begin
        if(~_rst) begin
            out_D<=0;
        end
        else begin
            out_D<=inp_D;
        end
    end
endmodule
 
module Reg_Temp_with_Mark(_rst,clk,inp_D,inp_M,out_D,out_M);
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
 
module DivFreq_Display(
    _rst,clk_in,clk_out
    );
    input _rst,clk_in;
    output reg clk_out;
    reg [13:0] n;
    parameter num = 1_00_00;
    always @(negedge _rst or posedge clk_in)
    begin
        if(~_rst) begin n<=14'b0;clk_out<=0; end
        else
        begin
            if(n<num) n<=n+1'b1;
            else
            begin
                n<=0;
                clk_out<=~clk_out;
            end
        end
    end
endmodule
 
module tubeDisplay(_rst,clk_D,data,An,res);
    input _rst,clk_D;
    input [31:0] data;
    output reg [7:0] An,res;
    reg [2:0] bit_sel;
    integer pls;
    always @(negedge _rst or posedge clk_D) begin
        if(~_rst) begin
            An<=8'b11111111;
            res<=8'b00000011;
            bit_sel=0;
        end
        else begin
            bit_sel=bit_sel+1;
            case (bit_sel)
                3'b000:begin An=8'b01111111;pls=268435456; end
                3'b001:begin An=8'b10111111;pls=16777216; end
                3'b010:begin An=8'b11011111;pls=1048576; end
                3'b011:begin An=8'b11101111;pls=65536; end
                3'b100:begin An=8'b11110111;pls=4096; end
                3'b101:begin An=8'b11111011;pls=256; end
                3'b110:begin An=8'b11111101;pls=16; end
                3'b111:begin An=8'b11111110;pls=1; end
            endcase
            case((data/pls)%16)
                4'b0000:res=8'b00000011;
                4'b0001:res=8'b10011111;
                4'b0010:res=8'b00100101;
                4'b0011:res=8'b00001101;
                4'b0100:res=8'b10011001;
                4'b0101:res=8'b01001001;
                4'b0110:res=8'b01000001;
                4'b0111:res=8'b00011111;
                4'b1000:res=8'b00000001;
                4'b1001:res=8'b00001001;
                4'b1010:res=8'b00010001;
                4'b1011:res=8'b11000001;
                4'b1100:res=8'b01100011;
                4'b1101:res=8'b10000101;
                4'b1110:res=8'b01100001;
                4'b1111:res=8'b01110001;
                default:res=8'b00010000;
            endcase
        end
    end
endmodule
 
module CPU_main(clk_100M,_rst,clk,sw,led,res,An);
    input clk_100M,_rst,clk;
    input [2:0] sw;
    output [3:0] led;
    output [7:0] An,res;
    wire clk_D,clk_im,IS_R,IS_IMM,IS_LUI,PC_Write,IR_Write,Reg_Write,rs2_imm_s,w_data_s;
    wire [2:0] func3;
    wire [3:0] ALU_OP_temp,ALU_OP,temp_led;
    wire [4:0] rs1,rs2,rd;
    wire [6:0] opcode,func7;
    wire [31:0] out_addr,inst,imm32,RA,RB,A,B,temp_F,F;
    reg [31:0] data,w_data,tempB;
    ditheliminater(._rst(_rst),.clk_100M(clk_100M),._key(clk),._key_pulse(clk_im));
    DivFreq_Display(._rst(_rst),.clk_in(clk_100M),.clk_out(clk_D));
    InstrFetch(._rst(_rst),.clk_im(clk_im),.PC_Write(PC_Write),.IR_Write(IR_Write),.inst(inst),.out_addr(out_addr));
    InstrDec(.inst(inst),.rs1(rs1),.rs2(rs2),.rd(rd),.imm32(imm32),.opcode(opcode),.func3(func3),.func7(func7));
    ID2(.opcode(opcode),.func3(func3),.func7(func7),.IS_R(IS_R),.IS_IMM(IS_IMM),.IS_LUI(IS_LUI),.ALU_OP(ALU_OP_temp));
    CU(._rst(_rst),.clk(~clk_im),.IS_R(IS_R),
        .IS_IMM(IS_IMM),.IS_LUI(IS_LUI),.ALU_OP(ALU_OP_temp),
        .PC_Write(PC_Write),.IR_Write(IR_Write),.Reg_Write(Reg_Write),
        .rs2_imm_s(rs2_imm_s),.w_data_s(w_data_s),.ALU_OP_o(ALU_OP)
        );
    RegHeap REGH(._rst(_rst),.R_Addr_A(rs1),.R_Addr_B(rs2),.W_Addr(rd),.R_write(Reg_Write),.clk_R(clk_im),.W_Data(w_data),.R_Data_A(RA),.R_Data_B(RB));
    Reg_Temp(._rst(_rst),.clk(clk_im),.inp_D(RA),.out_D(A));
    Reg_Temp(._rst(_rst),.clk(clk_im),.inp_D(RB),.out_D(B));
    always @(*)
    begin
        if(rs2_imm_s) tempB=imm32;
        else tempB=B;
    end
    ALU(.A(A),.B(tempB),.ALU_OP(ALU_OP),.res_F(temp_F),.ZF(temp_led[3]),.SF(temp_led[2]),.CF(temp_led[1]),.OF(temp_led[0]));
    Reg_Temp_with_Mark(._rst(_rst),.clk(clk_im),.inp_D(temp_F),.inp_M(temp_led),.out_D(F),.out_M(led));
    always @(*)
    begin
        if(w_data_s) w_data=imm32;
        else w_data=F;
        case (sw)
            0:data=out_addr;
            1:data=inst;
            2:data=w_data;
            3:data=A;
            4:data=B;
            5:data=F;
            default:data=data;
        endcase
    end
    tubeDisplay(._rst(_rst),.clk_D(clk_D),.data(data),.An(An),.res(res));
endmodule
