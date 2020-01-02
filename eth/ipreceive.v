`timescale 1ns / 1ps

module iprecieve(clk,datain,rxdv,rxer,state,
		         board_mac,pc_mac,
		         IP_Prtcl,
		         IP_layer,
		         pc_IP,board_IP,
		         UDP_layer,
		         mydata_num,
					total_len,
		         data_o,
		         valid_ip_P,
					tx_finish,
					rx_finish,
					data_o_valid             
		         );
    input clk;
    input [3:0] datain;
    input rxdv;
	 input rxer;
	 input tx_finish;
   
	 
	output reg [3:0] state;
	 
	 output reg data_o_valid;       
	 output reg rx_finish;    	 
	 
	 output reg [47:0] board_mac,pc_mac;
	 reg [15:0] myIP_Prtcl;
	 output reg valid_ip_P;
	 output reg [15:0]IP_Prtcl;
	 reg [159:0]myIP_layer;
	 output reg [159:0]IP_layer;
	 output reg [31:0] pc_IP,board_IP;
	 reg [63:0] myUDP_layer;
	 output reg [63:0] UDP_layer;
	 output reg [15:0] mydata_num;
	 output reg [15:0] total_len;
	 reg [31:0] mydata;
	 output reg [31:0] data_o;
	 
	 reg [9:0] rx_num;
	 reg [7:0] mybyte;
	 reg sig;
	 
	 reg [2:0] byte_counter;
	 reg [95:0] mymac;
	 
	 reg [4:0] state_counter;
	 
 
	 parameter idle=4'd0,rx_wait=4'd1,start=4'd2,frame=4'd3,rx_mac=4'd4,rx_IP_Protocol=4'd5
	 ,rx_IP_layer=4'd6,rx_UDP_layer=4'd7,rx_data=4'd8,rx_end=4'd9;
	 initial
	 begin
	 state<=rx_wait;
	 end

always @(posedge clk)
begin
	if(rxdv)
		begin
			if(rx_num<10'd1023)rx_num<=rx_num+1'b1;
			else rx_num<=rx_num;
		end
	else
		rx_num<=10'd0;
end


//4bit->byte
always @(posedge clk)
begin
	if(rxdv)
		begin
			mybyte<={datain,mybyte[7:4]};
			sig<=~sig;
		end
	else
	    begin
		     mybyte<=mybyte;
		     sig<=1'b0;
		end
end

//4bit->byte
reg [7:0] byte_data;
always @(posedge clk)
begin
	if(sig&&rxdv)
	  begin
		byte_data<={datain,mybyte[7:4]};
	  end
	else if(!rxdv)
	    byte_data<=8'd0;
end

//generate byte rxdv signal
reg byte_sig_t,byte_sig;
reg byte_rxdv_t,byte_rxdv;

always @(posedge clk)
begin
	byte_sig_t<=sig;
	byte_sig<=byte_sig_t;
	
	byte_rxdv_t<= rxdv;
	byte_rxdv<=byte_rxdv_t;
	
end


always@(posedge clk)
	begin
		case(state)
		  idle:
			begin
			     valid_ip_P<=1'b0;
			     byte_counter<=3'd0;
				  rx_finish<=1'b0;
			     state_counter<=5'd0;	
				  data_o_valid<=1'b0;             
				  if(tx_finish==1'b1)                             //����������ݽ���
				    	state<=rx_wait; 
			end	
        rx_wait:
			begin
			     valid_ip_P<=1'b0;
			     byte_counter<=3'd0;
				  rx_finish<=1'b0;
			     state_counter<=5'd0;	
				  data_o_valid<=1'b0;             
				  if(byte_rxdv&&!byte_sig)
				    begin
					  if(byte_data==8'h55)
					     state<=start; 
					 end
			end		  
		  start:                                               //����6��0x55
			 begin
				if(byte_rxdv&&!byte_sig)
				  begin
		          if(byte_data!=8'h55)begin state<=rx_wait;byte_counter<=3'd0;end
		          else 
						begin 
		               if(byte_counter<3'd5)
								byte_counter<=byte_counter+1'b1;
						   else
							  begin
								  byte_counter<=3'd0;
								  state<=frame;
							  end
						end
					end
				else if(!byte_rxdv) state<=rx_wait;
		     end
			frame:                       //����0xd5
				begin
					if(byte_rxdv&&!byte_sig)
						begin
							if(byte_data==8'hd5)
								state<=rx_mac;
							else
								state<=rx_wait;
						end
					 else if(!byte_rxdv) state<=rx_wait;
				end
			rx_mac:                     //����Ŀ��mac address��Դmac address
				begin
					if(byte_rxdv&&!byte_sig)
						begin
							if(state_counter<5'd11)
								begin
								  mymac<={mymac[87:0],byte_data};
								  state_counter<=state_counter+1'b1;
								end
							else
								begin
									board_mac<=mymac[87:40];
									pc_mac<={mymac[39:0],byte_data};
									state_counter<=5'd0;
									if((mymac[87:72]==16'h000a)&&(mymac[71:56]==16'h3501)&&(mymac[55:40]==16'hfec0))  
									//�ж�Ŀ��MAC Address�Ƿ�Ϊ��FPGA
									//if(mymac[39:0]==40'000a3501fec0)
									   state<=rx_IP_Protocol;
									else
									   state<=rx_wait;
								end
						end
					else if(!byte_rxdv) state<=rx_wait;
				end
		   rx_IP_Protocol:                   //����2���ֽڵ�IP����
				begin
					if(byte_rxdv&&!byte_sig)
						begin
							if(state_counter<5'd1)
								begin
								   myIP_Prtcl<={myIP_Prtcl[7:0],byte_data};
								   state_counter<=state_counter+1'b1;
								end
							else
								begin
									IP_Prtcl<={myIP_Prtcl[7:0],byte_data};
									valid_ip_P<=1'b1;
                           state_counter<=5'd0;
									state<=rx_IP_layer;
								end
						end
					else if(!byte_rxdv) state<=rx_wait;
				end		              
		    rx_IP_layer:                //����20�ֽڵ�udp�����ͷ,ip address
		        begin
				   valid_ip_P<=1'b0;
					if(byte_rxdv&&!byte_sig)
						begin
							if(state_counter<5'd19)
								begin
								myIP_layer<={myIP_layer[151:0],byte_data};
								state_counter<=state_counter+1'b1;
								end
							else
								begin
									IP_layer<={myIP_layer[151:0],byte_data};
									
									state_counter<=5'd0;
									state<=rx_UDP_layer;
								end
						end
					else if(!byte_rxdv) state<=rx_wait;
				end           
			rx_UDP_layer:                       //����8�ֽ�udp���ݰ�ͷ,�˿ںż�����	  
				 begin
				    total_len<=IP_layer[143:128];
				    pc_IP<=IP_layer[63:32];
				    board_IP<=IP_layer[31:0];
					if(byte_rxdv&&!byte_sig)
						begin
							if(state_counter<5'd7)
								begin
								myUDP_layer<={myUDP_layer[55:0],byte_data};
								state_counter<=state_counter+1'b1;
								end
							else
								begin
									UDP_layer<={myUDP_layer[55:0],byte_data};									
									state_counter<=5'd0;
									mydata_num<=myUDP_layer[23:8];
									state<=rx_data;
								end
						end
					else if(!byte_rxdv) state<=rx_wait;
				end    
			 rx_data:                                    //����udp����       
				 begin
				    
					if(byte_rxdv&&!byte_sig)
						begin
						    if(state_counter<5'd3)
								begin
								  mydata<={mydata[23:0],byte_data};
								  state_counter<=state_counter+1'b1;
					           data_o_valid<=1'b0;  
								end
							 else
							    begin
						        data_o<={mydata[23:0],byte_data};
						        state_counter<=5'd0;
								  data_o_valid<=1'b1;                        //����4byes����,дfifo����            
						        end
                      end
					else if(!byte_rxdv) 
					    begin 
						   state<=rx_end;                   
						 end
				end  
			 rx_end:                                           //����4byte�Ĳ�0       
				 begin
				 	rx_finish<=1'b1;                                //���յ�frame����
					state<=idle;  
				   if(state_counter==5'd3)
					  begin
					    	data_o_valid<=1'b1; 
							data_o<={mydata[23:0],8'd0};
					  end
					else if(state_counter==5'd2)
					  begin
					    	data_o_valid<=1'b1; 
							data_o<={mydata[16:0],16'd0};
					  end
					else if(state_counter==5'd1)
					  begin
					    	data_o_valid<=1'b1; 
							data_o<={mydata[8:0],24'd0};
					  end
				   else
					    	data_o_valid<=1'b0; 					  
				end 
			 default:state<=idle;    
		endcase
		end
endmodule
