`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:45:08 12/01/2018 
// Design Name: 
// Module Name:    Mpart 
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
  module Mpart(
    input Clk,
    input Reset,
    input [31:0] IR_E2M,
    input [31:0] PC4_E2M,
    input [31:0] ALUout_E2M,
    input [31:0] RD2_E2M,
    input [31:0] RD1_E2M,
	 //hazard
	 input [4:0] WhoNew_M2W,
	 input [31:0] WD2A3,

    output reg [31:0] IR_M2W,
    output reg [31:0] PC4_M2W,
    output reg [31:0] ALUout_M2W,
    output reg [31:0] DMout_M2W,
	 //hazard
	 output [4:0] WhoNew_E2M
    );
	 
	 
	 `define rs 25:21
	 `define rt 20:16
	 `define rd 15:11
	 
	 wire [31:0] MFRD1_M;
	 wire [31:0] MFRD2_M;
	 
	 wire [31:0] DMout;
	 
	 wire [3:0] MemWrite;
	 wire [1:0] Mem2Reg;
	 wire [1:0] RegDst;
	 
	 Controller4M con4M(
    .instr(IR_E2M),
    .MemWrite(MemWrite),
	 .lastbit(ALUout_E2M[1:0]),
	 .WhoNew_E2M(WhoNew_E2M)
    );
	 
	 DM dm(
    .Clk(Clk),
    .Reset(Reset),
    .MemWrite(MemWrite),
    .Memaddr(ALUout_E2M),
    .In(MFRD2_M),
	 .PC4(PC4_E2M),
    .Out(DMout)
    );
	 
	 
	//hazard
	assign MFRD2_M   =(IR_E2M[`rt] == WhoNew_M2W && IR_E2M[`rt] != 0) ? WD2A3 : 
		RD2_E2M;
	 
	assign MFRD1_M = (IR_E2M[`rs] == WhoNew_M2W && IR_E2M[`rs] != 0) ? WD2A3 : 
		RD1_E2M;
	 
	 initial begin
		IR_M2W <= 0;
		PC4_M2W <= 32'h3004;
		ALUout_M2W <= 0;
		DMout_M2W <= 0;
	 end
	 
	always @(posedge Clk) begin
		if(Reset != 1) begin
			IR_M2W <= IR_E2M;
			PC4_M2W <= PC4_E2M;
			ALUout_M2W <= ALUout_E2M;
			DMout_M2W <= DMout;
		end
	end

endmodule
