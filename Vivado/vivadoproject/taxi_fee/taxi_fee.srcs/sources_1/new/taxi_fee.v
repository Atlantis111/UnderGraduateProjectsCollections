`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/08 19:57:01
// Design Name: 
// Module Name: taxi_fee
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


module taxi(start,pause,car_wait,speedup,d_m,CLK,seg,sel,EN);

	input start;               //开始
	input pause;               //暂停
	input CLK;                 //时钟信号
	input car_wait;            //遇红灯等待
	input wire[1:0] speedup;   //控制挡位
	input d_m;                 //控制显示车费或行驶里程
	output wire[7:0]seg;      //选择数码管
	output wire[7:0]sel;      //选择位数
	output wire EN;
	
	reg CLK_1K = 0;            //赋初值
	//reg CLK_1S = 0;
	reg[17:0] counter_1k;
	reg[24:0] counter_1s;
	reg[13:0] display;
	reg[3:0] speed;
	reg[13:0] fee;
	reg[13:0] distance;
	reg[3:0] last_start;
	//reg timeSpent = 0;
	//reg last_distance = 0;
	
	reg[3:0] waitTime = 0;
	reg over;
	assign EN =1;
	
	nixie tube(            //创建数码管模块的对象tube
		.N(display),
		.seg(seg),
		.sel(sel),
		.clk_1K(CLK_1K),
		.over(over)
	);
	
	
	//initial begin
	//	CLK_1K=0;
	//	CLK_1S=0;
	//	counter_1k=0;
	//	counter_1s=0;
	//	number_display=0;
	//end
	
	always@(posedge CLK) begin
		if(counter_1k==24999) begin           //偶分频，两次翻转为一个周期
			counter_1k=0;
			CLK_1K <=~CLK_1K;
		end else
			counter_1k = counter_1k +1'b1;
		
		if(counter_1s==19999999) begin
			counter_1s =0;
			//每秒一次////////////////////////////////////////
			//CLK_1S <=~CLK_1S;
			distance = distance + speed;//计算当前路程
		
			if(speed >0) begin
				waitTime = 0;
				if(distance>30) begin
					fee = fee+ speed *(fee > 200 ? 18 : 12 )/10;
				end
			end
			else begin
				waitTime = waitTime +1'b1;
				if(waitTime == 10) begin
					fee = fee + 5;
					waitTime = 0;
				end
			end 
			
			/////////////////////////////////////////////////
		end else
				counter_1s = counter_1s +1'b1;
		
		
		
		if(start == 0) begin
			fee = 0;
			waitTime = 0;
			distance = 0;
			last_start = 0;
		end
		
		if(last_start ==0 && start ==1 ) begin //起步瞬间
			fee = 60;
			last_start = 1;
		end
		
		if(car_wait==1) begin
				speed=0;
		end
		else begin
			case (speedup)
				0: speed=3'd1;
				1: speed=3'd2;
				2: speed=3'd4;
				3: speed=3'd6;
				default: speed = 4'd8;
			endcase
		
		end
		//display <= distance;
		if(pause==0) begin
			if(d_m==0 ) begin
				display <= fee;
				over <= fee>9999;
			end
			else begin
				display <= distance;
				over <= distance>9999;
			end
		end
	end
	
endmodule




module nixie(N,seg,sel,clk_1K,over);
	input [13:0]N;                     //表示要显示的数
	input clk_1K;
	input over;
	output reg[7:0]seg;                //选择八个数码管
	output reg[7:0]sel;                //选择位数
	
	//reg clk_1K;
	//reg [64:0]divider_cnt;//25000-1
	
	//always@(posedge CLK)
	//	if(divider_cnt == 24999)
	//		divider_cnt <= 15'd0;
	//	else
	//		divider_cnt <= divider_cnt + 1'b1;
	
	//always@(posedge CLK) begin
	//	if(divider_cnt == 24999)
	//		clk_1K <= ~clk_1K;
	//end
	
	reg [13:0]tmp;         //记录数
	reg [3:0]num;          //记录数的个位
	
	initial begin
		tmp=N;
		num=0;
	end
	
	always@(posedge clk_1K) begin
	    sel=sel>>1;
        if(sel!=8'b11111110) begin
            sel=sel+8'b10000000;
        end
        else begin
            sel=sel;
            tmp=N;
        end
		
		if(over) begin        //全部显示A.
			seg = 8'b00010000;
		end
		else begin
			num=tmp%10;
			tmp=tmp/10;
			case(num)
				0: seg = 8'b00000011;
				1: seg = 8'b10011111;
				2: seg = 8'b00100101;
				3: seg = 8'b00001101;
				4: seg = 8'b10011001;
				5: seg = 8'b01001001;
				6: seg = 8'b01000001;
				7: seg = 8'b00011111;
				8: seg = 8'b00000001;
				9: seg = 8'b00001001;
				default: seg = 8'b11111111;
				
			endcase
			
			if(sel>8'b11110000)
				seg=8'b11111111;
				
			if(sel==8'b11111101)
				seg=seg & 8'b11111110;
			
		end
	end
	
endmodule
