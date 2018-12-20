
ECE 350 Processor
----
A pipelined MIPS-like architecture processor written in Verilog for the Altera DE2-115 Board

* Introduction

	The ECE 350 processor is a single-issue, in-order pipelined processor that executes the ECE 350 ISA (found below) and the pipeline contains five stages: Fetch, Decode, Execute, Memory and Writeback. The rest of this document discusses in detail the design and implementation of this processor.

* ISA
	
	![ISA](/image/ISA.png)

* Components
	* Regfile

		The register file contains 32 registers. Each register is 32-bit and uses positive-edge-triggered D-Flip-Flops with write-enable as basic memory elements. The register file has two read ports and one write port. The read ports select data with tri-state buffers. It needs to be clocked on the positive edge to avoid data hazards. 
		$r0 is always zero. $r30, also called $rstatus, is set to a non-zero value when an exception occurs. $r31 or $ra is the return address register.
	* ALU
	
		The 32-bit ALU is the main execution unit. It supports addition, subtraction, bitwise and, bitwise or, logical left shift and arithmetic right shifts. Addition and subtraction are implemented with a hybrid carry-select-carry-lookahead adder, while shift operations are implemented with barrel shifters. During an addition or subtraction execution, overflow is detected and outputted as a flag signal that could be captured by higher level components. During subtraction, the ALU also outputs two flags: isNotEqual and isLessThan, which are used in conditional branches.
	* MultDiv

		The 32-bit Multdiv unit executes multiplication and division instructions. The modified-booth multiplier takes 17 cycles to output a correct result while the divider takes 34 cycles. When the result is ready, the data_resultRDY flag will be set to one. At the same time, an exception flag that detects overflow in multiplication and division-by-zero in division will be outputted. 
	* Memory
	
		The memory system of the ECE 350 processor consists of two parts: instruction memory (imem) and data memory (dmem). Both of them are implemented using the altsynchram megafunction in Altera Quartus. Both of them are 12-bit addressed and the word size is 32 bits. The instruction memory has only a single read port while the data memory has one read port and one write port.

* Implementation Details
	
	The ECE 350 processor integrates stalling, flush logic and full bypassing to avoid hazards while maintain high performance. Since the pipeline is issuing in-order, only RAW data hazards need to be considered. 
	 When a load instruction is followed immediately by an instruction that depends on the load (except when the dependent instruction is a store that needs the value from the load), the processor stalls for a cycle. When stalling, PC register and instruction register between fetch and decode is set to not-writable. A noop is inserted into the execute stage.
    When there is a multdiv operation, the processor stalls until the dataRDY flag in the MultDiv unit is one. During multdiv stalls, the X/M registers hold their values so that the result could be written once the multdiv finish computing.
    The ECE 350 processor implements full bypassing: WX, MX and WM. The general logic is: whenever an instruction in Writeback or Memory writes to a register that instructions in Execute or Memory need, this data is bypassed. This logic is implemented using combinational circuits and MX, WX bypassed data is selected using multiplexers in Execute stage.