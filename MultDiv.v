`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:36:36 12/18/2018 
// Design Name: 
// Module Name:    MultDiv 
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
   module MultDiv(
    input [31:0] A,
    input [31:0] B,
	 input clk,
	 input [2:0] op,
    output [31:0] out,
    output busy,
    input start
    );
	 
	 reg [31:0] hi;
	 reg [31:0] lo;
	 reg [3:0] countdown;
	 reg Busy;
	 
	 assign busy = Busy;
	 assign out = op[2:0] == 3'b110 ? hi : lo;
	 
	 initial begin
		hi=0;
		lo=0;
		countdown=0;
		Busy=0;
	 end
	 
	 always @(posedge clk) begin
		if(start == 1) begin
			if (op[2:0] == 3'b000) begin
				{hi,lo} = $signed(A) * $signed(B);
				countdown = 3;
			end
			else if (op[2:0] == 3'b001) begin
				{hi,lo} = {1'b0,A} *{1'b0,B};
				countdown = 3;
			end
			else if (op[2:0] == 3'b010) begin
				hi = $signed(A) % $signed(B); 
				lo = $signed(A) / $signed(B);
				countdown = 8;
			end
			else if (op[2:0] == 3'b011) begin
				hi = {1'b0,A} % {1'b0,B}; 
				lo = {1'b0,A} / {1'b0,B};
				countdown = 8;
			end
		end
		if (op[2:0] == 3'b100) begin
			hi = A;
		end
		else if (op[2:0] == 3'b101) begin
			lo = A;
		end
		if(countdown > 0) begin
			countdown = countdown - 1;
			Busy = 1;
		end
		else
			Busy = 0;
	 end

endmodule
