`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:56:09 04/23/2019
// Design Name:   data_send
// Module Name:   D:/EDA/eth/eth/tb_data.v
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

module tb_data;

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
		rst = 1;
		data_in = 8'b11101110;
		start = 0;
		#10
		rst = 0;
		#10
		rst = 1;
		#20
		start = 1;
		#40
		start = 1;

		// Wait 100 ns for global reset to finish
		#1000000;
        
		// Add stimulus here

	end
      always #20 clk=~clk;
endmodule

