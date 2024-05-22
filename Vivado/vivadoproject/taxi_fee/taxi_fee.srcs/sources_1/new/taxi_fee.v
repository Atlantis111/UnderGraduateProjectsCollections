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

	input start;               //��ʼ
	input pause;               //��ͣ
	input CLK;                 //ʱ���ź�
	input car_wait;            //����Ƶȴ�
	input wire[1:0] speedup;   //���Ƶ�λ
	input d_m;                 //������ʾ���ѻ���ʻ���
	output wire[7:0]seg;      //ѡ�������
	output wire[7:0]sel;      //ѡ��λ��
	output wire EN;
	
	reg CLK_1K = 0;            //����ֵ
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
	
	nixie tube(            //���������ģ��Ķ���tube
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
		if(counter_1k==24999) begin           //ż��Ƶ�����η�תΪһ������
			counter_1k=0;
			CLK_1K <=~CLK_1K;
		end else
			counter_1k = counter_1k +1'b1;
		
		if(counter_1s==19999999) begin
			counter_1s =0;
			//ÿ��һ��////////////////////////////////////////
			//CLK_1S <=~CLK_1S;
			distance = distance + speed;//���㵱ǰ·��
		
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
		
		if(last_start ==0 && start ==1 ) begin //��˲��
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
	input [13:0]N;                     //��ʾҪ��ʾ����
	input clk_1K;
	input over;
	output reg[7:0]seg;                //ѡ��˸������
	output reg[7:0]sel;                //ѡ��λ��
	
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
	
	reg [13:0]tmp;         //��¼��
	reg [3:0]num;          //��¼���ĸ�λ
	
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
		
		if(over) begin        //ȫ����ʾA.
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
