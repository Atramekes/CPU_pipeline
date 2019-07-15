`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:32:36 12/01/2018 
// Design Name: 
// Module Name:    Epart 
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
module Epart(
    input Clk,
    input Reset,
    input [31:0] IR_D2E,
    input [31:0] PC4_D2E,
    input [31:0] RD1_D2E,
    input [31:0] RD2_D2E,
    input [31:0] IMM_D2E,
	 //hazard
	 input [4:0] WhoNew_E2M,
    input [4:0] WhoNew_M2W,
	 input [31:0] WD2A3,
	 
    output reg [31:0] IR_E2M,
    output reg [31:0] PC4_E2M,
    output reg [31:0] ALUout_E2M,
    output reg [31:0] RD2_E2M,
	 output reg [31:0] RD1_E2M,
	 //stock
	 output [1:0] TNew_D2E,
	 output [4:0] WhoNew_D2E,
	 output [1:0]specialstock_E,
	 output MDbusy
    );
	 
	 wire [31:0] A;
	 wire [31:0] B;
	 wire [31:0] ALUresult;
	 wire [31:0] ALUout;
	 wire ALUsrc;
	 wire [3:0] ALUop;
	 wire ALUa;
	 
	 wire MDstart;
	 wire [2:0] MDop;
	 wire [31:0] MDout;
	 wire ALUorMD;
	 
	 `define rs 25:21
	 `define rt 20:16
	 `define rd 15:11
	 `define immediate 15:0
	 `define func 5:0
	 `define op 31:26
	 `define shamt 10:6
	 
	 wire [31:0] MFRD1_E;
	 wire [31:0] MFRD2_E;
	 
	 
	 Controller4E con4E(
    .instr(IR_D2E),
    .ALUsrc(ALUsrc),
	 .ALUop(ALUop),
	 .ALUa(ALUa),
	 .MDop(MDop),
	 .MDstart(MDstart),
	 .ALUorMD(ALUorMD),
	 //stock
	 .TNew_D2E(TNew_D2E),
	 .WhoNew_D2E(WhoNew_D2E),
	 .specialstock_E(specialstock_E)
    );
	 
	 assign B = (ALUsrc == 0) ? MFRD2_E : IMM_D2E;
	 assign A = (ALUa == 0) ? MFRD1_E : IR_D2E[`shamt];
	 
	 ALU alu(
    .A(A),
    .B(B),
    .ALUop(ALUop),
    .C(ALUresult)
    );
	 
	 MultDiv MD(
	 //input
	 .clk(Clk),
	 .A(MFRD1_E),
	 .B(MFRD2_E),
	 .op(MDop),
	 .start(MDstart),
	 //output
	 .busy(MDbusy),
	 .out(MDout)
	 );
	 
	 assign ALUout = (ALUorMD == 0) ? ALUresult : MDout;
	 
	//hazard
	assign MFRD1_E = (IR_D2E[`rs] == WhoNew_E2M && IR_D2E[`rs] != 0) ? ALUout_E2M : 
		(IR_D2E[`rs] == WhoNew_M2W && IR_D2E[`rs] != 0) ? WD2A3 : 
		RD1_D2E;
		
	assign MFRD2_E = (IR_D2E[`rt] == WhoNew_E2M && IR_D2E[`rt] != 0) ? ALUout_E2M : 
		(IR_D2E[`rt] == WhoNew_M2W && IR_D2E[`rt] != 0) ? WD2A3 : 
		RD2_D2E;
	 

	 initial begin
		IR_E2M <= 0;
		PC4_E2M <= 32'h3004;
		ALUout_E2M <= 0;
		RD2_E2M <= 0;
		RD1_E2M <= 0;
	 end
	 
	always @(posedge Clk) begin
		if(Reset != 1) begin
			IR_E2M <= IR_D2E;
			PC4_E2M <= PC4_D2E;
			ALUout_E2M <= ALUout;
			RD2_E2M <= MFRD2_E;
			RD1_E2M <= MFRD1_E;
		end
	end

endmodule
