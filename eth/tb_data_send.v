`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:55:26 04/23/2019
// Design Name:   data_send
// Module Name:   D:/EDA/eth/eth/tb_data_send.v
// Project Name:  eth
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: data_send
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_data_send;

	// Inputs
	reg clk;
	reg rst;
	reg [7:0] data_in;
	reg start;

	// Outputs
	wire txd;

	// Instantiate the Unit Under Test (UUT)
	data_send uut (
		.clk(clk), 
		.rst(rst), 
		.data_in(data_in), 
		.txd(txd), 
		.start(start)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		data_in = 0;
		start = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

