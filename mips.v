`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:36:30 11/26/2018 
// Design Name:    mono_cpu
// Module Name:    mips
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: µ¥ÖÜÆÚCPU¶¥²ã
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module mips(
    input clk,
    input reset,
	 output [31:0] NPC
    );

	 `define rs 25:21
	 `define rt 20:16
	 `define rd 15:11
	 `define immediate 15:0
	
	 wire [4:0] A3;
	 wire [31:0] WD2A3;
	 //wire [31:0] NPC;
	 
	 wire [1:0] selPC;
	 wire [31:0] IR_F2D;
	 wire [31:0] PC4_F2D;
	 wire [31:0] IR_D2E;
    wire [31:0] PC4_D2E;
    wire [31:0] RD1_D2E;
    wire [31:0] RD2_D2E;
    wire [31:0] IMM_D2E;
	 wire [31:0] IR_E2M;
    wire [31:0] PC4_E2M;
    wire [31:0] ALUout_E2M;
    wire [31:0] RD2_E2M;
	 wire [31:0] RD1_E2M;
	 wire [31:0] IR_M2W;
    wire [31:0] PC4_M2W;
    wire [31:0] ALUout_M2W;
    wire [31:0] DMout_M2W;
	 
	 wire [1:0] TNew_F2D;
	 wire [1:0] TNew_D2E;
	 wire [4:0] WhoNew_F2D;
	 wire [4:0] WhoNew_D2E;
	 wire [4:0] WhoNew_E2M;
	 wire [4:0] WhoNew_M2W;
	 wire MDbusy;
	 wire [1:0]specialstock_D;
	 wire [1:0]specialstock_E;
	 
	 Fpart fpart(
	 //input
    .NPC(NPC),
    .selPC(selPC),
	 .Clk(clk),
	 .Reset(reset),
			//stock
			.TNew_F2D(TNew_F2D),
			.WhoNew_F2D(WhoNew_F2D),
			.TNew_D2E(TNew_D2E),
			.WhoNew_D2E(WhoNew_D2E),
			.MDbusy(MDbusy),
			.specialstock_D(specialstock_D),
			.specialstock_E(specialstock_E),
			.nullize(nullize),
	 //output
    .IR_F2D(IR_F2D),
    .PC4_F2D(PC4_F2D)
    );
	 
	 Dpart dpart(
	 //input
	 .Clk(clk),
	 .Reset(reset),
    .IR_F2D(IR_F2D),
	 .IR_M2W(IR_M2W),
    .PC4_F2D(PC4_F2D),
	 .PC4_M2W(PC4_M2W),
	 .A3(A3),
	 .WD2A3(WD2A3),
	 .WriteEnabled(WriteEnabled),
				//stock
			   .TNew_F2D(TNew_F2D),
				.WhoNew_F2D(WhoNew_F2D),
							//harzard
							.WhoNew_E2M(WhoNew_E2M),
							.ALUout_E2M(ALUout_E2M),
							.WhoNew_M2W(WhoNew_M2W),
							.WhoNew_D2E(WhoNew_D2E),
							.specialstock_D(specialstock_D),
	 
	 //output
	 .NPC(NPC),
	 .selPC(selPC),
	 .nullize(nullize),
	 .IR_D2E(IR_D2E),
    .PC4_D2E(PC4_D2E),
    .RD1_D2E(RD1_D2E),
    .RD2_D2E(RD2_D2E),
    .IMM_D2E(IMM_D2E)
    );
	 
	 Epart epart(
	 //input
	 .Clk(clk),
	 .Reset(reset),
	 .IR_D2E(IR_D2E),
    .PC4_D2E(PC4_D2E),
    .RD1_D2E(RD1_D2E),
    .RD2_D2E(RD2_D2E),
    .IMM_D2E(IMM_D2E),
				//input stock
				.TNew_D2E(TNew_D2E),
				.WhoNew_D2E(WhoNew_D2E),
						//input hazard
						.WhoNew_E2M(WhoNew_E2M),
						.WhoNew_M2W(WhoNew_M2W),
						.WD2A3(WD2A3),
	 
	 //output
	 .IR_E2M(IR_E2M),
    .PC4_E2M(PC4_E2M),
    .ALUout_E2M(ALUout_E2M),
	 .RD1_E2M(RD1_E2M),
    .RD2_E2M(RD2_E2M),
	 .MDbusy(MDbusy),
	 .specialstock_E(specialstock_E)
    );
	 
	 Mpart mpart(
	 .Clk(clk),
	 .Reset(reset),
    .IR_E2M(IR_E2M),
    .PC4_E2M(PC4_E2M),
    .ALUout_E2M(ALUout_E2M),
	 .RD1_E2M(RD1_E2M),
    .RD2_E2M(RD2_E2M),
	 						//input harzard
							.WhoNew_M2W(WhoNew_M2W),
							.WD2A3(WD2A3),
	 //output
	 .IR_M2W(IR_M2W),
    .PC4_M2W(PC4_M2W),
    .ALUout_M2W(ALUout_M2W),
    .DMout_M2W(DMout_M2W),

	 						//output harzard
							.WhoNew_E2M(WhoNew_E2M)
    );
	 
	 Wpart wpart(
	 //input
	 .IR_M2W(IR_M2W),
    .PC4_M2W(PC4_M2W),
    .ALUout_M2W(ALUout_M2W),
    .DMout_M2W(DMout_M2W),
	 //output
	 .A3(A3),
	 .WD2A3(WD2A3),
	 .WriteEnabled(WriteEnabled),
	 						//hazard
							.WhoNew_M2W(WhoNew_M2W)
	 );

endmodule
