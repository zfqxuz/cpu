cpu:cpu.v
	iverilog cpu.v -o cpu
	vvp ./cpu
