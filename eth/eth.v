module eth (
					input rst,                           
					input  clk,
					output E_RESET , 					           
				//signal connect to PHY//
		   	   input  E_RXC, 					
					input  E_RXDV,						
					input  [3:0] E_RXD,           
					input  E_RXER, 
               
					input  E_TXC,  
					output E_TXEN, 		
					output [3:0] E_TXD,
					output gclk,
					output E_TXER,
					
					output tx,
					output txd
					);
              
//assign gclk = E_RXC;
//assign E_RXER=0;	
					
////assign E_TXC = E_RXC ;
//assign E_TXEN = E_RXDV ;
//assign E_TXD = E_RXD ;
//
//assign E_RESET = 1 ;

//always @(posedge FPGA_GCLK1 ) begin 
   //E_TXC <= ~E_TXC ;
//end
//
//

reg data_o_valid_reg1;              //added for receive test/
reg data_o_valid_reg2;              //added for receive test/
reg read_udp_fifo_reg1;
reg read_udp_fifo_reg2;
reg fifo_wr_en;                     //added for receive test/
reg fifo_rd_en;

wire [31:0] fifo_rd_data;
wire [31:0] fifo_wr_data;
wire rx_finish;	 
	 
udp udp_inst(
	.rxdv(E_RXDV),
	.rxer(E_RXER),
	.clk3(E_TXC),
	.e_rxc(E_RXC),
	.datain(E_RXD),
	.txen(E_TXEN),
	.txer(E_TXER),
	.phyreset(E_RESET),
	.Data(E_TXD),
	.valid_ip_p(),
	.data_o_valid(data_o_valid),
   .fifo_wr_data(fifo_wr_data),	
	.read_udp_fifo(read_udp_fifo),                  
	.fifo_empty(fifo_empty),                        
	.fifo_r_data(fifo_rd_data),                     
	.crc_valid(),
	.rx_finish(rx_finish)
	);
	
////////////added for receive test///////////////////
////fifo fifo_rw (
////  .clk(E_RXC),               	// input clk
////  .rst(rst),                 	// input rst
////  .din(fifo_wr_data),       	// input [31 : 0] din
////  .wr_en(fifo_wr_en),      	// input wr_en
////  .rd_en(fifo_rd_en),       	// input rd_en
////  .dout(fifo_rd_data),      	// output [31 : 0] dout
////  .full(full),             	// output full
////  .empty(fifo_empty)       	// output empty
//////  .prog_full()    	         // output prog_full  
////  
////);

//////////added for receive test///////////////////
//脉宽转化,data_o_valid--->


always @(negedge E_RXC)
begin
	if(!rst)
	  begin
	    data_o_valid_reg1<=1'b0;
	    data_o_valid_reg2<=1'b0;
	    fifo_wr_en<=1'b0;
	  end
   else 
	  begin
	  	 data_o_valid_reg1<=data_o_valid;
	    data_o_valid_reg2<=data_o_valid_reg1;   
	    if(data_o_valid_reg1 && !data_o_valid_reg2)  //如果检测到data_o_valid的上升沿,产生fifo写请求
		   fifo_wr_en<=1'b1;
		 else
		   fifo_wr_en<=1'b0;
	  end
end	
	
always @(negedge E_RXC)
begin
	if(!rst)
	  begin
	    read_udp_fifo_reg1<=1'b0;
	    read_udp_fifo_reg2<=1'b0;
	    fifo_rd_en<=1'b0;
	  end
   else 
	  begin
	  	 read_udp_fifo_reg1<=read_udp_fifo;
	    read_udp_fifo_reg2<=read_udp_fifo_reg1;   
	    if(read_udp_fifo_reg1 && !read_udp_fifo_reg2)  //read_udp_fifo下降沿,产生fifo读请求
		   fifo_rd_en<=1'b1;
		 else
		   fifo_rd_en<=1'b0;
	  end
end

wire [31:0] data;
wire em;
wire rden_reg;
reg rden;

//uart module-----------------------------------------
uart_tx  u1(
					.clk(E_RXC),
					.data_in(data),
					.rst(rst),
					//.data_out(),
					.empty(em),
					.rd_en(rden_reg),
					.pulse(),
					.out(tx),
					.rx_finish(rx_finish),
					.txd(txd)
    );

//----------------------------------------------------
//=====================================================
fifo2 your_instance_name (
  .clk(E_RXC), // input clk    
  .din(fifo_wr_data), // input [31 : 0] din
  .wr_en(fifo_wr_en), // input wr_en
  .rd_en(fifo_rd_en), // input rd_en                fifo_rd_en
  .dout(fifo_rd_data), // output [31 : 0] dout        fifo_rd_data
  .full(full), // output full                     full
  .empty(fifo_empty) // output empty                  fifo_empty
);

fifo1 fifo_rw (
  .clk(E_RXC),               	// input clk
  //.rst(rst),                 	// input rst
  .din(fifo_wr_data),       	// input [31 : 0] din
  .wr_en(fifo_wr_en),      	// input wr_en
  .rd_en(rden),       	// input rd_en             rden
  .dout(data),      	// output [31 : 0] dout         data
  .full(),             	// output full
  .empty(em)       	// output empty
//  .prog_full()    	         // output prog_full     em
);

reg read_udp_fifo_reg3;
reg read_udp_fifo_reg4;

//=====================================================

always @(negedge E_RXC)
begin
	if(!rst)
	  begin
	    read_udp_fifo_reg3<=1'b0;
	    read_udp_fifo_reg4<=1'b0;
	    rden<=1'b0;
	  end
   else 
	  begin
	  	 read_udp_fifo_reg3<=rden_reg;
	    read_udp_fifo_reg4<=read_udp_fifo_reg3;   
	    if(read_udp_fifo_reg3 && !read_udp_fifo_reg4)           //read_udp_fifo下降沿,产生fifo读请求
		   rden<=1'b1;
		 else
		   rden<=1'b0;
	  end
end

endmodule

