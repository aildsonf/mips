/*
UFRPE - Universidade Federal Rural de Pernambuco
DC - Bacharelado em Ciência da Computação
Arquitetura e Organização de Computadores - 2022.2

Projeto 02 - Implementação de MIPS (subconjunto da ISA) em Verilog

Aluno(s): Arthur Macedo, Aildson Ferreira
*/

module ctrl(
	input [5:0] opcode,	// OPCODE da instrução
	input [5:0] funct,	// Funct code para instruções do tipo R
	
	// Sinais de controle
	output reg [2:0] ALUOp,		// Operação da ULA
	output reg ALUSrc,			// Seleciona a segunda entrada da ALU
	output reg RegDst,			// Determina qual registrador será escrito
	output reg RegWrite,			// Habilita a escrita no banco de registradores
	output reg MemtoReg,			// Seleciona o local do dado que será escrito no banco de registradores	
	output reg MemRead,			// Habilita a leitura da memória de dados
	output reg MemWrite,			// Habilita a escrita na memória de dados
	output reg Branch,			// Habilita desvio (condicional)
	output reg Jump				// Habilita desvio (incondicional)
);

	always @(opcode, funct) begin
		// Inicializa os registradores, atribuíndo zero a todos eles
		ALUOp	= 3'b000;
		RegDst	= 1'b0;
		ALUSrc	= 1'b0;
		MemtoReg = 1'b0;
		RegWrite = 1'b0;
		MemRead	= 1'b0;
		MemWrite = 1'b0;
		Branch	= 1'b0;
		Jump		= 1'b0;

		case (opcode)
			// Instruções do tipo R
			6'b000000: begin
				case (funct)
					6'b000000: begin	// sll
						ALUOp		= 3'b100;
						RegDst	= 1'b1;
						RegWrite = 1'b1;
					end
					
					6'b000010: begin	//	srl
						ALUOp		= 3'b101;
						RegDst	= 1'b1;
						RegWrite = 1'b1;
					end
					
					6'b000011: begin	//	sra
						ALUOp		= 3'b110;
						RegDst	= 1'b1;
						RegWrite = 1'b1;
					end
					
					6'b000100: begin	//	sllv
						ALUOp		= 3'b100;
						RegDst	= 1'b1;
						RegWrite = 1'b1;
					end
					
					6'b000110: begin	// srlv
						ALUOp		= 3'b101;
						RegDst	= 1'b1;
						RegWrite = 1'b1;
					end
					
					6'b000111: begin	//	srav
						ALUOp		= 3'b110;
						RegDst	= 1'b1;
						RegWrite = 1'b1;
					end
					
					6'b001000: begin	// jr
						Jump = 1'b1;
					end
					
					6'b100000: begin	// add
						ALUOp		= 3'b010;
						RegDst	= 1'b1;
						RegWrite = 1'b1;
					end
					
					6'b100010: begin	//	sub
						ALUOp		= 3'b011;
						RegDst	= 1'b1;
						RegWrite = 1'b1;
					end
					
					6'b100100: begin	//	and
						ALUOp		= 3'b000;
						RegDst	= 1'b1;
						RegWrite = 1'b1;
					end
					
					6'b100101: begin	//	or
						ALUOp		= 3'b000;
						RegDst	= 1'b1;
						RegWrite = 1'b1;
					end
					
					6'b100110: begin	//	xor
						ALUOp		= 3'b000;
						RegDst	= 1'b1;
						RegWrite = 1'b1;
					end
					
					6'b100111: begin	//	nor
						ALUOp		= 3'b000;
						RegDst	= 1'b1;
						RegWrite = 1'b1;
					end
					
					6'b101010: begin	//	slt
						ALUOp		= 3'b111;
						RegDst	= 1'b1;
						RegWrite = 1'b1;
					end
					
					6'b101011: begin	//	sltu
						ALUOp		= 3'b111;
						RegDst	= 1'b1;
						RegWrite = 1'b1;
					end
					
					default: ALUOp = 3'b000;
					
				endcase
			end
			
			// Instruções do tipo I
			6'b000100: begin	//	beq
				ALUOp		= 3'b001;
				Branch	= 1'b1;
			end
			
			6'b000101: begin	//	bne
				ALUOp		= 3'b001;
				Branch	= 1'b1;
			end
			
			6'b001000: begin	//	addi
				ALUOp		= 3'b000;
				ALUSrc 	= 1'b1;
				RegWrite = 1'b1;
			end
			
			6'b001010: begin	//	slti
				ALUOp		= 3'b111;
				ALUSrc	= 1'b1;
				RegWrite = 1'b1;
			end
			
			6'b001011: begin	//	sltiu
				ALUOp		= 3'b111;
				ALUSrc	= 1'b1;
				RegWrite = 1'b1;
			end
			
			6'b001100: begin	//	andi
				ALUOp		= 3'b000;
				ALUSrc	= 1'b1;
				RegWrite = 1'b1;
			end
			
			6'b001101: begin	//	ori
				ALUOp		= 3'b000;
				ALUSrc	= 1'b1;
				RegWrite = 1'b1;
			end
			
			6'b001110: begin	//	xori
				ALUOp		= 3'b000;
				ALUSrc	= 1'b1;
				RegWrite = 1'b1;
			end
			
			6'b001111: begin	//	lui
				ALUOp		= 3'b000;
				ALUSrc	= 1'b1;
				RegWrite = 1'b1;
			end
			
			6'b100011: begin	//	lw
				ALUOp		= 3'b000;
				ALUSrc	= 1'b1;
				MemtoReg = 1'b1;
				RegWrite = 1'b1;
				MemRead	= 1'b1;
			end
			
			6'b101011: begin	//	sw
				ALUOp		= 3'b000;
				ALUSrc	= 1'b1;
				MemWrite = 1'b1;
			end
			
			// Instruções do tipo J
			6'b000010: begin	//	j
				Jump = 1'b1;
			end
			
			6'b000011: begin	//	jal
				Jump = 1'b1;
				RegWrite = 1'b1;
			end
			
			default: ALUOp = 3'b000;
			
		endcase
	end

endmodule
