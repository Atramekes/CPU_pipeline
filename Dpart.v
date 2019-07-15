`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:51:23 12/01/2018 
// Design Name: 
// Module Name:    Dpart 
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
module Dpart(
    input [31:0] IR_F2D,
    input [31:0] PC4_F2D,
	 input [31:0] PC4_M2W,
	 input [31:0] IR_M2W,
	 input Clk,
	 input Reset,
	 input [4:0] A3,
	 input [31:0] WD2A3,
	 input WriteEnabled,
	 //hazard
	 input [4:0] WhoNew_D2E,
	 input [4:0] WhoNew_E2M,
	 input [31:0] ALUout_E2M,
	 input [4:0] WhoNew_M2W,
	 
	 output [1:0] selPC,
    output reg [31:0] IR_D2E,
    output reg [31:0] PC4_D2E,
    output reg [31:0] RD1_D2E,
    output reg [31:0] RD2_D2E,
    output reg [31:0] IMM_D2E,
	 output [31:0] NPC,
	 output nullize,
	 //stock
	 output [1:0] TNew_F2D,
	 output [4:0] WhoNew_F2D,
	 output [1:0]specialstock_D
    );
	 
	 wire [31:0] RD1;
	 wire [31:0] RD2;
	 
	 wire [3:0] EXTop;
	 wire [3:0] CMPop;
	 wire [31:0] CMPout;
	 wire [31:0] imme_32;
	 
	 wire likely;

	 `define rs 25:21
	 `define rt 20:16
	 `define rd 15:11
	 `define immediate 15:0
	 `define func 5:0
	 `define op 31:26
	 `define shamt 10:6
	 
	 wire [31:0] MFRD1_D;
	 wire [31:0] MFRD2_D;

	 
	 Controller4D con4D(
    .instr(IR_F2D),
	 //nomal
	 .CMPop(CMPop),
	 .EXTop(EXTop),
	 .selPC(selPC),
	 .likely(likely),
	 //stock
	 .TNew_F2D(TNew_F2D),
	 .WhoNew_F2D(WhoNew_F2D),
	 .specialstock_D(specialstock_D)
	 //hazard
    );

    GRF rf(
    .Clk(Clk),
    .Reset(Reset),
    .WriteEnabled(WriteEnabled),
    .A1(IR_F2D[`rs]),
    .A2(IR_F2D[`rt]),
    .A3(A3),
    .WriteData(WD2A3),
	 .PC4(PC4_M2W),
    .RD1(RD1),
    .RD2(RD2)
    );
	 
	 //extendor
	 assign imme_32 = 
		(EXTop == 4'b0000) ? {{16{1'b0}},IR_F2D[`immediate]} : //zero extend
		(EXTop == 4'b0001) ? {{16{IR_F2D[15]}},IR_F2D[`immediate]} : //signal extend
		(EXTop == 4'b0010) ? {IR_F2D[`immediate],{16{1'b0}}} : // load to high
		(EXTop == 4'b0011) ? PC4_F2D + 4 : // PC+8
		{{16{1'b0}},IR_F2D[`immediate]}; 
		
  	//comparer
	 assign CMPout = 
		(CMPop == 4'b0000) ? MFRD1_D - MFRD2_D : 
		(CMPop == 4'b0001) ? ( $signed(MFRD1_D) < 0 ? 0 : 1) :
		(CMPop == 4'b0010) ? ( $signed(MFRD1_D) > 0 ? 0 : 1) :
		(CMPop == 4'b0011) ? ( $signed(MFRD1_D) <= 0 ? 0 : 1) :
		(CMPop == 4'b0100) ? ( $signed(MFRD1_D) >= 0 ? 0 : 1) :
		(CMPop == 4'b0101) ? ( MFRD1_D - MFRD2_D != 0 ? 0 : 1) :
		1;
	
	//npc
	 assign NPC =  (selPC == 2'b01) ? ((CMPout == 0) ? {{14{IR_F2D[15]}},IR_F2D[`immediate],2'b0} + PC4_F2D : PC4_F2D + 4 ) : //B×å
		(selPC == 2'b10) ? {PC4_F2D[31:28],IR_F2D[25:0],2'b0} : //JÓëJAL
		MFRD1_D; //JR
		
	//nullize
	assign nullize = (likely & CMPout!=0 ) ? 1 : 0;
	
	//hazard
	assign MFRD1_D = 
		(IR_F2D[`rs] == WhoNew_D2E && IR_F2D[`rs] != 0) ? IMM_D2E :	
		(IR_F2D[`rs] == WhoNew_E2M && IR_F2D[`rs] != 0) ? ALUout_E2M : 
		//(IR_F2D[`rs] == WhoNew_M2W && IR_F2D[`rs] != 0) ? WD2A3 :
		RD1;
		
	assign MFRD2_D = 
		(IR_F2D[`rt] == WhoNew_D2E && IR_F2D[`rt] != 0) ? IMM_D2E :	
		(IR_F2D[`rt] == WhoNew_E2M && IR_F2D[`rt] != 0) ? ALUout_E2M : 
		//(IR_F2D[`rt] == WhoNew_M2W && IR_F2D[`rt] != 0) ? WD2A3 :
		RD2;
	 
	initial begin
		IR_D2E <= 0;
		PC4_D2E <= 32'h3004;
		RD1_D2E <= 0;
		RD2_D2E <= 0;
		IMM_D2E <= 0;
	end
	
	always @(posedge Clk) begin
		if(Reset != 1) begin
			IR_D2E <= IR_F2D;
			IMM_D2E <= imme_32;
			PC4_D2E <= PC4_F2D;
			RD1_D2E <= MFRD1_D;
			RD2_D2E <= MFRD2_D;

		end
	end

endmodule
