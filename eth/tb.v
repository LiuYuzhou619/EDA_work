`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:49:54 03/11/2019
// Design Name:   uart_tx
// Module Name:   D:/EDA/eth/eth/tb.v
// Project Name:  eth
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: uart_tx
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb;

	// Inputs
	reg clk;
	reg [31:0] data_in;
	reg rst;
	reg empty;

	// Outputs
	wire [7:0] data_out;
	wire rd_en;
	wire pulse;
	wire out;

	// Instantiate the Unit Under Test (UUT)
	uart_tx uut (
		.clk(clk), 
		.data_in(data_in), 
		.rst(rst), 
		.data_out(data_out), 
		.empty(empty), 
		.rd_en(rd_en), 
		.pulse(pulse), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		data_in = 0;
		rst = 0;
		empty = 1;
		#100
		rst = 1;
		#100
		data_in = 32'h22334455;
		#100 
		empty = 0;

		// Wait 100 ns for global reset to finish
		#100000;
        
		// Add stimulus here

	end
      always #20 clk= ~clk;
endmodule

