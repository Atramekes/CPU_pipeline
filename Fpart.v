`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:06:59 12/01/2018 
// Design Name: 
// Module Name:    Fpart 
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
module Fpart(
	 //nomal
    input [1:0] selPC,
	 input [31:0] NPC,
	 input Clk,
	 input Reset,
	 //stock
	 input [1:0] TNew_F2D,
	 input [4:0] WhoNew_F2D,
	 input [1:0] TNew_D2E,
	 input [4:0] WhoNew_D2E,
	 input MDbusy,
	 input [1:0]specialstock_D,
	 input [1:0]specialstock_E,
	 input nullize,
	 //nomal
    output reg [31:0] IR_F2D,
    output reg [31:0] PC4_F2D
    );
	 
	 wire [31:0] mux4PC;
	 wire [31:0] instruction;
	 wire [31:0] PC4;
	 

	 wire stock;
	 
	 //MUX for PC
	 assign mux4PC = (selPC == 2'b00) ? PC4 : NPC;
	 
	 IFU ifu(
      .MUX4PC_out(mux4PC),
      .Clk(Clk),
      .Reset(Reset),
      .Instruction(instruction),
		.PC4(PC4),
		.stock(stock)
	);
	
	Con4Stock con4stock(
    .instr(instruction),
    .TNew_F2D(TNew_F2D),
	 .WhoNew_F2D(WhoNew_F2D),
	 .TNew_D2E(TNew_D2E),
	 .WhoNew_D2E(WhoNew_D2E),
	 .MDbusy(MDbusy),
	 .specialstock_D(specialstock_D),
	 .specialstock_E(specialstock_E),
    .stock(stock)
	);
	
	
	initial begin
		IR_F2D = 0;
		PC4_F2D = 32'h3004;
	end
	
	always @(posedge Clk) begin
		if(Reset != 1) begin
			if (!stock & !nullize) begin
				IR_F2D <= instruction;
				PC4_F2D <= PC4;
			end
			else begin
				IR_F2D <= 0;
				PC4_F2D <= 0;
			end
		end
	end
	 
	 


endmodule
