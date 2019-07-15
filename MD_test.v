`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   00:20:43 12/19/2018
// Design Name:   MultDiv
// Module Name:   D:/ISEp/pipeline_plus/MD_test.v
// Project Name:  pipeline_plus
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: MultDiv
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module MD_test;

	// Inputs
	reg [31:0] A;
	reg [31:0] B;
	reg clk;
	reg [2:0] op;
	reg start;

	// Outputs
	wire [31:0] out;
	wire busy;

	// Instantiate the Unit Under Test (UUT)
	MultDiv uut (
		.A(A), 
		.B(B), 
		.clk(clk), 
		.op(op), 
		.out(out), 
		.busy(busy), 
		.start(start)
	);

	initial begin
		// Initialize Inputs
		A = -2;
		B = 5;
		clk = 0;
		op = 3'b000;
		start = 0;
		#10
		start = 1;
		#20
		start = 0;

		
	end
	
	always #10 clk=~clk;
      
endmodule

