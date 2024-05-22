`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// COdmpany: 
// Engineer: 
// 
// Create Date: 2020/12/23 18:33:46
// Design Name: 
// Module Name: Taxi
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional COdmments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Taxi(clk_100M,start_,end_,pause,traflight,velo,An,res);
    input clk_100M,start_,end_,pause,traflight; //E3管脚输入、开始信号、结束信号、暂停信号、交通灯信号
    input [1:0] velo; //车速，共0.1km/s,0.2km/s,0.3km/s,0.4km/s四档
    output reg [7:0] An,res; //数码管扫描输出
    reg [31:0] display; //数码管扫描使用的BCD码
    reg [15:0] dis; //计程，初始车程为0km
    reg [15:0] fee; //计费，初始车费为6.0元
    reg [3:0] Overcharge; //计费超额
    reg [3:0] cnd,cnf; //里程计费和红灯停止计费的计数器，每超过10就让计费器计费额按照规则增加
    reg [2:0] bit_sel; //位选信号
    reg ava,work; //ava为1表示汽车当前正常运转（包括行驶和红灯停车），反之则表示汽车当前暂停；work为1表示汽车已发动，反之则表示汽车未发动
    wire clk_D,clk_P; //数码管扫描和计数的钟控信号
    //钟控信号获取
    DivFreq_Display(._rst(end_),.clk_in(clk_100M),.clk_out(clk_D));
    DivFreq_Plus(._rst(end_),.clk_in(clk_100M),.clk_out(clk_P));
    //汽车状态处理
    always @(negedge end_ or negedge start_ or posedge clk_P)
    begin
        if(~end_) begin //停车结算
            ava<=0;work<=0;cnd<=0;cnf<=0;fee<=0;dis<=0;Overcharge<=0;
        end
        else if(~start_) begin //发车
            ava<=1;work<=1;fee<=60;dis<=0;Overcharge<=0;
        end
        else if(pause) begin //暂停
            ava<=0;
        end
        else if(ava) begin //非暂停时汽车正常运转
            if(~traflight) begin //正常行驶时的情况
                dis=dis+velo+1;
                if(dis<31) begin //小于等于3km时的情况
                    fee<=fee;
                    if(fee>9999) Overcharge=4'b1111;
                end
                else if(dis<151) begin //小于等于15km时的情况
                    if(dis<41) cnd=dis-30;
                    else cnd=cnd+velo+1;
                    if(cnd>9) begin
                        cnd=cnd-10;
                        fee=fee+12;
                        if(fee>9999) Overcharge=4'b1111;
                    end
                end
                else begin //大于15km时的情况
                    cnd=cnd+velo+1;
                    if(cnd>9) begin
                        cnd=cnd-10;
                        fee=fee+18;
                        if(fee>9999) Overcharge=4'b1111;
                    end
                end
            end
            else begin //红灯停车时的情况
                cnf=cnf+1;
                if(cnf>=10) begin
                    cnf=0;
                    fee=fee+5;
                end
            end
        end
        else if((~pause)&work) ava<=1; //汽车在已发动的状态下才可取消暂停
        else begin fee<=fee;dis<=dis; end //其他情况下车费和里程不变
    end
    //数码管扫描部分
    always @(negedge end_ or posedge clk_D) begin
        //获取展示用的BCD码
        display[31:28]<=fee/1000;display[27:24]<=(fee/100)%10;display[23:20]<=(fee/10)%10;display[19:16]<=fee%10;
        display[15:12]<=dis/1000;display[11:8]<=(dis/100)%10;display[7:4]<=(dis/10)%10;display[3:0]<=dis%10;
        //数码管扫描初始化
        if(~end_) begin
            An<=8'b11111111;
            res<=8'b00000011;
            bit_sel=0;
        end
        else begin
            bit_sel=bit_sel+1;
            case (bit_sel)
                3'b000:An=8'b01111111;
                3'b001:An=8'b10111111;
                3'b010:An=8'b11011111;
                3'b011:An=8'b11101111;
                3'b100:An=8'b11110111;
                3'b101:An=8'b11111011;
                3'b110:An=8'b11111101;
                3'b111:An=8'b11111110;
            endcase
            case (An)
                8'b01111111:begin
                    case (display[31:28]|Overcharge)
                        4'b0000:res=8'b00000011;
                        4'b0001:res=8'b10011111;
                        4'b0010:res=8'b00100101;
                        4'b0011:res=8'b00001101;
                        4'b0100:res=8'b10011001;
                        4'b0101:res=8'b01001001;
                        4'b0110:res=8'b01000001;
                        4'b0111:res=8'b00011111;
                        4'b1000:res=8'b00000001;
                        4'b1001:res=8'b00001001;
                        default:res=8'b00010000;
                    endcase
                end
                8'b10111111:begin
                    case (display[27:24]|Overcharge)
                        4'b0000:res=8'b00000011;
                        4'b0001:res=8'b10011111;
                        4'b0010:res=8'b00100101;
                        4'b0011:res=8'b00001101;
                        4'b0100:res=8'b10011001;
                        4'b0101:res=8'b01001001;
                        4'b0110:res=8'b01000001;
                        4'b0111:res=8'b00011111;
                        4'b1000:res=8'b00000001;
                        4'b1001:res=8'b00001001;
                        default:res=8'b00010000;
                    endcase
                end
                8'b11011111:begin
                    case (display[23:20]|Overcharge)
                        4'b0000:res=8'b00000010;
                        4'b0001:res=8'b10011110;
                        4'b0010:res=8'b00100100;
                        4'b0011:res=8'b00001100;
                        4'b0100:res=8'b10011000;
                        4'b0101:res=8'b01001000;
                        4'b0110:res=8'b01000000;
                        4'b0111:res=8'b00011110;
                        4'b1000:res=8'b00000000;
                        4'b1001:res=8'b00001000;
                        default:res=8'b00010000;
                    endcase
                end
                8'b11101111:begin
                    case (display[19:16]|Overcharge)
                        4'b0000:res=8'b00000011;
                        4'b0001:res=8'b10011111;
                        4'b0010:res=8'b00100101;
                        4'b0011:res=8'b00001101;
                        4'b0100:res=8'b10011001;
                        4'b0101:res=8'b01001001;
                        4'b0110:res=8'b01000001;
                        4'b0111:res=8'b00011111;
                        4'b1000:res=8'b00000001;
                        4'b1001:res=8'b00001001;
                        default:res=8'b00010000;
                    endcase
                end
                8'b11110111:begin
                    case (display[15:12]|Overcharge)
                        4'b0000:res=8'b00000011;
                        4'b0001:res=8'b10011111;
                        4'b0010:res=8'b00100101;
                        4'b0011:res=8'b00001101;
                        4'b0100:res=8'b10011001;
                        4'b0101:res=8'b01001001;
                        4'b0110:res=8'b01000001;
                        4'b0111:res=8'b00011111;
                        4'b1000:res=8'b00000001;
                        4'b1001:res=8'b00001001;
                        default:res=8'b00010000;
                    endcase
                end
                8'b11111011:begin
                    case (display[11:8]|Overcharge)
                        4'b0000:res=8'b00000011;
                        4'b0001:res=8'b10011111;
                        4'b0010:res=8'b00100101;
                        4'b0011:res=8'b00001101;
                        4'b0100:res=8'b10011001;
                        4'b0101:res=8'b01001001;
                        4'b0110:res=8'b01000001;
                        4'b0111:res=8'b00011111;
                        4'b1000:res=8'b00000001;
                        4'b1001:res=8'b00001001;
                        default:res=8'b00010000;
                    endcase
                end
                8'b11111101:begin
                    case (display[7:4]|Overcharge)
                        4'b0000:res=8'b00000010;
                        4'b0001:res=8'b10011110;
                        4'b0010:res=8'b00100100;
                        4'b0011:res=8'b00001100;
                        4'b0100:res=8'b10011000;
                        4'b0101:res=8'b01001000;
                        4'b0110:res=8'b01000000;
                        4'b0111:res=8'b00011110;
                        4'b1000:res=8'b00000000;
                        4'b1001:res=8'b00001000;
                        default:res=8'b00010000;
                    endcase
                end
                8'b11111110:begin
                    case (display[3:0]|Overcharge)
                        4'b0000:res=8'b00000011;
                        4'b0001:res=8'b10011111;
                        4'b0010:res=8'b00100101;
                        4'b0011:res=8'b00001101;
                        4'b0100:res=8'b10011001;
                        4'b0101:res=8'b01001001;
                        4'b0110:res=8'b01000001;
                        4'b0111:res=8'b00011111;
                        4'b1000:res=8'b00000001;
                        4'b1001:res=8'b00001001;
                        default:res=8'b00010000;
                    endcase
                end
            endcase
        end
    end
endmodule
