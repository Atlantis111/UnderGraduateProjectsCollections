`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/30 18:38:38
// Design Name: 
// Module Name: shifting_register_test
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


module shifting_register_test(
    input CR_,
    input CLK,
    input [1:0] S,              //功能选择
    input [1:0] RL,             //串行输入
    input [3:0] D,              //并行输入
    output reg [3:0] Q         //输出
    );
    
    always @(posedge CLK or negedge CR_)
        begin
        if (CR_==1'b0) begin
            Q<=4'b0000;
        end
    
        else begin    
        case (S)
            2'b00:begin
                Q <= Q;
            end
            2'b01:begin
                Q <= { RL[1],Q[3:1]};            
            end
            2'b10:begin
                Q <= { Q[2:0],RL[0]};
            end
            2'b11:begin
                Q <= { D[3:0]};
            end
        endcase
        end
        
     end
endmodule

    
module cyclic_shifting_register(               
    CR_,CLK,S,RL,D,Q
    );
    input CR_;
    input CLK;
    input [1:0] S;              //功能选择
    input [1:0] RL;             //串行输入
    input [3:0] D;              //并行输入
    output [3:0] Q;        //输出
    reg [1:0] C;
    
    
    shifting_register_test A0(          //创建一个移位器的对象A0
        .CR_(CR_),
        .CLK(CLK),
        .S(S),
        .RL(C),
        .D(D),
        .Q(Q)
    );
    always @(*)
    begin
        C[1]=Q[0];
        C[0]=Q[3];
    end

endmodule

