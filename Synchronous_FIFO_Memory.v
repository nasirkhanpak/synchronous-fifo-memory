`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Edwin Coronado
// 
// Create Date:    22:23:58 11/21/2016 
// Design Name: 
// Module Name:    Synchronous_FIFO_Memory 
// Project Name:	 Synchronous First-In First-Out Memory
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: Synchronous read/write with asynchronous active-low falling edge reset
//
//////////////////////////////////////////////////////////////////////////////////
module Synchronous_FIFO_Memory #(parameter WL=5) (input clk, n_rst, write_rq, read_rq, 
	input [WL-1:0] data_in, 
	output empty, almost_empty, full, almost_full,
	output reg [WL-1:0] data_out
    );

	parameter DEPTH = 2**WL - 1;
	reg [WL-1:0] write_addr, read_addr;
	reg [WL-1:0] MEM_ARRAY[DEPTH:0];
	wire write_enable, read_enable;
	reg [WL-1:0] counter;
	
	//Assigning the different states of the memory block
	assign full = (counter == DEPTH) ? 1 : 0;
	assign almost_full = (counter == (DEPTH-1)) ? 1 : 0;
	assign empty = (counter == 0) ? 1 : 0;
	assign almost_empty = (counter == 1) ? 1 : 0;
	
	//Assigning the memory block read/write enables
	assign write_enable = (~full && write_rq)  ? 1 : 0;
	assign read_enable = (~empty && read_rq) ? 1 : 0;
	
	//Operation to increase the write memory address
	always @(posedge clk or negedge n_rst) begin
		if (~n_rst)
			write_addr <= 0;
		else if (write_rq && write_enable)
			write_addr <= write_addr + 1;
	end 
	
	//Operation to write the current memory address to the MEM_ARRAY (memory block)	
	always @(posedge clk or negedge n_rst) begin
		if (~n_rst)
			data_out <= 0;
		else if (write_enable && write_rq)
			MEM_ARRAY[write_addr] <= data_in;
	end
	
	//Operation to increase the read memory address
	always @(posedge clk or negedge n_rst) begin
		if (~n_rst)
			read_addr <= 0;
		else if (read_rq && read_enable)
			read_addr <= read_addr + 1;
	end
	
	//Operation to read the current read address from MEM_ARRAY (memory block) and send it to output port "data_out"
	always @(posedge clk or negedge n_rst) begin
		if (~n_rst)
			data_out <= 0;
		else if (read_enable && read_rq)
			data_out <= MEM_ARRAY[read_addr];
	end
	
	//Asynchronous operation to increase the counter that will trigger the flags according to the size of the memory block
	always @(posedge clk or negedge n_rst) begin
		if (~n_rst)
			counter <= 0;
		else if ((write_enable && write_rq) &&
					(!(read_enable && read_rq)) &&
					(counter != DEPTH))
			counter <= counter + 1;
		else if ((read_enable && read_rq) &&
					(!(write_enable && write_rq)) &&
					(counter != 0))
			counter <= counter - 1;
	end
endmodule