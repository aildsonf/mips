/*
UFRPE - Universidade Federal Rural de Pernambuco
DC - Bacharelado em Ciência da Computação
Arquitetura e Organização de Computadores - 2022.2

Projeto 02 - Implementação de MIPS (subconjunto da ISA) em Verilog

Aluno(s): Arthur Macedo, Aildson Ferreira
*/


//	Módulos auxiliares para a integração dos componentes
//	Somador do PC
module ADD_PC(
	input [31:0] pc,				// Recebe o PC atual
	output reg [31:0] nextPC	// A saída é o PC atualizado com a próxima instrução
);

	always @(pc) begin
		nextPC <= pc + 4;			// Ao receber um PC, somar 4 e atribuir ao <nextPC>
	end

endmodule 

// Somador do Shift Left 2
module ADD_BRANCH(		
	input [31:0] nextPC,			//	Recebe o pc da próxima instrução
	input [31:0] shift,			// Recebe o offset após a multiplicação por 4
	output reg [31:0] branch		
);

	always @* begin
		branch <= nextPC + shift;
	end

endmodule 


//	Sign-Extend 16 bits -> 32 bits
module SignExtend(
	input [15:0] number,
	output reg [31:0] extended_number
);	

	always @(number) begin
		extended_number[31:0] <= number[15:0];
	end
	
endmodule

//	Shift Left 2 (Multiplicação por 4, instruções de desvio)
module ShiftLeft2(
	input [31:0] offset,
	output reg [31:0] shift
);	

	always @(offset) begin
		shift = offset << 2;
	end
	
endmodule 


// MUX_RegDst
// Esse MUX auxilia no processo de "Instruction Fetch"
module MUX_RegDst(
	input RegDst,
	input [5:0] rt,
	input [5:0] rd,
	output reg [4:0] WriteAddr
);

	always @* begin
		case(RegDst)
			0: WriteAddr = rt;
			1: WriteAddr = rd;
		endcase
	end

endmodule

// MUX_ALUSrc
module MUX_ALUSrc(
	input ALUSrc,
	input [31:0] ReadData2,
	input [31:0] extended_number,
	output reg [31:0] ALU_In2
);
	
	always @* begin
		case(ALUSrc)
			0: ALU_In2 = ReadData2;
			1: ALU_In2 = extended_number;
		endcase
	end
	
endmodule

// MUX_PCSrc
// Esse MUX auxilia no processo de escolha para a próxima instrução
module MUX_PCSrc(
	input [31:0] pc,
	input [31:0] branch,
	input AND_result,
	output reg [31:0] nextPC
);
	
	initial begin
		nextPC = 32'b0;
	end
	
	always @* begin
		case(AND_result)
			0: nextPC = pc;
			1: nextPC = branch;
		endcase
	end

endmodule

// MUX_MemtoReg
module MUX_MemtoReg(
	input MemtoReg,
	input [31:0] ReadData,
	input [31:0] ALU_result,
	output reg [31:0] WriteData
);

	always @* begin
		case(MemtoReg)
			0: WriteData = ALU_result;
			1: WriteData = ReadData;
		endcase
	end

endmodule


// AND (Control Unit & ALU)
module AND_CTRL_ALU(
	input Branch, Zero_flag,
	output reg AND_result
);
	always @(Branch, Zero_flag) begin
		AND_result = Branch && Zero_flag;
	end
endmodule


