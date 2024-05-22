`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/12 11:08:21
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


module ALU(ALU_OP,A,B,R,ZF,SF,CF,OF);       //ALU�߼�����ģ��
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
            4'b0000:begin          //�ӷ�
                F <= A + B;
                OF =(~A[31]&~B[31]&F[31])|(A[31]&B[31]&~F[31]);    //�ų�����+����=��������+����=����
            end
            4'b0001:begin          //����
                F <= A<<B;
                OF = 0;
            end
            4'b0010:begin          //�з������Ƚ�(A<B)?1:0
                F <= ( $signed (A) < $signed (B))?1:0;
                OF = 0;
            end
            4'b0011:begin          //�޷������Ƚ�(A<B)?1:0
                F <= ( A < B )?1:0;
                OF = 0;
            end
            4'b0100:begin          //���
                F <= A^B;
                OF = 0;
            end
            4'b0101:begin          //�߼�����   
                F <= A>>B;
                OF = 0;
            end
            4'b0110:begin          //��λ��
                F <= A|B;
                OF = 0;
            end
            4'b0111:begin          //��λ��
                F <= A&B;
                OF = 0;
            end
            4'b1000:begin          //����A-B
                F <= A-B;
                OF = (~A[31]&B[31]&F[31])|(A[31]&~B[31]&~F[31]);
            end
            4'b1101:begin          //�������� ��λ��A
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
