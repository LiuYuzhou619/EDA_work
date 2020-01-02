`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:05:58 04/23/2019 
// Design Name: 
// Module Name:    data_send 
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
module data_send(clk,rst,data_in,txd,start
    );
	 
	 input clk,rst;
	 input [7:0] data_in;
	 input start;
	 
	 output reg txd;
	 
	 reg [7:0] state;
	 reg [10:0] cnt;
	 
	 always @(posedge clk or negedge rst)
		begin
			if(!rst)
				begin
					state <= 0;
					cnt <= 0;
				end
			else
				case(state)
					7'd0:
						begin
							if(start == 1)
								begin
									state <= 7'd1;
								end
							else
								begin
									state <= 7'd0;
								end
						end
					7'd1:													////1
						begin
							if(cnt == 49)
								begin
									txd <= 0;
									cnt <=0;
									state <= 7'd2;
								end
							else
								begin
									txd <= 1;
									cnt <= cnt + 1;
								end
						end
					7'd2:													////0
						begin
							if(cnt == 49)
								begin
									txd <= 1;
									cnt <=0;
									state <= 7'd3;
								end
							else
								begin
									txd <= 0;
									cnt <= cnt + 1;
								end
						end
					7'd3:													////1
						begin
							if(cnt == 49)
								begin
									txd <= 0;
									cnt <=0;
									state <= 7'd4;
								end
							else
								begin
									txd <= 1;
									cnt <= cnt + 1;
								end
						end
					7'd4:													////0
						begin
							if(cnt == 49)
								begin
									txd <= 1;
									cnt <=0;
									state <= 7'd5;
								end
							else
								begin
									txd <= 0;
									cnt <= cnt + 1;
								end
						end
					7'd5:													////1
						begin
							if(cnt == 49)
								begin
									txd <= 0;
									cnt <=0;
									state <= 7'd6;
								end
							else
								begin
									txd <= 1;
									cnt <= cnt + 1;
								end
						end
					7'd6:													////0
						begin
							if(cnt == 49)
								begin
									txd <= 1;
									cnt <=0;
									state <= 7'd7;
								end
							else
								begin
									txd <= 0;
									cnt <= cnt + 1;
								end
						end
					7'd7:													////1
						begin
							if(cnt == 49)
								begin
									txd <= 0;
									cnt <=0;
									state <= 7'd8;
								end
							else
								begin
									txd <= 1;
									cnt <= cnt + 1;
								end
						end
					7'd8:													////0
						begin
							if(cnt == 49)
								begin
									txd <= 0;
									cnt <=0;
									state <= 7'd9;
								end
							else
								begin
									txd <= 0;
									cnt <= cnt + 1;
								end
						end
					7'd9:													////00
						begin
							if(cnt == 99)
								begin
									txd <= 1;
									cnt <=0;
									state <= 7'd10;
								end
							else
								begin
									txd <= 0;
									cnt <= cnt + 1;
								end
						end
					7'd10:													////1
						begin
							if(cnt == 49)
								begin
									txd <= 0;
									cnt <=0;
									state <= 7'd11;
								end
							else
								begin
									txd <= 1;
									cnt <= cnt + 1;
								end
						end
					7'd11:													////0
						begin
							if(cnt == 49)
								begin
									txd <= 1;
									cnt <=0;
									state <= 7'd12;
								end
							else
								begin
									txd <= 0;
									cnt <= cnt + 1;
								end
						end
					7'd12:													///1
						begin
							if(cnt == 49)
								begin
									txd <= 0;
									cnt <=0;
									state <= 7'd13;
								end
							else
								begin
									txd <= 1;
									cnt <= cnt + 1;
								end
						end
					7'd13:													////0
						begin
							if(cnt == 49)
								begin
									txd <= 1;
									cnt <=0;
									state <= 7'd14;
								end
							else
								begin
									txd <= 0;
									cnt <= cnt + 1;
								end
						end
					7'd14:													////1
						begin
							if(cnt == 49)
								begin
									txd <= 0;
									cnt <=0;
									state <= 7'd15;
								end
							else
								begin
									txd <= 1;
									cnt <= cnt + 1;
								end
						end
					7'd15:													////0
						begin
							if(cnt == 49)
								begin
									txd <= 1;
									cnt <=0;
									state <= 7'd16;
								end
							else
								begin
									txd <= 0;
									cnt <= cnt + 1;
								end
						end
					7'd16:													////1
						begin
							if(cnt == 49)
								begin
									txd <= 0;
									cnt <=0;
									state <= 7'd17;
								end
							else
								begin
									txd <= 1;
									cnt <= cnt + 1;
								end
						end
					7'd17:													////0
						begin
							if(cnt == 49)
								begin
									txd <= 0;
									cnt <=0;
									state <= 7'd18;
								end
							else
								begin
									txd <= 0;
									cnt <= cnt + 1;
								end
						end
				   7'd18:													////00
						begin
							if(cnt == 99)
								begin
									txd <= 1;
									cnt <=0;
									state <= 7'd19;
								end
							else
								begin
									txd <= 0;
									cnt <= cnt + 1;
								end
						end
					7'd19:													////1
						begin
							if(cnt == 49)
								begin
									txd <= 0;
									cnt <=0;
									state <= 7'd20;
								end
							else
								begin
									txd <= 1;
									cnt <= cnt + 1;
								end
						end
					7'd20:													////0
						begin
							if(cnt == 49)
								begin
									txd <= 1;
									cnt <=0;
									state <= 7'd21;
								end
							else
								begin
									txd <= 0;
									cnt <= cnt + 1;
								end
						end
					7'd21:													////1
						begin
							if(cnt == 49)
								begin
									txd <= 0;
									cnt <=0;
									state <= 7'd22;
								end
							else
								begin
									txd <= 1;
									cnt <= cnt + 1;
								end
						end
					7'd22:													////0
						begin
							if(cnt == 49)
								begin
									txd <= 1;
									cnt <=0;
									state <= 7'd23;
								end
							else
								begin
									txd <= 0;
									cnt <= cnt + 1;
								end
						end
					7'd23:													////1
						begin
							if(cnt == 49)
								begin
									txd <= 0;
									cnt <=0;
									state <= 7'd24;
								end
							else
								begin
									txd <= 1;
									cnt <= cnt + 1;
								end
						end
					7'd24:													////0
						begin
							if(cnt == 49)
								begin
									txd <= 1;
									cnt <=0;
									state <= 7'd25;
								end
							else
								begin
									txd <= 0;
									cnt <= cnt + 1;
								end
						end
					7'd25:													///1
						begin
							if(cnt == 49)
								begin
									txd <= 0;
									cnt <=0;
									state <= 7'd26;
								end
							else
								begin
									txd <= 1;
									cnt <= cnt + 1;
								end
						end
					7'd26:													///0
						begin
							if(cnt == 49)
								begin
									txd <= 0;
									cnt <=0;
									state <= 7'd27;
								end
							else
								begin
									txd <= 0;
									cnt <= cnt + 1;
								end
						end
						
					7'd27:													////00
						begin
							if(cnt == 99)
								begin
									txd <= 0;
									cnt <=0;
									state <= 7'd28;
								end
							else
								begin
									txd <= 0;
									cnt <= cnt + 1;
								end
						end
					7'd28:													////0000
						begin
							if(cnt == 199)
								begin
									txd <= 1;
									cnt <=0;
									state <= 7'd29;
								end
							else
								begin
									txd <= 0;
									cnt <= cnt + 1;
								end
						end
					7'd29:													////1
						begin
							if(cnt == 49)
								begin
									txd <= 0;
									cnt <=0;
									state <= 7'd30;
								end
							else
								begin
									txd <= 1;
									cnt <= cnt + 1;
								end
						end
					7'd30:													////000
						begin
							if(cnt == 149)
								begin
									txd <= 0;
									cnt <=0;
									state <= 7'd31;
								end
							else
								begin
									txd <= 0;
									cnt <= cnt + 1;
								end
						end
					7'd31:													////00
						begin
							if(cnt == 99)
								begin
									txd <= data_in[7];
									cnt <=0;
									state <= 7'd32;
								end
							else
								begin
									txd <= 0;
									cnt <= cnt + 1;
								end
						end
					7'd32:													////bit 1    ////000
						begin
							if(cnt == 49)
								begin
									txd <= data_in[6];
									cnt <=0;
									state <= 7'd33;
								end
							else
								begin
									txd <= data_in[7];
									cnt <= cnt + 1;
								end
						end
					7'd33:													////bit 1    ////000
						begin
							if(cnt == 49)
								begin
									txd <= data_in[5];
									cnt <=0;
									state <= 7'd34;
								end
							else
								begin
									txd <= data_in[6];
									cnt <= cnt + 1;
								end
						end
					7'd34:													////bit 1    ////000
						begin
							if(cnt == 49)
								begin
									txd <= data_in[4];
									cnt <=0;
									state <= 7'd35;
								end
							else
								begin
									txd <= data_in[5];
									cnt <= cnt + 1;
								end
						end
					7'd35:													////bit 1    ////000
						begin
							if(cnt == 49)
								begin
									txd <= data_in[3];
									cnt <=0;
									state <= 7'd36;
								end
							else
								begin
									txd <= data_in[4];
									cnt <= cnt + 1;
								end
						end
					7'd36:													////bit 1    ////000
						begin
							if(cnt == 49)
								begin
									txd <= data_in[2];
									cnt <=0;
									state <= 7'd37;
								end
							else
								begin
									txd <= data_in[3];
									cnt <= cnt + 1;
								end
						end
					7'd37:													////bit 1    ////000
						begin
							if(cnt == 49)
								begin
									txd <= data_in[1];
									cnt <=0;
									state <= 7'd38;
								end
							else
								begin
									txd <= data_in[2];
									cnt <= cnt + 1;
								end
						end
					7'd38:													////bit 1    ////000
						begin
							if(cnt == 49)
								begin
									txd <= data_in[0];
									cnt <=0;
									state <= 7'd39;
								end
							else
								begin
									txd <= data_in[1];
									cnt <= cnt + 1;
								end
						end
					7'd39:													////bit 1    ////000
						begin
							if(cnt == 49)
								begin
									txd <= 0;
									cnt <=0;
									state <= 6'd40;
								end
							else
								begin
									txd <= data_in[0];
									cnt <= cnt + 1;
								end
						end
					7'd40:													////bit 1    ////000
						begin
							if(cnt == 499)
								begin
									txd <= 0;
									cnt <=0;
									state <= 7'd41;
								end
							else
								begin
									txd <= 0;
									cnt <= cnt + 1;
								end
						end
					7'd41:													////bit 1    ////000
						begin
							if(cnt == 99)
								begin
									txd <= 0;
									cnt <=0;
									state <= 7'd0;
								end
							else
								begin
									txd <= 0;
									cnt <= cnt + 1;
								end
						end
					default:state <= 0;
				endcase
		end
endmodule
