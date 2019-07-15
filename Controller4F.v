`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:44:58 12/11/2018 
// Design Name: 
// Module Name:    Controller4F 
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
module Controller4W(
	 input [31:0] instr,
	 input [31:0] ALUout,
	 input [31:0] DMout,
    output WriteEnabled,
    output [1:0] Mem2Reg,
    output [1:0] RegDst,
	 output [2:0] BEXTop,
	 //hazard
	 output [4:0] WhoNew_M2W
    );
	 
	 `define rs 25:21
	 `define rt 20:16
	 `define rd 15:11
	 `define immediate 15:0
	 `define func 5:0
	 `define op 31:26
	 `define shamt 10:6
	 
	 wire lb,lbu,lh,lhu,lw,sb,sh,sw,add,addu,sub,subu,andx,orx,xorx,norx,sll,srl,sllv,srlv,sra,srav,slt,sltu,j,jr,jal,jalr;
	 wire addi,addiu,andi,ori,xori,slti,sltiu,lui,mult,multu,div,divu,mfhi,mflo,mthi,mtlo,beq,bne,blez,bgez,bltz,bgtz,bltzal,bgezl;
	 
	 assign lb      = instr[`op] == 6'b100000;
	 assign lbu     = instr[`op] == 6'b100100;
	 assign lh      = instr[`op] == 6'b100001;
	 assign lhu     = instr[`op] == 6'b100101;
	 assign lw      = instr[`op] == 6'b100011;
	 assign sb      = instr[`op] == 6'b101000;
	 assign sh      = instr[`op] == 6'b101001;
    assign sw      = instr[`op] == 6'b101011;
	 assign add     = instr[`op] == 6'b000000 & instr[`func] == 6'b100000; 
	 assign addu    = instr[`op] == 6'b000000 & instr[`func] == 6'b100001; 
	 assign sub     = instr[`op] == 6'b000000 & instr[`func] == 6'b100010; 
	 assign subu    = instr[`op] == 6'b000000 & instr[`func] == 6'b100011; 
	 assign andx    = instr[`op] == 6'b000000 & instr[`func] == 6'b100100; 
	 assign orx     = instr[`op] == 6'b000000 & instr[`func] == 6'b100101;  
	 assign xorx    = instr[`op] == 6'b000000 & instr[`func] == 6'b100110;  
	 assign norx    = instr[`op] == 6'b000000 & instr[`func] == 6'b100111;  
	 assign sll     = instr[`op] == 6'b000000 & instr[`func] == 6'b000000;
	 assign srl     = instr[`op] == 6'b000000 & instr[`func] == 6'b000010;
	 assign sllv    = instr[`op] == 6'b000000 & instr[`func] == 6'b000100;
	 assign srlv    = instr[`op] == 6'b000000 & instr[`func] == 6'b000110;
	 assign sra     = instr[`op] == 6'b000000 & instr[`func] == 6'b000011;
	 assign srav    = instr[`op] == 6'b000000 & instr[`func] == 6'b000111;
	 assign slt     = instr[`op] == 6'b000000 & instr[`func] == 6'b101010;
	 assign sltu    = instr[`op] == 6'b000000 & instr[`func] == 6'b101011;
	 assign addi    = instr[`op] == 6'b001000; 
	 assign addiu   = instr[`op] == 6'b001001; 
	 assign andi    = instr[`op] == 6'b001100; 
	 assign ori     = instr[`op] == 6'b001101; 
	 assign xori    = instr[`op] == 6'b001110; 
	 assign slti    = instr[`op] == 6'b001010;
	 assign sltiu   = instr[`op] == 6'b001011;
	 assign lui     = instr[`op] == 6'b001111;
	 assign mult    = instr[`op] == 6'b000000 & instr[`func] == 6'b011000;
	 assign multu   = instr[`op] == 6'b000000 & instr[`func] == 6'b011001;
	 assign div     = instr[`op] == 6'b000000 & instr[`func] == 6'b011010;
	 assign divu    = instr[`op] == 6'b000000 & instr[`func] == 6'b011011;
	 assign mfhi    = instr[`op] == 6'b000000 & instr[`func] == 6'b010000;
	 assign mflo    = instr[`op] == 6'b000000 & instr[`func] == 6'b010010;
	 assign mthi    = instr[`op] == 6'b000000 & instr[`func] == 6'b010001;
	 assign mtlo    = instr[`op] == 6'b000000 & instr[`func] == 6'b010011;
	 assign beq     = instr[`op] == 6'b000100;
	 assign bne     = instr[`op] == 6'b000101;
	 assign blez    = instr[`op] == 6'b000110 & instr[`rt] == 5'b00000;
	 assign bgez    = instr[`op] == 6'b000001 & instr[`rt] == 5'b00001;
	 assign bltz    = instr[`op] == 6'b000001 & instr[`rt] == 5'b00000;
	 assign bgtz    = instr[`op] == 6'b000111 & instr[`rt] == 5'b00000;
	 assign bltzal  = instr[`op] == 6'b000001 & instr[`rt] == 5'b10000;
	 assign bgezl   = instr[`op] == 6'b000001 & instr[`rt] == 5'b00011;
	 assign j       = instr[`op] == 6'b000010;
	 assign jr      = instr[`op] == 6'b000000 & instr[`func] == 6'b001000; 
	 assign jal     = instr[`op] == 6'b000011;
	 assign jalr    = instr[`op] == 6'b000000 & instr[`func] == 6'b001001;
	 
	 //决定DM怎么读
	 assign BEXTop[2:0] = 
	 	(lh) ? 3'b101 : //读16bit并符号扩
		(lb) ? 3'b110 : //读8bit并符号扩
		(lhu) ? 3'b001 : //读16bit并零扩
		(lbu) ? 3'b010 : //读8bit并零扩
		3'b000; //读32bit
	
	 //决定写给哪个寄存器，即A3是谁
	 assign RegDst[1:0] = 
		(jal | bltzal) ? 2'b10 : //写入31
		(add | addu | sub | subu | andx | orx | xorx | norx | sll | srl | sllv | srlv | sra | srav | slt | sltu | mfhi | mflo | jalr) ? 2'b01 : //写入RD
		2'b00; //写入RT

	 //决定将什么写给A3
	 assign Mem2Reg[1:0] = 
		(jal | bltzal | jalr) ? 2'b10 : //给A3写入PC+4
		(lb | lbu | lh | lhu | lw) ? 2'b01 : //给A3写入DMout
		2'b00; //给A3写入ALUout
		
	 //决定是否可以写
	 assign WriteEnabled = (lb | lbu | lh | lhu | lw | add | addu | sub | subu | andx | orx | xorx | norx | sll | srl | sllv | srlv | sra
	 | srav | slt | sltu | addi | addiu | andi | ori | xori | slti | sltiu | lui | mfhi | mflo | bltzal | jal | jalr) ? 1 : 0;
	 
	 //hazard
	 //根据本指令提供谁，请修改
	 assign WhoNew_M2W[4:0] = 
		(add | addu | sub | subu | andx | orx | xorx | norx | sll | srl | sllv | srlv | sra | srav | slt | sltu | mfhi | mflo | jalr) ? instr[`rd] :
		(addi | addiu | andi | ori | xori | slti | sltiu | lui | lb | lbu | lh | lhu | lw) ? instr[`rt] :
		(jal | bltzal) ? 31 :
		0;

endmodule
