`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/02 19:09:02
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
    );
    reg OE_,CLK;
    reg [1:0] S;
    reg [3:0] D;
    wire [3:0] Q;

    shifting_register uut(  
        .OE_(OE_),
        .CLK(CLK),
        .S(S),
        .D(D),        
        .Q(Q)
    );
    
    initial 
    begin
        OE_=1;CLK=1;S=2'b00;D=4'b0000;     
    end
    always #50 CLK=~CLK;
    initial
    begin
        #20; OE_=1;S=2'b11;D=4'b1100;
        #200; OE_=0;S=2'b11;D=4'b1100;   
        #200; OE_=0;S=2'b11;D=4'b1110;   
        #200; OE_=0;S=2'b10;D=4'b1111;  
        #200; OE_=0;S=2'b10;D=4'b1000;  
        #200; OE_=0;S=2'b10;D=4'b0000;
        #200; OE_=0;S=2'b01;D=4'b1110;
        #200; OE_=0;S=2'b01;D=4'b0101;
        #200; OE_=0;S=2'b01;D=4'b1010; 
        #200; OE_=0;S=2'b00;D=4'b0001;
        #200; OE_=0;S=2'b00;D=4'b0111;
        #200; OE_=0;S=2'b00;D=4'b1010;
        #100; OE_=1;S=2'b00;D=4'b1110;
        #20; OE_=0;S=2'b00;D=4'b1010;
        #100; OE_=1;S=2'b00;D=4'b0010;
        
    end        
endmodule
