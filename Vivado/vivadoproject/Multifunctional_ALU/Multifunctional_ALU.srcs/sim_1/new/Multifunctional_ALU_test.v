module ALU_simu(
    );
    reg [31:0] A,B;
    reg[3:0] ALU_OP;
    wire [31:0] res_F;
    wire ZF,SF,CF,OF;
    ALU Simu(.A(A),.B(B),.ALU_OP(ALU_OP),.R(res_F),.ZF(ZF),.SF(SF),.CF(CF),.OF(OF));
    initial begin
        A=32'hfec85d14;
        B=1;
        ALU_OP=0;
        #50 ALU_OP=1;
        #50 ALU_OP=2;
        #50 ALU_OP=3;
        #50 ALU_OP=4;
        #50 ALU_OP=5;
        #50 ALU_OP=6;
        #50 ALU_OP=7;
        #50 ALU_OP=8;
        #50 ALU_OP=9;
        #50 A=1;
        B=32'hfec85d14;
        ALU_OP=0;
        #50 ALU_OP=1;
        #50 ALU_OP=2;
        #50 ALU_OP=3;
        #50 ALU_OP=4;
        #50 ALU_OP=5;
        #50 ALU_OP=6;
        #50 ALU_OP=7;
        #50 ALU_OP=8;
        #50 ALU_OP=9;
    end
endmodule