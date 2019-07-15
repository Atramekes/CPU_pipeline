`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:24:34 11/27/2018 
// Design Name: 
// Module Name:    DM 
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
module DM(
    input Clk,
    input Reset,
    input [3:0] MemWrite,
    input [31:0] Memaddr,
    input [31:0] In,
	 input [31:0] PC4,
    output [31:0] Out
    );
	 
	 integer i;
	 
	 reg [31:0] Memory [0:4095];
	 reg [31:0] DIN;

	 initial begin
		for (i=0; i<1024; i=i+1) begin
			Memory[i] = 0;
		end
	 end
	 

	 assign Out = Memory[Memaddr[11:2]];
	 
	 always @(posedge Clk) begin
		if(MemWrite != 4'b0000) begin
			DIN =
				MemWrite[3:0] == 4'b1111 ? In :
				MemWrite[3:0] == 4'b0011 ? {Memory[Memaddr[11:2]][31:16],In[15:0]} :
				MemWrite[3:0] == 4'b1100 ? {In[15:0],Memory[Memaddr[11:2]][15:0]} :
				MemWrite[3:0] == 4'b0001 ? {Memory[Memaddr[11:2]][31:8],In[7:0]} :
				MemWrite[3:0] == 4'b0010 ? {Memory[Memaddr[11:2]][31:16],In[7:0],Memory[Memaddr[11:2]][7:0]} :
				MemWrite[3:0] == 4'b0100 ? {Memory[Memaddr[11:2]][31:24],In[7:0],Memory[Memaddr[11:2]][15:0]} :
				MemWrite[3:0] == 4'b1000 ? {In[7:0],Memory[Memaddr[11:2]][23:0]} :
				Memory[Memaddr[11:2]];
			Memory[Memaddr[11:2]] = DIN;
		end
		else if(Reset == 1) begin
			for (i=0; i<1024; i=i+1) begin
				Memory[i] = 0;
			end
		end
		if(MemWrite != 4'b0000 && Reset != 1) begin
			$display("%d@%h: *%h <= %h",$time,PC4 - 4, {Memaddr[31:2],2'b0},DIN);
			//$display("%d@%h: *%h <= %h",$time,PC4 - 4, {Memaddr[31:2],2'b0},DIN);
		end
	 end

endmodule
