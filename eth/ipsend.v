`timescale 1ns / 1ps
module ipsend(clk,datain,fifo_empty,clr,crc,mydata_num,total_len,crcen,dataout,read_udp_fifo,txen,txer,crcre,crc_valid,crcnext,tx_finish,rx_finish);
     input clk;
     input [31:0] datain;
     input [31:28]crcnext;
	  input [31:0] crc;
	  input clr;
	  input rx_finish;
	  input fifo_empty;
	  input [15:0] mydata_num;
	  input [15:0] total_len;	  
     output [3:0] dataout;
	 output read_udp_fifo;
	 output txen;
	 output txer;
	 output crcen;
	 output crcre;
	 output reg crc_valid;
	 output reg tx_finish;
	 reg read_udp_fifo,txen,txer;
	 reg [3:0] dataout;
	 reg [31:0] mema [6:0];                       //数据段为1K
	 reg [31:0] datain_reg;
	 reg [2:0] stat;
	 reg [8:0] count2,n;
	 reg [15:0] check_buffer1,check_buffer2;
	 reg [16:0] check_buffer3;
	 reg [31:0] check_buffer;
	 reg [4:0] i;
	 reg [4:0] j,p,q;
	 reg [3:0] mema2 [43:0];
	 reg [5:0] k;
	 reg [7:0] r;
	 reg crcen;
	 reg crcre;
	 parameter idle=3'b000,start=3'b001,make=3'b010,send=3'b011,senddata=3'b100,sendmac=3'b101,sendmac2=3'b110;
	 initial
	 begin
	 stat<=idle;
	 mema[1][31:16]<=0;
    mema[2][15:0]<=0;
	 mema2[0]<=4'h5;
	 mema2[1]<=4'h5;
	 mema2[2]<=4'h5;
	 mema2[3]<=4'h5;
	 mema2[4]<=4'h5;
	 mema2[5]<=4'h5;
	 mema2[6]<=4'h5;
	 mema2[7]<=4'h5;
	 mema2[8]<=4'h5;
	 mema2[9]<=4'h5;
	 mema2[10]<=4'h5;
	 mema2[11]<=4'h5;
	 mema2[12]<=4'h5;
	 mema2[13]<=4'h5;
	 mema2[14]<=4'h5;
	 mema2[15]<=4'hd;
	  //mema2[16]<=4'h4;             //目的MAC地址 14-fe-b5-ab-0c-7b
    //mema2[17]<=4'h1;
    //mema2[18]<=4'hE;
    //mema2[19]<=4'hF;
    //mema2[20]<=4'h5;
    //mema2[21]<=4'hB;
    //mema2[22]<=4'hB;
    //mema2[23]<=4'hA;
    //mema2[24]<=4'hC;
    //mema2[25]<=4'h0;
    //mema2[26]<=4'hB;
    //mema2[27]<=4'h7;

	//此段为调试主机（例如用户的PC）的MAC地址，在调试时候，需要根据自己的电脑MAC地址修改本段内容
	 mema2[16]<=4'h4;	//目的MAC地址 54-E1-AD-24-55-4A
    mema2[17]<=4'h5;
    mema2[18]<=4'h1;
    mema2[19]<=4'hE;
    mema2[20]<=4'hD;
    mema2[21]<=4'hA;
    mema2[22]<=4'h4;
    mema2[23]<=4'h2;
    mema2[24]<=4'h5;
    mema2[25]<=4'h5;
    mema2[26]<=4'hA;
    mema2[27]<=4'h4;
    	 
	 mema2[28]<=4'h0;               //源MAC地址000a3501fec0
	 mema2[29]<=4'h0;
	 mema2[30]<=4'ha;
	 mema2[31]<=4'h0;
	 mema2[32]<=4'h5;
	 mema2[33]<=4'h3;
	 mema2[34]<=4'h1;
	 mema2[35]<=4'h0;
	 mema2[36]<=4'he;
	 mema2[37]<=4'hf;
	 mema2[38]<=4'h0;
	 mema2[39]<=4'hc;	

//	   mema2[16]<=4'hC;             //目的MAC地址 14-fe-b5-ab-0c-7b
//    mema2[17]<=4'h5;
//    mema2[18]<=4'hF;
//    mema2[19]<=4'hF;
//    mema2[20]<=4'h5;
//    mema2[21]<=4'h3;
//    mema2[22]<=4'h4;
//    mema2[23]<=4'h0;
//    mema2[24]<=4'h6;
//    mema2[25]<=4'hC;
//    mema2[26]<=4'hA;
//    mema2[27]<=4'h8;	 
	 
//	 mema2[28]<=4'h0;               //源MAC地址000a3501fec0
//	 mema2[29]<=4'h0;
//	 mema2[30]<=4'ha;
//	 mema2[31]<=4'h0;
//	 mema2[32]<=4'h5;
//	 mema2[33]<=4'h3;
//	 mema2[34]<=4'h1;
//	 mema2[35]<=4'h0;
//	 mema2[36]<=4'he;
//	 mema2[37]<=4'hf;
//	 mema2[38]<=4'h0;
//	 mema2[39]<=4'hc;
	 
	 mema2[40]<=4'h8;               //数据段长度033c,类型0800（ip）
	 mema2[41]<=4'h0;
	 mema2[42]<=4'h0;
	 mema2[43]<=4'h0;
	 r<=0;
	 end
	 

	 
	 always@(posedge clk)
	 begin
	   if(!clr)
		  begin
		    stat<=idle;
		  end
		else
		begin		
		case(stat)
	  idle:begin
			    crc_valid<=0;
			    count2<=0;
			    check_buffer<=0;
			    i<=0;
				 j<=0;
				 p<=0;
				 q<=0;
				 txer<=0;
				 
				/// txen<=0;
				 k<=0;
				 tx_finish<=1'b0;
				 crcen<=0;
				 read_udp_fifo<=0;
				 crcre<=1;
		       if(rx_finish)
			       stat <=  start;    //约延时1微秒；
				 else
				   stat<=idle;
			    end
		start:begin
				mema[0]<={16'h4500,total_len};         //total length is 44 bytes
				mema[1][31:16]<=mema[1][31:16]+1;
				mema[1][15:0]<=16'h4000;
				mema[2]<=32'h80110000;              //mema[2][15:0] ip  jiaoyanhe
				mema[3]<=32'hc0a80002;              //192.168.0.2源地址
				mema[4]<=32'hc0a80003;              //192.168.0.3目的地址广播地址
				mema[5]<=32'h80008000;              //2个字节的源端口号和2个字节的目的端口号
				mema[6]<={mydata_num,16'h0000};              //2个字节的数据长度(24byte数据)和2个字节的校验和（无）
				i<=0;
				stat<=make;
              end	
         make:begin                               //生成head的checksum
			    if(i==0)
				   begin
					  check_buffer<=mema[0][15:0]+mema[0][31:16]+mema[1][15:0]+mema[1][31:16]+mema[2][15:0]+mema[2][31:16]+mema[3][15:0]+mema[3][31:16]+mema[4][15:0]+mema[4][31:16];
                 i<=i+1;
				   end
             else if(i==1)
               begin
					   check_buffer[15:0]<=check_buffer[31:16]+check_buffer[15:0];
					   i<=i+1;
				   end
			    else	
					begin
				       mema[2][15:0]<=~check_buffer[15:0];
				 	    i<=0;
					    stat<=sendmac;
					end
				end
			sendmac:                      //发送Premble,Mac address
			   begin
				 txen<=1;
			    if(k==43)
				   begin
                dataout[3:0]<=mema2[k][3:0];
				    stat<=send;
				   end
				 else if(k<=15)
				   begin
				    crcre<=1;
				    dataout[3:0]<=mema2[k][3:0];
				    k<=k+1;
				   end
				 else
				   begin
				    crcen<=1;
				    crcre<=0;
				    dataout[3:0]<=mema2[k][3:0];
				    k<=k+1;
				   end
				end
			send:begin                                 //发送UDP包头,mema[0]~mema[6]
			     if(j==6)
                   if(i==0)                          
					      begin
					        dataout[3:0]<=mema[j][27:24];
					        i<=i+1;
					      end
					    else if(i==1)
					      begin
					        dataout[3:0]<=mema[j][31:28];
					        i<=i+1;
					      end
					    else if(i==2)
					      begin
					        dataout[3:0]<=mema[j][19:16];
  				           i<=i+1;
							end
					    else if(i==3)
					      begin
					        dataout[3:0]<=mema[j][23:20];
					        i<=i+1;
					      end
						 else if(i==4)
					      begin
					        dataout[3:0]<=mema[j][11:8];
					        i<=i+1;
							  read_udp_fifo<=1;	                     //read fifo,准备发送数据
					      end
						 else if(i==5)
					      begin
					        dataout[3:0]<=mema[j][15:12];
					        i<=i+1;
							  read_udp_fifo<=0;	
					      end
						 else if(i==6)
					      begin
					        dataout[3:0]<=mema[j][3:0];
					        i<=i+1;					
					      end
						 else if(i==7)
					      begin
					        dataout[3:0]<=mema[j][7:4];
							  stat<=senddata;
							  datain_reg<=datain;               //把FIFO读出的数据保存到datain_reg中
					      end
					    else
							txer<=1;
					else
					    if(i==0)
					      begin
					        dataout[3:0]<=mema[j][27:24];
					        i<=i+1;
					      end
					    else	if(i==1)
					      begin
					        dataout[3:0]<=mema[j][31:28];
					        i<=i+1;
					      end
					    else if(i==2)
					      begin
					        dataout[3:0]<=mema[j][19:16];
					        i<=i+1;
							end
					    else if(i==3)
					      begin
					        dataout[3:0]<=mema[j][23:20];
					        i<=i+1;
					      end
						 else if(i==4)
					      begin
					        dataout[3:0]<=mema[j][11:8];
					        i<=i+1;
					      end
						 else if(i==5)
					      begin
					        dataout[3:0]<=mema[j][15:12];
					        i<=i+1;

					      end
						 else if(i==6)
					      begin
					        dataout[3:0]<=mema[j][3:0];
					        i<=i+1;
					      end
						 else if(i==7)
					      begin
					        dataout[3:0]<=mema[j][7:4];
					        i<=0;
							  j<=j+1;
					      end
					    else
							txer<=1;
					  end
			 senddata:begin                                //发送数据
                   if(p==0)
					      begin
					         dataout[3:0]<=datain_reg[27:24];
					         p<=p+1;
					      end
					    else if(p==1)
					      begin
					         dataout[3:0]<=datain_reg[31:28];
					         p<=p+1;
					      end
					    else if(p==2)
                     begin
					         dataout[3:0]<=datain_reg[19:16];
					         p<=p+1;
					   	end
					    else if(p==3)
	                  begin
                        dataout[3:0]<=datain_reg[23:20];
	                     p<=p+1;
	                  end
						 else if(p==4)
	                  begin
                        dataout[3:0]<=datain_reg[11:8];
	                     p<=p+1;
							   if(~fifo_empty)			                  
							      read_udp_fifo<=1;	                     //read fifo,准备发送数据								
					      end
						 else if(p==5)
                     begin
								dataout[3:0]<=datain_reg[15:12];
	                     p<=p+1;
							   read_udp_fifo<=0;	
	   			      end
						 else if(p==6)
                     begin
	                     dataout[3:0]<=datain_reg[3:0];
	                     p<=p+1;                    
	  			         end
  					    else if(p==7)
                     begin
	                    dataout[3:0]<=datain_reg[7:4];
	 	                 p<=0;
							  if(fifo_empty)			
   						     stat<=sendmac2;                   
							  else
							  	  datain_reg<=datain;               //把FIFO读出的数据保存到datain_reg中   
						   end
					    else
						    txer<=1;
				  end
			sendmac2:                           //发送CRC32
					begin
					crcen<=0;
					crc_valid<=1;
					if(q==0)
					   begin
					     dataout[3:0] <= {~crcnext[28], ~crcnext[29], ~crcnext[30], ~crcnext[31]};
					     q<=q+1;
					   end
					else if(q==1)
					   begin
					     dataout[3:0]<={~crc[24], ~crc[25], ~crc[26], ~crc[27]};
					     q<=q+1;
					   end
					else if(q==2)
					   begin
					     dataout[3:0]<={~crc[20], ~crc[21], ~crc[22], ~crc[23]};
					     q<=q+1;
					   end
					else if(q==3)
					   begin
					     dataout[3:0]<={~crc[16], ~crc[17], ~crc[18], ~crc[19]};
					     q<=q+1;
					   end
					else if(q==4)
					   begin
					     dataout[3:0]<={~crc[12], ~crc[13], ~crc[14], ~crc[15]};
					     q<=q+1;
						end
					else if(q==5)
					   begin
					     dataout[3:0]<={~crc[8], ~crc[9], ~crc[10], ~crc[11]};
					     q<=q+1;
						end
					else if(q==6)
					   begin
					     dataout[3:0]<={~crc[4], ~crc[5], ~crc[6], ~crc[7]};
					     q<=q+1;
						end
					else if(q==7)
					   begin
				        dataout[3:0]<={~crc[0], ~crc[1], ~crc[2], ~crc[3]};
					     q<=q+1;
						end
					else
					   begin
							txen<=0;
						   tx_finish<=1'b1;
							stat<=idle;
							crc_valid<=0;
					   end
					end		
			default:stat<=idle;		
       endcase	
      end			  
	end
endmodule
