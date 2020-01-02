`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:04:07 03/09/2019 
// Design Name: 
// Module Name:    uart 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module tx(clk,rst,data_in,start,out,send,idle,tx_finish,bps
    );
input clk;
input rst;
input [7:0] data_in;
input start;
input [16:0] bps;

output reg send;
output reg out;
output reg idle;
output reg tx_finish;

reg start_r;
reg start_t;
wire start_m;
always @(posedge clk or negedge rst)
	if(!rst)
		begin
			start_r <= 1'b0;
			start_t <= 1'b0;
		end
	else
		begin
			start_r <= start;
			start_t <= start_r;
		end

assign start_m = start_r&&(~start_t);

reg [3:0] state;
reg [13:0] cnt;
reg [7:0] data_in_reg;

always @(posedge clk or negedge rst)
	if(!rst)
		begin
			state <= 4'b0000;
			cnt <= 14'b0;
			data_in_reg <= 8'b0;
			tx_finish <= 1'b0;
			send <= 1'b0;
			idle <= 1'b0;
			out <= 1'b1;
		end
	else
		begin
			//cnt <= 8'b0;
			//state <= 4'b0;
			//out <= 1'b1;
			//send <= 1'b0;
			//tx_finish <= 1'b0;
			case(state)
			4'b0000:				//���뷢��״̬
				begin
					cnt <= 14'b0;
					out <= 1'b1;
					tx_finish <= 1'b0;
					if(start_m == 1)
						begin
							state <= 4'b0001;
							out <= 1'b1;
						end
					else
						begin
							//state <= 4'b0000;
							out <= 1'b1;
						end
				end
			4'b0001:					//������ʼ����λ
				begin
					idle <= 1'b1;
					data_in_reg <= data_in;
					if(cnt == bps)
						begin
							cnt <= 0;
							out <= 1'b0;
							state <= 4'b0010;
							send <= 1'b1;
						end
					else
						begin
							//state <= state;
							cnt <= cnt + 1'b1;
							//out <= out;
							send <= 1'b0;
						end
				end
			4'b0010:					//�������ݱ���0
				begin
					if(cnt == bps) //ÿ��200�����ڷ���һ��bit
						begin
							cnt <= 0;
							out <= data_in_reg[0];
							state <= 4'b0011;
							send <= 1'b1;
						end
					else
						begin
							//state <= state;
							cnt <= cnt + 1'b1;
							//out <= out;
							send <= 1'b1;
						end
				end
			4'b0011:					//�������ݱ���1
				begin
					if(cnt == bps)	//ÿ��200�����ڷ���һ��bit
						begin
							cnt <= 0;
							out <= data_in_reg[1];
							state <= 4'b0100;
						end
					else
						begin
							//state <= state;
							cnt <= cnt + 1'b1;
							out <= out;
						end
				end
			4'b0100:					//�������ݱ���2
				begin
					if(cnt == bps)	//ÿ��200�����ڷ���һ��bit
						begin
							cnt <= 0;
							out <= data_in_reg[2];
							state <= 4'b0101;
						end
					else
						begin
							//state <= state;
							cnt <= cnt + 1'b1;
							//out <= out;
						end
				end
			4'b0101:					//�������ݱ���3
				begin
					if(cnt == bps)	//ÿ��200�����ڷ���һ��bit
						begin
							cnt <= 0;
							out <= data_in_reg[3];
							state <= 4'b0110;
						end
					else
						begin
							//state <= state;
							cnt <= cnt + 1'b1;
							//out <= out;
						end
				end
			4'b0110:					//�������ݱ���4
				begin
					if(cnt == bps)	//ÿ��200�����ڷ���һ��bit
						begin
							cnt <= 0;
							out <= data_in_reg[4];
							state <= 4'b0111;
						end
					else
						begin
							//state <= state;
							cnt <= cnt + 1'b1;
							//out <= out;
						end
				end
			4'b0111:					//�������ݱ���5
				begin
					if(cnt == bps)	//ÿ��200�����ڷ���һ��bit
						begin
							cnt <= 0;
							out <= data_in_reg[5];
							state <= 4'b1000;
						end
					else
						begin
							//state <= state;
							cnt <= cnt + 1'b1;
							//out <= out;
						end
				end
			4'b1000:					//�������ݱ���6
				begin
					if(cnt == bps)	//ÿ��200�����ڷ���һ��bit
						begin
							cnt <= 0;
							out <= data_in_reg[6];
							state <= 4'b1001;
						end
					else
						begin
							//state <= state;
							cnt <= cnt + 1'b1;
							//out <= out;
						end
				end
			4'b1001:					//�������ݱ���7
				begin
					if(cnt == bps)	//ÿ��200�����ڷ���һ��bit
						begin
							cnt <= 0;
							out <= data_in_reg[7];
							state <= 4'b1011;
						end
					else
						begin
							//state <= state;
							cnt <= cnt + 1'b1;
							//out <= out;
						end
				end
			4'b1011:					//����ֹͣλ 1
				begin
					if(cnt == bps)	//ÿ��200�����ڷ���һ��bit
						begin
							cnt <= 0;
							out <= 1;
							state <= 4'b1100;
						end
					else
						begin
							//state <= state;
							cnt <= cnt + 1'b1;
							//out <= out;
						end
				end
			4'b1100:					//ֹͣ�����ӳ�����ߵ�ƽʱ��
				begin
					if(cnt == bps)	//ÿ��200�����ڷ���һ��bit
						begin
							cnt <= cnt + 1'b1;
							out <= 1'b1;
							//state <= state;
							send <= 1'b0;
							tx_finish <= 1'b1;
						end
					else if(cnt == bps+100)
						begin
							tx_finish <= 1'b0;
							cnt <= 8'b0;
							idle <= 1'b0;
							state <= 4'b0000;
						end
					else
						begin
							tx_finish <= 1'b0;
							//state <= state;
							cnt <= cnt + 1'b1;
							//out <= out;
						end
				end
			default:
				state <= 4'b0000;
			endcase
	  end
endmodule
