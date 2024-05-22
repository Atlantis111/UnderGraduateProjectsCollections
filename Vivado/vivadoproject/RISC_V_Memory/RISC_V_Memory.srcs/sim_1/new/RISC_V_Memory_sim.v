`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/16 22:30:10
// Design Name: 
// Module Name: RISC_V_Memory_sim
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




module RISC_V_Memory_sim();
    reg clka,wea;
    reg [7:0] addra;
    reg [31:0] dina;
    wire [31:0] douta;
    RAM_B Simu(
        .clka(clka),
        .wea(wea),
        .addra(addra),
        .dina(dina),
        .douta(douta)  
    );
    initial clka=0;
    always #50 clka=~clka;  //每25ns，时钟翻转一次

initial begin
        addra=6'b000001;wea=1'b0;
        addra=6'b000010;#100;
        addra=6'b000011;#100;
        addra=6'b000100;#100;
        addra=6'b000101;#100;
        addra=6'b000110;#100;
        addra=6'b000111;#100;
        addra=6'b001000;#100;
        addra=6'b001001;#100;
        addra=6'b001010;#100;
        addra=6'b001010;wea=1'b1;dina=32'h12345678;#100;
        end
endmodule

