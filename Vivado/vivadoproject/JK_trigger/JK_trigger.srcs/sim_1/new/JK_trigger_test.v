`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/12/02 15:59:23
// Design Name: 
// Module Name: JK_trigger_test
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


module JK_trigger_test(
    );
    reg CLK,J,K;
    wire Q,Q_;
    
    
 
    JK_trigger uut(  
        .CLK(CLK),
        .J(J),
        .K(K),
        .Q(Q),
        .Q_(Q_)
    );
    
    initial 
    begin
        CLK=1;J=0;K=0;     
    end
    always #50 CLK=~CLK;
    initial
    begin
        #20; J=0;K=1;
        #200; J=1;K=1;
        #200; J=1;K=0;
        #200; J=0;K=0;
        #200; J=0;K=0;
    end        
endmodule
   
    

