`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:40:57 12/11/2018 
// Design Name: 
// Module Name:    Wpart 
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
module Wpart(
    input [31:0] IR_M2W,
    input [31:0] PC4_M2W,
    input [31:0] ALUout_M2W,
    input [31:0] DMout_M2W,
	 output [4:0] A3,
	 output [31:0] WD2A3,
	 output WriteEnabled,
	 output [4:0] WhoNew_M2W
    );
	 
	 `define rs 25:21
	 `define rt 20:16
	 `define rd 15:11
	 
	
	 wire [1:0]Mem2Reg;
	 wire [1:0]RegDst;
	 wire [2:0]BEXTop;
	 wire [31:0]BEXTout;
	 
	 Controller4W con4W(
    .instr(IR_M2W),
	 .Mem2Reg(Mem2Reg),
	 .RegDst(RegDst),
	 .WriteEnabled(WriteEnabled),
	 .ALUout(ALUout_M2W),
	 .DMout(DMout_M2W),
	 .BEXTop(BEXTop),
	 .WhoNew_M2W(WhoNew_M2W)
    );
	 
	 assign BEXTout = 
		(BEXTop == 3'b000) ? DMout_M2W :
		(BEXTop == 3'b001) ? (
			ALUout_M2W[1] ? {16'b0,DMout_M2W[31:16]} : 
			{16'b0,DMout_M2W[15:0]} 
		) :
		(BEXTop == 3'b010) ? (
			ALUout_M2W[1:0] == 2'b00 ? {24'b0,DMout_M2W[7:0]} :
			ALUout_M2W[1:0] == 2'b01 ? {24'b0,DMout_M2W[15:8]} :
			ALUout_M2W[1:0] == 2'b10 ? {24'b0,DMout_M2W[23:16]} :
			{24'b0,DMout_M2W[31:24]}
		) :
		(BEXTop == 3'b101) ? (
			ALUout_M2W[1] ? {{16{DMout_M2W[31]}},DMout_M2W[31:16]} :
			{{16{DMout_M2W[15]}},DMout_M2W[15:0]}
		) :
		(BEXTop == 3'b110) ? (
			ALUout_M2W[1:0] == 2'b00 ? {{24{DMout_M2W[7]}},DMout_M2W[7:0]} :
			ALUout_M2W[1:0] == 2'b01 ? {{24{DMout_M2W[15]}},DMout_M2W[15:8]} :
			ALUout_M2W[1:0] == 2'b10 ? {{24{DMout_M2W[23]}},DMout_M2W[23:16]} :
			{{24{DMout_M2W[31]}},DMout_M2W[31:24]}
		) :
		DMout_M2W;
	 
	 
	 assign A3 = 
		(RegDst==2'b00)? IR_M2W[`rt] :
		(RegDst==2'b01)? IR_M2W[`rd] :
		(RegDst==2'b10)? 31 :
		0;
		
	 assign WD2A3 = 
		(Mem2Reg == 2'b00) ? ALUout_M2W :
		(Mem2Reg ==2'b01) ? BEXTout :
		(Mem2Reg ==2'b10) ? PC4_M2W + 4 :
		ALUout_M2W;


endmodule
