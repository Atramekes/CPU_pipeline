`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:58:13 12/09/2018 
// Design Name: 
// Module Name:    CMPcontroller4D 
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
module Controller4D(
    input [31:0] instr,
	 //normal
    output [3:0] CMPop,
    output [1:0] selPC,
	 output [3:0] EXTop,
	 output likely,
	 //stock
	 output [1:0] TNew_F2D,
	 output [4:0] WhoNew_F2D,
	 output [1:0]specialstock_D
	 //hazard
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
	 
	 //normal
	 //extendor功能选择
	 assign EXTop[3:0] =
		(lui) ? 4'b0010 : //加载到高位
		(lb | lbu | lh | lhu | lw | sb | sh | sw | addi | addiu | slti | sltiu | sltu) ? 4'b0001 : //符号扩展
		(jal | bltzal | jalr) ? 4'b0011 : //输出PC+4
		4'b0000; //零扩展
		
	 //comparor功能选择
    assign CMPop[3:0] =
		(beq) ? 4'b0000 : //等于则跳转
	   (bltz | bltzal) ? 4'b0001 : //小于0则跳转
		(bgtz) ? 4'b0010 : //大于0则跳转
		(blez) ? 4'b0011 : //小于等于0则跳转
		(bgez | bgezl) ? 4'b0100 : //大于等于0则跳转
		(bne) ? 4'b0101 : //不等于则跳转
		4'b0000;
		
	 //下一个PC值选择
	 assign selPC[1:0] = 
		(jr | jalr) ? 2'b11 :  //RS
		(j | jal) ? 2'b10 :  //立即数
		(beq | bne | blez | bgez | bltz | bgtz | bltzal | bgezl) ? 2'b01 :  //b族专用立即数
		2'b00;
		
	 //likely指令
	 assign likely = (bgezl) ? 1 : 0;
		
	 //stock
	 //根据本指令在D阶段的时候还需要多久能提供，请修改
	 assign TNew_F2D[1:0] = 
		(add | addu | sub | subu | andx | orx | xorx | norx | sll | srl | sllv | srlv | sra | srav | slt | slt | addi | addiu | andi | ori | xori | slti | sltiu | mfhi | mflo) ? 2 : 
		(lb | lbu | lh | lhu | lw) ? 3 : 
		0;
	
	 //特殊停止指令
	 assign specialstock_D[1:0] = (mult | multu | div | divu) ? 2'b01 : 2'b00;
	
	 //hazard
	 //根据本指令提供谁，请修改
	 assign WhoNew_F2D[4:0] =
		(add | addu | sub | subu | andx | orx | xorx | norx | sll | srl | sllv | srlv | sra | srav | slt | sltu | mfhi | mflo | jalr) ? instr[`rd] :
		(addi | addiu | andi | ori | xori | slti | sltiu | lui | lb | lbu | lh | lhu | lw) ? instr[`rt] :
		(jal | bltzal) ? 31 :
		0;


endmodule