// Definição do Processador
module core(
	clock, reset, pc, nextPC, instruction, 
	ALUOp, ALUSrc, RegDst, RegWrite, MemtoReg, MemRead, MemWrite, Branch, Jump, 
	WriteAddr, WriteData, ReadData1, ReadData2,
	extended_number, shift, ALU_In2, ALUCtrl, ALU_result, Zero_flag,
	AND_result, ADD_Branch, ReadData
);
	
	//	Todos os fios são inicializados inicializados abaixo:
	input wire clock, reset;
	
	output wire	[31:0] pc, nextPC;
	output wire [31:0] instruction;
	output wire [2:0] ALUOp;
	output wire ALUSrc, RegDst, RegWrite, MemtoReg, MemRead, MemWrite, Branch, Jump;
	output wire [4:0] WriteAddr;
	output wire	[31:0] WriteData;
	output wire [31:0] ReadData1, ReadData2;
	output wire [31:0] extended_number;
	output wire [31:0] shift;
	output wire [31:0] ALU_In2;
	output wire [31:0] ADD_Branch;
	output wire [3:0] ALUCtrl;
	output wire [31:0] ALU_result;
	output wire Zero_flag;
	output wire AND_result;
	output wire [31:0] ReadData;	
	
	
	// Todos os componentes são inicializados abaixo:
	//	Contador de Programa		
	PC ProgramCounter(.clock(clock), .nextPC(nextPC), .pc(pc));
	
	// Memória de Instrução	
	i_mem InstructionMemory(.address(pc), .i_out(instruction));
	
	// Unidade de Controle	
	ctrl ControlUnit(
		.opcode(instruction[31:26]),
		.funct(instruction[5:0]),
		.ALUOp(ALUOp),
		.ALUSrc(ALUSrc),
		.RegDst(RegDst),
		.RegWrite(RegWrite),
		.MemtoReg(MemtoReg),
		.MemRead(MemRead),
		.MemWrite(MemWrite),
		.Branch(Branch),
		.Jump(Jump)
	);
	
	//	Instruction Memory -> Registers	
	MUX_RegDst MUX_RegDst(
		.RegDst(RegDst),
		.rt(instruction[20:16]),
		.rd(instruction[15:11]),
		.WriteAddr(WriteAddr)
	);

	// Banco de Registradores
	regfile Registers(
		.Clock(clock),
		.Reset(reset),
		.ReadAddr1(instruction[25:21]),
		.ReadAddr2(instruction[20:16]),
		.WriteAddr(WriteAddr),
		.WriteData(WriteData),
		.RegWrite(RegWrite),
		.ReadData1(ReadData1),
		.ReadData2(ReadData2)
	);
	
	// Registers -> ALU	
	//
	SignExtend Sign_Extend(
		.number(instruction[15:0]),
		.extended_number(extended_number)
	);
	
	ShiftLeft2 Shift_Left2(
		.offset(extended_number),
		.shift(shift)
	);
	
	MUX_ALUSrc MUX_ALUSrc(
		.ALUSrc(ALUSrc),
		.ReadData2(ReadData2),
		.extended_number(extended_number),
		.ALU_In2(ALU_In2)
	);
	
	
	ADD_BRANCH ADD_BRANCH(
		.nextPC(nextPC),
		.shift(shift),
		.branch(ADD_Branch)
	);
	
	// Unidade de Controle da ULA
	ula_ctrl ALUControl(
		.ALUOp(ALUOp),
		.funct(instruction[5:0]),
		.ALUCtrl(ALUCtrl)
	);
	
	// ULA
	ula ALU(
		.In1(ReadData1),
		.In2(ALU_In2),
		.OP(ALUCtrl),
		.result(ALU_result),
		.Zero_flag(Zero_flag)
	);
	
	// ALU -> Data Memory	
	// AND (Branch, Zero_flag)
	AND_CTRL_ALU AND(
		.Branch(Branch),
		.Zero_flag(Zero_flag),
		.AND_result(AND_result)
	);
	
	MUX_PCSrc MUX_PCSrc(
		.pc(pc),
		.branch(ADD_Branch),
		.AND_result(AND_result),
		.nextPC(nextPC)
	);
	
	// Memória de Dados
	d_mem DataMemory(
		.Address(ALU_result),
		.WriteData(ReadData2),
		.MemWrite(MemWrite),
		.MemRead(MemRead),
		.ReadData(ReadData)
	);
	
	MUX_MemtoReg MUX_MemtoReg(
		.MemtoReg(MemtoReg),
		.ReadData(ReadData),
		.ALU_result(ALU_result),
		.WriteData(WriteData)
	);

endmodule 