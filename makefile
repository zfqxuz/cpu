cpu:cpu.v IF.v ID.v EX.v EX.v MEM.v WB.v InstructionRAM.v MainMemory.v
	iverilog cpu.v -o cpu
	vvp ./cpu

