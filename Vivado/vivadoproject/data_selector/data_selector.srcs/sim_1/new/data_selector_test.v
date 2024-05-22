`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/11 19:48:15
// Design Name: 
// Module Name: data_selector_test
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


module data_selector_test(
        );
    reg [1:0] A,B,C,D,S;
    reg EN_;
    wire [1:0] Y;
    
    data_selector uut(         
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .EN_(EN_),
        .S(S),
        .Y(Y)
    );
    
    initial 
    begin
        EN_=0;A=2'b00;B=2'b00;C=2'b00;D=2'b00;S=2'b00;     
    end
    initial
    begin
        #200; EN_=1;A=2'b00;B=2'b01;C=2'b10;D=2'b11;S=2'b01;
        #200; EN_=0;A=2'b00;B=2'b01;C=2'b10;D=2'b11;S=2'b00;
        #200; EN_=0;A=2'b11;B=2'b10;C=2'b01;D=2'b00;S=2'b00;
        #200; EN_=0;A=2'b00;B=2'b01;C=2'b10;D=2'b11;S=2'b01;
        #200; EN_=0;A=2'b11;B=2'b10;C=2'b01;D=2'b00;S=2'b01;
        #200; EN_=0;A=2'b00;B=2'b01;C=2'b10;D=2'b11;S=2'b10;
        #200; EN_=0;A=2'b11;B=2'b10;C=2'b01;D=2'b00;S=2'b10;        
        #200; EN_=0;A=2'b00;B=2'b01;C=2'b10;D=2'b11;S=2'b11;
        #200; EN_=0;A=2'b11;B=2'b10;C=2'b01;D=2'b00;S=2'b11;
        #200; EN_=1;A=2'b11;B=2'b10;C=2'b01;D=2'b00;S=2'b11; 
    end        
endmodule
