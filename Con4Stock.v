`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:26:48 12/10/2018 
// Design Name: 
// Module Name:    Con4Stock 
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
module Con4Stock(
    input [31:0] instr,
	 input [1:0] TNew_D2E,
	 input [4:0] WhoNew_D2E,
	 input [4:0]WhoNew_F2D,
	 input [1:0]TNew_F2D,
	 input MDbusy,
	 input [1:0]specialstock_D,
	 input [1:0]specialstock_E,
    output stock
    );
	 
	 wire [5:0]op;
	 wire [5:0]func;
	 wire [4:0]rt;

	 wire stock4r1;
	 wire stock4r2;
	 wire [1:0] r1_TUse;
	 wire [1:0] r2_TUse;
	 wire MDuse;
	 wire MDstock;
	 wire sp1stock;
	 wire sp2stock;

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
	
	/*
	┌──┐ ┌──┐  ┌───┐ ┌──┐  ┌──┐
	│IF├─┤RF├──┤ALU├─┤DM├──┤RF│
	│0 │ │1 ├──┤2  │ │3 │  │4 │
	└──┘ └──┘  └───┘ └──┘  └──┘
	     ┌──┐  ┌──┐  ┌───┐ ┌──┐  ┌──┐
	     │IF├──┤RF├──┤ALU├─┤DM├──┤RF│
	     │0 │  │1 ├──┤2  │ │3 │  │4 │
	     └──┘  └──┘  └───┘ └──┘  └──┘
	           ┌──┐  ┌──┐  ┌───┐ ┌──┐  ┌──┐
	           │IF├──┤RF├──┤ALU├─┤DM├──┤RF│
	           │0 │  │1 ├──┤2  │ │3 │  │4 │
	           └──┘  └──┘  └───┘ └──┘  └──┘
				  	     ┌──┐  ┌──┐  ┌───┐ ┌──┐ ┌──┐
	                 │IF├──┤RF├──┤ALU├─┤DM├─┤RF│
	                 │0 │  │1 ├──┤2  │ │3 │ │4 │
	                 └──┘  └──┘  └───┘ └──┘ └──┘

				addu,subu,ori,lui,beq, sw, lw,j,jal,jr
	whoNew     r3  r3   r2  r2  /   /   r2  / 31  / 
	TNew       2   2    2   1   /   /   3   /  1  / 
	
	r1_TUse     2   2    2   /   1  2   2  /  /  1
	r2_TUse     2   2    /   /   1  3   /  /  /  /
	
	*/
	
	//暂停机制
	//根据本指令何时使用R1、R2，请修改
	
	assign r1_TUse =
		(beq | bne | blez | bgez | bltz | bgtz | jr | jalr | bltzal | bgezl) ? 1 :
		(sll | srl | sra | lui | mfhi | mflo | j | jal) ? 5 : 
		2;

	assign r2_TUse =
		(beq | bne) ? 1 : 
		(add | addu | sub | subu | andx | orx | xorx | norx | sll | srl | sllv | srlv | sra | srav | slt | sltu | mult | multu | div | divu) ? 2 :
		(sb | sh | sw) ? 3 :
		5;
		
	assign MDuse = (mult | multu | div | divu | mfhi | mflo | mthi | mtlo) ? 1 : 0;
	
	assign MDstock = (MDuse & MDbusy) ? 1 : 0;
	assign sp1stock = (MDuse & specialstock_D == 2'b01) ? 1 : 0;
	assign sp2stock = (MDuse & specialstock_E == 2'b01) ? 1 : 0;
	assign stock4r1 = ((instr[`rs] == WhoNew_F2D && instr[`rs] != 0 && r1_TUse < TNew_F2D) || (instr[`rs] == WhoNew_D2E && instr[`rs] != 0 && r1_TUse < TNew_D2E)) ? 1 : 0;
	assign stock4r2 = ((instr[`rt] == WhoNew_F2D && instr[`rt] != 0 && r2_TUse < TNew_F2D) || (instr[`rt] == WhoNew_D2E && instr[`rt] != 0 && r2_TUse < TNew_D2E)) ? 1 : 0;
	assign stock = stock4r1 | stock4r2 | MDstock | sp1stock | sp2stock;
	
	
endmodule
