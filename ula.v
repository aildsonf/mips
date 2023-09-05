/*
UFRPE - Universidade Federal Rural de Pernambuco
DC - Bacharelado em Ciência da Computação
Arquitetura e Organização de Computadores - 2022.2

Projeto 02 - Implementação de MIPS (subconjunto da ISA) em Verilog

Aluno(s): Arthur Macedo, Aildson Ferreira
*/

module ula (
	input [31:0] In1, In2,		// Operandos In1, In2
	input [3:0] OP,				// Operação a ser realizada (ALUCtrl)
	output reg [31:0] result, 	// Resultado da operação
	output reg Zero_flag			// Flag que indica que o resultado é zero
);

	always @* begin	
		// Escolhe a operação com base no OP code
		case (OP)	
			4'b0000: begin	// AND
				result = In1 & In2;
				Zero_flag = (result == 32'b0) ? 1'b1 : 1'b0;
			end	
			
			4'b0001: begin	//	OR
				result = In1 | In2;
				Zero_flag = (result == 32'b0) ? 1'b1 : 1'b0;
			end
			
			4'b0010: begin	//	Adição
				result = In1 + In2;
				Zero_flag = (result == 32'b0) ? 1'b1 : 1'b0;
			end
			
			4'b0110: begin	//	Subtração
				result = In1 - In2;
				Zero_flag = (result == 32'b0) ? 1'b1 : 1'b0;
			end
			
			4'b0111: begin	//	Slt
				result = (In1 < In2) ? 1'b1 : 1'b0;
				Zero_flag = (result == 32'b0) ? 1'b1 : 1'b0;
			end
			
			4'b1100: begin	//	NOR
				result = ~(In1 | In2);
				Zero_flag = (result == 32'b0) ? 1'b1 : 1'b0;
			end
			
			default: begin
				result = 32'b0;	// Por padrão, devolve 0, caso uma operação inválida for fornecida
				Zero_flag = 1'b0;
			end
		endcase
	end

endmodule
