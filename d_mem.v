/*
UFRPE - Universidade Federal Rural de Pernambuco
DC - Bacharelado em Ciência da Computação
Arquitetura e Organização de Computadores - 2022.2

Projeto 02 - Implementação de MIPS (subconjunto da ISA) em Verilog

Aluno(s): Arthur Macedo, Aildson Ferreira
*/

module d_mem(
	input [31:0] Address,			// Endereço de acesso (fornecido pela ULA)
	input [31:0] WriteData,			// Dado que será escrito na memória na posição especificada por <Address>
	input MemWrite, MemRead,		// Sinais de controle de leitura e escrita
	output reg [31:0] ReadData		// Dado lido da memória na posição especificada por <Address>
);

	parameter RAM_SIZE = 256;				// Tamanho parametrizável (memória RAM), inicialmente setado pra 256MB

	reg [31:0] memory [0:RAM_SIZE - 1]; // Definição da memória

	always @(posedge MemWrite or posedge MemRead) begin
		if (MemWrite) begin
			memory[Address] <= WriteData;	//	Escreve o conteúdo de <WriteData> na posição especificada por <Address>
		end
		
		if (MemRead) begin
			ReadData <= memory[Address];	//	Lê o conteúdo da memória na posição especificada por <Address> e armazena em <ReadData>
		end 
	end

endmodule
