`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Edwin Coronado
//
// Create Date:   22:39:29 11/21/2016
// Design Name:   Synchronous_FIFO_Memory
// Module Name:  Synchronous_FIFO_tb.v
// Project Name:  Synchronous_FIFO_Memory
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Synchronous_FIFO_Memory
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Synchronous_FIFO_tb;

	// Inputs
	reg clk;
	reg n_rst;
	reg write_rq;
	reg read_rq;
	reg [4:0] data_in;

	// Outputs
	wire empty;
	wire almost_empty;
	wire almost_full;
	wire full;
	wire [4:0] data_out;

	// Instantiate the Unit Under Test (UUT)
	Synchronous_FIFO_Memory uut (
		.clk(clk), 
		.n_rst(n_rst), 
		.write_rq(write_rq), 
		.read_rq(read_rq), 
		.data_in(data_in), 
		.empty(empty), 
		.almost_empty(almost_empty), 
		.almost_full(almost_full),
		.full(full),
		.data_out(data_out)
		
	);

	initial clk = 0;
	always #5 clk = ~clk;

	initial begin
		n_rst = 1'b0; read_rq = 1'b0; write_rq = 1'b1;
		@(posedge clk)
		@(posedge clk)data_in = 0;n_rst = 1'b1;
		@(posedge clk)data_in = 1;
		@(posedge clk)data_in = 2;
		@(posedge clk)write_rq = 1'b0;read_rq = 1'b1;
		@(posedge clk)data_in = 3;read_rq = 1'b1; write_rq = 1'b1;
		@(posedge clk)write_rq = 1'b0;read_rq = 1'b1;
		@(posedge clk)
		@(posedge clk)data_in =25;read_rq = 1'b0; write_rq = 1'b1;
		@(posedge clk)write_rq = 1'b0;read_rq = 1'b1;
		@(posedge clk)
		@(posedge clk) read_rq = 1'b0; write_rq = 1'b0;
		@(posedge clk) $finish;
	end

endmodule

