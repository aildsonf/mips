/*
UFRPE - Universidade Federal Rural de Pernambuco
DC - Bacharelado em Ciência da Computação
Arquitetura e Organização de Computadores - 2022.2

Projeto 02 - Implementação de MIPS (subconjunto da ISA) em Verilog

Aluno(s): Arthur Macedo, Aildson Ferreira
*/

// Instruction Memory
module i_mem (
	input [31:0] address,		// Endereço da instrução
	output wire [31:0] i_out	// Valor da memória com base no endereço 
);

	parameter ROM_SIZE = 64;						// Tamanho parametrizável (memória ROM), inicialmente setado pra 256MB

	reg [31:0] memory [0:ROM_SIZE - 1]; 		// Definição da memória

	// O bloco "initial" serve pra que a gente inicialize a variável <memory> com os dados do arquivo
	initial begin  // mudar ora binario
		$readmemb("instruction.list", memory);	// Carrega as intruções do arquivo na memória
	end

	// Atribui o dado do endereço da memória ao output, se ele estiver no range definido acima, ou zero, caso contrário
	assign i_out = (address < ROM_SIZE) ? memory[address] : 32'b0;	

endmodule
