`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:53:06 03/11/2019 
// Design Name: 
// Module Name:    uart_tx 
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
module uart_tx(clk,data_in,rst,empty,rd_en,pulse,out,rx_finish,txd
    );
	 input clk,rst,empty;
	 input rx_finish;
	 input [31:0] data_in;
	 output reg rd_en;
	 reg [7:0] data_out;
	 output reg pulse;
	 output out;
	 output txd;
	 
	 reg [3:0] state;
	 reg [16:0] cnt;
	 reg [2:0] cnt1;
	 reg [31:0] data_reg;
	 
	 always @(posedge clk or negedge rst)
		if(!rst)
			begin
				data_out <= 0;
				cnt <= 0;
				cnt1 <= 0;
				state <= 0;
			end
		else
			begin
				case(state)
				4'd0:
					begin
						rd_en <= 0;
						pulse = 0;
						cnt1 <= 0;
						cnt <= 0;
						//data_reg <= 0;
						if(rx_finish)
							state <= 4'd10;
						else
							state <= 4'd0;
					end
				4'd10:
					begin
						if(empty != 1)
							state <= 4'd1;
						else
							state <= 4'd0;
					end
				4'd1:
					begin
						rd_en <= 1'b1;
						state <= 4'd2;
					end
				4'd2:
					begin
						rd_en <= 1'b0;
						state <= 4'd3;
					end
				4'd3:
					begin
						if(cnt1 == 3'd2)
							begin
								state <= 4'd4;
								cnt1 <= 0;
							end
						else
							begin
								state <= 4'd3;
								cnt1 <= cnt1 + 1'b1;
							end
					end
				4'd4:								//duqushuju
					begin
						data_reg <= data_in;
						state <= 4'd5;
					end
				////////////////////////////////////////////////////////////
				////////////////////////////////////////////////////////////////
				4'd5:                              //发送数据段1
					begin
						if(cnt == 3010)
							begin
								cnt <= 0;
								state <= 4'd6;
							end
						else if(cnt <= 2)
							begin
								pulse = 1'b1;            ///fasong mai chong
								cnt <= cnt + 1;
								data_out <= data_reg[31:24];
							end
						else
							begin
								pulse = 1'b0;
								cnt <= cnt + 1;
							end
					end
				4'd6:                              //发送数据段2
					begin
						if(cnt == 3010)
							begin
								cnt <= 0;
								state <= 4'd12;
							end
						else if(cnt <= 2)
							begin
								pulse = 1'b1;            ///fasong mai chong
								cnt <= cnt + 1;
								data_out <= data_reg[24:16];
							end
						else
							begin
								pulse = 1'b0;
								cnt <= cnt + 1;
							end
					end
				4'd12:
					begin
						if(~empty)
							begin
								rd_en <= 1;
							end
						state <= 4'd13;
					end
				4'd13:
					begin
						rd_en <= 0;
						state <= 4'd7;
					end
				4'd7:                              //发送数据段3
					begin
						if(cnt == 3010)
							begin
								cnt <= 0;
								state <= 4'd8;
							end
						else if(cnt <= 2)
							begin
								pulse = 1'b1;            ///fasong mai chong
								cnt <= cnt + 1;
								data_out <= data_reg[15:8];
							end
						else
							begin
								pulse = 1'b0;
								cnt <= cnt + 1;
							end
					end
				4'd8:                              //发送数据段4
					begin
						if(cnt == 3010)
							begin
								cnt <= 0;
								state <= 4'd9;
							end
						else if(cnt <= 2)
							begin
								pulse = 1'b1;            ///fasong mai chong
								cnt <= cnt + 1;
								data_out <= data_reg[7:0];
							end
						else
							begin
								pulse = 1'b0;
								cnt <= cnt + 1;
							end
					end
				4'd9:
					begin
						if(empty == 1)
							state <= 4'd0;
						else
							begin
								state <= 4'd5;
								data_reg <= data_in;
							end
					end
				default:
						state <= 4'd0;
				endcase
			end
			
tx   tx_u1(
				.clk(clk),
				.rst(rst),
				.data_in(data_out),
				.start(pulse),
				.out(out),
				.send(),
				.idle(),
				.tx_finish(),
				.bps(216)
    );
data_send   u2(
						.clk(clk),
						.rst(rst),
						.data_in(data_out),
						.txd(txd),
						.start(pulse)
				);

endmodule
