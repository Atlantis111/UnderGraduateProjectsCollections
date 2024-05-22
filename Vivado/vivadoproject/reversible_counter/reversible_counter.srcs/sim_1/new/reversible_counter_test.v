`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/09 17:21:57
// Design Name: 
// Module Name: reversible_counter_test
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


module reversible_counter_test(
    );
    
    reg MR,Load_,EN,UpDown,CLK;
    reg [3:0] D;
    wire CO;
    wire [3:0] Q;

    reversible_counter uut(  
        .MR(MR),
        .Load_(Load_),
        .EN(EN),
        .UpDown(UpDown),        
        .CLK(CLK),
        .D(D),
        .CO(CO),
        .Q(Q)
    );
    
    initial 
    begin
        MR=0;Load_=0;EN=0;UpDown=0;CLK=0;D=4'b0000;     
    end
    always #50 CLK=~CLK;
    initial
    begin
        #20; MR=1;Load_=0;EN=0;UpDown=0;D=4'b1111;
        #200; MR=0;Load_=0;EN=1;UpDown=0;D=4'b0011;
        #200; MR=1;Load_=1;EN=0;UpDown=0;D=4'b0011;
        #200; MR=0;Load_=0;EN=0;UpDown=0;D=4'b1101;
        #200; MR=0;Load_=1;EN=0;UpDown=0;D=4'b1001;
        #200; MR=0;Load_=1;EN=1;UpDown=0;D=4'b0001;
        #200; MR=0;Load_=1;EN=1;UpDown=1;D=4'b0110;
        #200; MR=0;Load_=1;EN=1;UpDown=0;D=4'b0100;
    end        
endmodule
