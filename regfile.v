/*
UFRPE - Universidade Federal Rural de Pernambuco
DC - Bacharelado em Ciência da Computação
Arquitetura e Organização de Computadores - 2022.2

Projeto 02 - Implementação de MIPS (subconjunto da ISA) em Verilog

Aluno(s): Arthur Macedo, Aildson Ferreira
*/

module regfile (
	input [4:0] ReadAddr1, ReadAddr2, WriteAddr,	// Números dos registradores que serão lidos e escritos
	input [31:0] WriteData,								// Dado que será escrito no registrador especificado por <WriteAddr>
	input Clock, Reset, RegWrite,						// Sinais de Clock, Reset e escrita
	output reg [31:0] ReadData1, ReadData2			// Dados lidos nas posições especificadas por <ReadAddr1> e <ReadAddr2>
);

	reg [31:0] registers [31:0]; // Inicializa os 32 registradores, com 32 bits cada

	// Leitura assíncrona
	always @(ReadAddr1, ReadAddr2) begin
		ReadData1 = (ReadAddr1 == 5'b0) ? 32'b0 : registers[ReadAddr1];
		ReadData2 = (ReadAddr2 == 5'b0) ? 32'b0 : registers[ReadAddr2];
	end
	
	// Escrita síncrona
	always @(posedge Clock or posedge Reset) begin
		if (Reset) begin
			// Zera todos os registradores se Reset for TRUE
			reg [0:5] i;
			
			for (i = 0; i < 32; i = i + 1) begin
				registers[i] = 32'b0;
			end
			
		end else if (RegWrite && WriteAddr != 5'b0) begin
			// Escreve no registrador se RegWrite estiver habilitado e não estiver escrevendo no registrador $0
			registers[WriteAddr] = WriteData;
		end
	end

endmodule
