`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/08 23:10:20
// Design Name: 
// Module Name: taxi_meter
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

//��д�ߣ����Ե
//��Ƶģ��
module Div(
    rst,
    clk_in,
    frequency,
    clk_out
    );
    input rst;
    input clk_in;
    input [25:0] frequency;
    output clk_out;
    
    reg clk_out;
    reg [25:0] cnt;
    
    always @(negedge rst or posedge clk_in)
    begin
        if(~rst) begin 
            cnt<=14'b0;
            clk_out<=0;
        end
        else begin
            if(cnt == frequency/2-1) begin
                cnt<=0;
                clk_out<=~clk_out;
            end
            else cnt=cnt+1;
        end
    end
endmodule

//��д�ߣ����Ե
module Taxi(clk_100M,start,rst,pause,stop,speedup,sel,seg);
    input clk_100M,start,rst,stop;
    input [1:0] speedup;
    input pause; 
    output sel;
    output seg;
    
    wire clk_tube,clk_time; 
    //���Ƴ����߼��ı���
    reg set;        //���ڿ��Ƴ������ͣ��1��ʾû����ͣ��0��ʾ��ͣ��
    reg work;    //��ʾ�������Ƿ���
    reg [15:0] distance;
    reg [15:0] fee;
    reg [3:0] over;   
    reg [3:0] cishu;
    reg [3:0] redtime; 
    //��������ܵı���
    reg [2:0] bit_sel; //λѡ�ź�
    reg [7:0] sel;
    reg [7:0] seg;
    reg [31:0] display;

    //tubeģ���Ƶ
    Div A0(
    .rst(rst),
    .clk_in(clk_100M),
    .frequency(20000),
    .clk_out(clk_tube)
    );
    
    //taxiģ���Ƶ
    Div A1(
    .rst(rst),
    .clk_in(clk_100M),
    .frequency(15'd20000),
    .clk_out(clk_time)
    );
    
    always @(negedge rst or negedge start or posedge clk_time)
    begin
        if(~rst) begin 
            set<=0;
            work<=0;
            cishu<=0;
            redtime<=0;
            fee<=0;
            distance<=0;
            over<=0;
        end
        else if(~start) begin
            set<=1;
            work<=1;
            fee<=60;
            distance<=0;
            over<=0;
        end
        else if (pause) begin
            set<=0;
        end
        
        else if(set) begin     
            if(~stop) begin       
                distance=distance+speedup+1;
                //��������½��ļ���
                if(distance<31) begin   
                    fee<=fee;
                    if(fee>9999) over=4'b1111;
                end
                else if(distance<151) begin  
                    if(distance<41) cishu=distance-30;
                    else cishu=cishu+speedup+1;
                    if(cishu>9) begin
                        cishu=cishu-10;
                        fee=fee+12;
                        if(fee>9999) over=4'b1111;
                    end
                end
                else begin   
                    cishu=cishu+speedup+1;
                    if(cishu>9) begin
                        cishu=cishu-10;
                        fee=fee+18;
                        if(fee>9999) over=4'b1111;
                    end
                end
            end
            else begin 
                redtime=redtime+1;
                if(redtime>=10) begin
                    redtime=0;
                    fee=fee+5;
                end
            end
        end
        else if ((~pause)&work)  set<=1;  //�������ѷ�����״̬�²ſ�ȡ����ͣ
        else begin 
            fee<=fee;distance<=distance; 
        end
    end
    
    
    
    //��д�ߣ�������
    //�����
    always @(negedge rst or posedge clk_tube) begin
        display[31:28]<=fee/1000;           //��ȡ���ú���̴����display�У�4λ���һ������
        display[27:24]<=(fee/100)%10;
        display[23:20]<=(fee/10)%10;
        display[19:16]<=fee%10;
        
        display[15:12]<=distance/1000;
        display[11:8]<=(distance/100)%10;
        display[7:4]<=(distance/10)%10;
        display[3:0]<=distance%10;

        if(~rst) begin       
            sel<=8'b11111111;
            seg<=8'b00000011;
            bit_sel=0;
        end
        
        else begin                  
            bit_sel=bit_sel+1;              //ÿ����λѡ�ź�+1
            case (bit_sel)                  //3λλѡ�źŶ�Ӧ��8��״̬����Ӧ������ܵİ�λ
                3'b000:sel=8'b01111111;
                3'b001:sel=8'b10111111;
                3'b010:sel=8'b11011111;
                3'b011:sel=8'b11101111;
                3'b100:sel=8'b11110111;
                3'b101:sel=8'b11111011;
                3'b110:sel=8'b11111101;
                3'b111:sel=8'b11111110;
            endcase
            case (sel)
                8'b01111111:begin               //���������ʾ���õĵ�һλʱ
                    case (display[31:28]|over)
                        4'b0000:seg=8'b00000011;
                        4'b0001:seg=8'b10011111;
                        4'b0010:seg=8'b00100101;
                        4'b0011:seg=8'b00001101;
                        4'b0100:seg=8'b10011001;
                        4'b0101:seg=8'b01001001;
                        4'b0110:seg=8'b01000001;
                        4'b0111:seg=8'b00011111;
                        4'b1000:seg=8'b00000001;
                        4'b1001:seg=8'b00001001;
                        default:seg=8'b00010000;
                    endcase
                end
                8'b10111111:begin               //���������ʾ���õĵڶ�λʱ
                    case (display[27:24]|over)
                        4'b0000:seg=8'b00000011;
                        4'b0001:seg=8'b10011111;
                        4'b0010:seg=8'b00100101;
                        4'b0011:seg=8'b00001101;
                        4'b0100:seg=8'b10011001;
                        4'b0101:seg=8'b01001001;
                        4'b0110:seg=8'b01000001;
                        4'b0111:seg=8'b00011111;
                        4'b1000:seg=8'b00000001;
                        4'b1001:seg=8'b00001001;
                        default:seg=8'b00010000;
                    endcase
                end
                8'b11011111:begin               //���������ʾ���õĵ���λʱ
                    case (display[23:20]|over)
                        4'b0000:seg=8'b00000010;
                        4'b0001:seg=8'b10011110;
                        4'b0010:seg=8'b00100100;
                        4'b0011:seg=8'b00001100;
                        4'b0100:seg=8'b10011000;
                        4'b0101:seg=8'b01001000;
                        4'b0110:seg=8'b01000000;
                        4'b0111:seg=8'b00011110;
                        4'b1000:seg=8'b00000000;
                        4'b1001:seg=8'b00001000;
                        default:seg=8'b00010000;
                    endcase
                end 
                8'b11101111:begin               //���������ʾ���õĵ���λʱ
                    case (display[19:16]|over)
                        4'b0000:seg=8'b00000011;
                        4'b0001:seg=8'b10011111;
                        4'b0010:seg=8'b00100101;
                        4'b0011:seg=8'b00001101;
                        4'b0100:seg=8'b10011001;
                        4'b0101:seg=8'b01001001;
                        4'b0110:seg=8'b01000001;
                        4'b0111:seg=8'b00011111;
                        4'b1000:seg=8'b00000001;
                        4'b1001:seg=8'b00001001;
                        default:seg=8'b00010000;
                    endcase
                end
                8'b11110111:begin               //���������ʾ��̵ĵ�һλʱ
                    case (display[15:12]|over)
                        4'b0000:seg=8'b00000011;
                        4'b0001:seg=8'b10011111;
                        4'b0010:seg=8'b00100101;
                        4'b0011:seg=8'b00001101;
                        4'b0100:seg=8'b10011001;
                        4'b0101:seg=8'b01001001;
                        4'b0110:seg=8'b01000001;
                        4'b0111:seg=8'b00011111;
                        4'b1000:seg=8'b00000001;
                        4'b1001:seg=8'b00001001;
                        default:seg=8'b00010000;
                    endcase
                end 
                8'b11111011:begin               //���������ʾ��̵ĵڶ�λʱ
                    case (display[11:8]|over)
                        4'b0000:seg=8'b00000011;
                        4'b0001:seg=8'b10011111;
                        4'b0010:seg=8'b00100101;
                        4'b0011:seg=8'b00001101;
                        4'b0100:seg=8'b10011001;
                        4'b0101:seg=8'b01001001;
                        4'b0110:seg=8'b01000001;
                        4'b0111:seg=8'b00011111;
                        4'b1000:seg=8'b00000001;
                        4'b1001:seg=8'b00001001;
                        default:seg=8'b00010000;
                    endcase
                end
                8'b11111101:begin               //���������ʾ��̵ĵ���λʱ
                    case (display[7:4]|over)
                        4'b0000:seg=8'b00000010;
                        4'b0001:seg=8'b10011110;
                        4'b0010:seg=8'b00100100;
                        4'b0011:seg=8'b00001100;
                        4'b0100:seg=8'b10011000;
                        4'b0101:seg=8'b01001000;
                        4'b0110:seg=8'b01000000;
                        4'b0111:seg=8'b00011110;
                        4'b1000:seg=8'b00000000;
                        4'b1001:seg=8'b00001000;
                        default:seg=8'b00010000;
                    endcase
                end
                8'b11111110:begin               //���������ʾ��̵ĵ���λʱ
                    case (display[3:0]|over)
                        4'b0000:seg=8'b00000011;
                        4'b0001:seg=8'b10011111;
                        4'b0010:seg=8'b00100101;
                        4'b0011:seg=8'b00001101;
                        4'b0100:seg=8'b10011001;
                        4'b0101:seg=8'b01001001;
                        4'b0110:seg=8'b01000001;
                        4'b0111:seg=8'b00011111;
                        4'b1000:seg=8'b00000001;
                        4'b1001:seg=8'b00001001;
                        default:seg=8'b00010000;
                    endcase
                end
            endcase
        end
    end
endmodule

