`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:03:42 11/26/2018 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
    input [31:0] A,
    input [31:0] B,
    input [3:0] ALUop,
    output [31:0] C
    );
	 
	 
	assign C = (ALUop[3:0] == 4'b0000) ? A + B :
			(ALUop[3:0] == 4'b0001) ? A - B :
			(ALUop[3:0] == 4'b0010) ? A | B :
			(ALUop[3:0] == 4'b0011) ? A & B :
			(ALUop[3:0] == 4'b0100) ? A ^ B :
			(ALUop[3:0] == 4'b0101) ? B :
			(ALUop[3:0] == 4'b0110) ? ~A & ~B :
			(ALUop[3:0] == 4'b0111) ? A < B :
			(ALUop[3:0] == 4'b1000) ? $signed(A) < $signed(B) :
			(ALUop[3:0] == 4'b1001) ? B << A[4:0] :
			(ALUop[3:0] == 4'b1010) ? B >> A[4:0] :
			(ALUop[3:0] == 4'b1011) ?  $signed($signed(B) >>> $signed(A[4:0])) :
			32'hx;
			
			
endmodule
