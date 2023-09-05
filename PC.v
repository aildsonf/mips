/*
UFRPE - Universidade Federal Rural de Pernambuco
DC - Bacharelado em Ciência da Computação
Arquitetura e Organização de Computadores - 2022.2

Projeto 02 - Implementação de MIPS (subconjunto da ISA) em Verilog

Aluno(s): Arthur Macedo, Aildson Ferreira
*/

// Program Counter
module PC (
	input clock,       	// Sinal de Clock
	input [31:0] nextPC,	// Endereço que vai ser escrito no PC
	output reg [31:0] pc	// Valor armazenado no PC
);

	always @(posedge clock) begin	// Sempre que o Clock estiver na borda de subida, atualiza o valor do PC
		pc <= nextPC;
	end

endmodule
