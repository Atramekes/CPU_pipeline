`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:08:52 11/26/2018 
// Design Name: 
// Module Name:    GRF 
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
module GRF(
    input Clk,
    input Reset,
    input WriteEnabled,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,
    input [31:0] WriteData,
	 input [31:0] PC4,
    output [31:0] RD1,
    output [31:0] RD2
    );
	 
	 reg [31:0] Memory [0:31];
	 integer i;
	 
	 assign RD1 = (A1==A3 && A1!= 0 && WriteEnabled==1) ? WriteData : Memory[A1];
	 assign RD2 = (A2==A3 && A2!= 0 && WriteEnabled==1) ? WriteData : Memory[A2];
	 
	 initial begin
		for (i=0; i<32; i=i+1) begin
			Memory[i] = 0;
		end
	 end

	 always @(posedge Clk) begin
	   if(Reset == 1) begin
			for (i=0; i<32; i=i+1) begin
				Memory[i] = 0;
			end
		end
		if(Reset != 1) begin
			if (WriteEnabled && A3 != 0)
				Memory[A3] = WriteData;
		end
		if(WriteEnabled == 1 && Reset != 1 && A3 != 0) begin
			$display("%d@%h: $%d <= %h",$time, PC4 - 4, A3,WriteData);
		end
		//$display("%d@%h: $%d <= %h",$time, PC4 - 4, A3,WriteData);
	 end

endmodule
