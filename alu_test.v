`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:25:10 12/18/2018
// Design Name:   ALU
// Module Name:   D:/ISEp/pipeline_plus/alu_test.v
// Project Name:  pipeline_plus
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ALU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module alu_test;

	// Inputs
	reg [31:0] A;
	reg [31:0] B;
	reg [3:0] ALUop;

	// Outputs
	wire [31:0] C;

	// Instantiate the Unit Under Test (UUT)
	ALU uut (
		.A(A), 
		.B(B), 
		.ALUop(ALUop), 
		.C(C)
	);

	initial begin
		// Initialize Inputs
		A = -6;
		B = -3;
		ALUop = 4'b0111;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
		always #10 A = A + 1;
endmodule

