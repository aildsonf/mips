/*
UFRPE - Universidade Federal Rural de Pernambuco
DC - Bacharelado em Ciência da Computação
Arquitetura e Organização de Computadores - 2022.2

Projeto 02 - Implementação de MIPS (subconjunto da ISA) em Verilog

Aluno(s): Arthur Macedo, Aildson Ferreira
*/

module ula_ctrl(
	input [2:0] ALUOp,			//	Sinal provido pela unidade de controle
	input [5:0] funct,			//	6 bits menos significativos da instrução
	output reg [3:0] ALUCtrl	// Operação a ser realizada na ALU 
);	

	always @(ALUOp, funct) begin
		case (ALUOp)		
			3'b000: ALUCtrl = 4'b0010; // Adição
			3'b001: ALUCtrl = 4'b0110; // subtração
			
			3'b010: begin
				case (funct)
					6'b100000: ALUCtrl = 4'b0010;	//	add
					6'b100010: ALUCtrl = 4'b0110;	//	sub
					6'b100100: ALUCtrl = 4'b0000;	//	and
					6'b100101: ALUCtrl = 4'b0001;	//	or
					6'b100110: ALUCtrl = 4'b0011;	//	xor
					6'b100111: ALUCtrl = 4'b1100;	//	nor
					6'b101010: ALUCtrl = 4'b0111;	//	slt
					default: ALUCtrl = 4'b0000;
				endcase
			end
			
			default: ALUCtrl = 4'b0000;
		endcase
	end
endmodule
