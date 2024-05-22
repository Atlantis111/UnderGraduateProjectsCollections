`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/28 20:07:42
// Design Name: 
// Module Name: project_1_test
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


module project_1_test();
reg A,B,CI;
wire S,CO;
test project_1(
    .A(A),
    .B(B),
    .CI(CI),
    .S(S),
    .CO(CO)
);
initial
begin 
A=0;B=0;CI=0
end
always #100 {A,B,CI}={A,B,CI}+1; 
endmodule
