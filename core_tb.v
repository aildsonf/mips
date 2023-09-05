/*
UFRPE - Universidade Federal Rural de Pernambuco
DC - Bacharelado em Ciência da Computação
Arquitetura e Organização de Computadores - 2022.2

Projeto 02 - Implementação de MIPS (subconjunto da ISA) em Verilog

Aluno(s): Arthur Macedo, Aildson Ferreira
*/

module core_tb;

	reg clock, reset;

	// Cria uma instância pro módulo
	core uut (
		.clock(clock),
		.reset(reset),
	);

	// Gera os pulsos de clock
	always begin
		#5 clock = ~clock;
	end

	initial begin
	clock = 0;
	reset = 1;
	#10 reset = 0;
	#20 $stop;
	end

endmodule
