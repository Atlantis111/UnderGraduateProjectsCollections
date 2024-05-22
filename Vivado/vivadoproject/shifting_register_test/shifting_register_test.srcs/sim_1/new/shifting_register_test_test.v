`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/30 18:54:19
// Design Name: 
// Module Name: shifting_register_test_test
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

module shifting_register_test_test(
    );
    reg CR_,CLK;
    reg [1:0] S;
    reg [1:0] RL;
    reg [3:0] D;
    wire [3:0] Q;

    cyclic_shifting_register uut(  
        .CR_(CR_),
        .CLK(CLK),
        .S(S),
        .RL(RL),
        .D(D),        
        .Q(Q)
    );
    
    initial 
    begin
        CR_=0;CLK=1;S=2'b00;RL=2'b00;D=4'b0000;     
    end
    always #50 CLK=~CLK;
    initial
    begin
        #20; CR_=1;S=2'b11;RL=2'b00;D=4'b1100;
        #200; CR_=1;S=2'b11;RL=2'b01;D=4'b1100;   
        #200; CR_=1;S=2'b11;RL=2'b10;D=4'b1110;   
        #200; CR_=1;S=2'b10;RL=2'b01;D=4'b1111;  
        #200; CR_=1;S=2'b10;RL=2'b10;D=4'b1000;  
        #200; CR_=1;S=2'b10;RL=2'b01;D=4'b0000;
        #200; CR_=1;S=2'b01;RL=2'b10;D=4'b1110;
        #200; CR_=1;S=2'b01;RL=2'b01;D=4'b0101;
        #200; CR_=1;S=2'b01;RL=2'b10;D=4'b1010; 
        #200; CR_=1;S=2'b00;RL=2'b01;D=4'b0001;
        #200; CR_=1;S=2'b00;RL=2'b10;D=4'b0111;
        #200; CR_=1;S=2'b00;RL=2'b01;D=4'b1010;
        #100; CR_=0;S=2'b00;RL=2'b10;D=4'b1110;
        #20; CR_=1;S=2'b00;RL=2'b01;D=4'b1010;
        #100; CR_=0;S=2'b00;RL=2'b10;D=4'b0010;
        
    end        
endmodule
