`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:25:30 11/27/2018 
// Design Name: 
// Module Name:    IFU 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module IFU(
    input [31:0] MUX4PC_out,
    input Clk,
    input Reset,
	 input stock,
	 output [31:0] PC4,
    output [31:0] Instruction
    );
	 
	  reg [31:0] PC;
	  reg [31:0] Memory [0:4095];
	  
	  
	  assign Instruction =  Memory[(PC - 32'h3000) / 4];
	  assign PC4 = PC + 4;
	  
	  
	  
	 initial begin
		$readmemh("code.txt", Memory);
		PC = 32'h3000;
	 end

	 
	 always @(posedge Clk) begin
		if (Reset != 1)begin
			if (stock != 1)begin
				PC <= MUX4PC_out;
			end
		end
		else begin
			PC <= 32'h3000;
		end
	 end
	 
endmodule
