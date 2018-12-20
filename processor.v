/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB                   // I: Data from port B of regfile

);
    // Control signals
    input clock, reset;

    // Imem
    output [11:0] address_imem;
    input [31:0] q_imem;

    // Dmem
    output [11:0] address_dmem;
    output [31:0] data;
    output wren;
    input [31:0] q_dmem;

    // Regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;

    // Fetch Stage
	 wire isBranch, isJump, isJR, isStall, isPCchange;
	 assign isPCchange = isBranch | isJump | isJR;
	 wire [31:0] pc_in, pc_in_jump, pc_out, pc_plus_one;
	 assign pc_in = (isPCchange) ? (pc_in_jump) : (pc_plus_one);
	 reg_32 prog_counter(.in(pc_in), .out(pc_out), .write_enable(~isStall), .clk(clock), .reset(reset));
	 
	 adder pc_adder(.x(pc_out), .y(32'd1), .sub(1'b0), .out(pc_plus_one));
	 
	 wire [31:0] inst_imem;
	 assign address_imem = pc_out[11:0];
	 assign inst_imem = q_imem;
	 
	 // F/D
	 wire [31:0] inst_decode, pc_decode, inst_fd_in;
	 assign inst_fd_in = (isPCchange) ? (32'b0) : (inst_imem);
	 reg_32 ir_fd(.in(inst_fd_in), .out(inst_decode), .write_enable(~isStall), .clk(clock), .reset(reset));
	 reg_32 pc_fd(.in(pc_plus_one), .out(pc_decode), .write_enable(1'b1), .clk(clock), .reset(reset));
	 
	 // Decode
	 wire [31:0] regfile_data_outA, regfile_data_outB;
	 assign regfile_data_outA = data_readRegA;
	 assign regfile_data_outB = data_readRegB;
	 
	 wire reg_readselA, reg_readselB_rt, reg_readselB_rd;
	 wire [1:0] reg_readselB;
	 wire [4:0] readRegA_rs_rt;
	 wire isBEX;
	 assign isBEX = inst_decode[31] & ~inst_decode[30] & inst_decode[29] & inst_decode[28] & ~inst_decode[27];
	 assign reg_readselA = 
		(~inst_decode[31] & ~inst_decode[30] & ~inst_decode[29] & ~inst_decode[28] & ~inst_decode[27]) |
		(~inst_decode[31] & ~inst_decode[30] & inst_decode[29] & ~inst_decode[28] & inst_decode[27]) |
		(~inst_decode[31] & inst_decode[30] & ~inst_decode[29] & ~inst_decode[28] & ~inst_decode[27]) |
		(~inst_decode[31] & ~inst_decode[30] & inst_decode[29] & inst_decode[28] & inst_decode[27]);
	 assign reg_readselB_rt = 
		(~inst_decode[31] & ~inst_decode[30] & ~inst_decode[29] & ~inst_decode[28] & ~inst_decode[27]);
	 assign reg_readselB_rd = 
		(~inst_decode[31] & ~inst_decode[30] & inst_decode[29] & inst_decode[28] & inst_decode[27]);
	 assign ctrl_readRegA = (isBEX) ? (5'd30) : (readRegA_rs_rt);
	 assign readRegA_rs_rt = (reg_readselA) ? (inst_decode[21:17]) : (inst_decode[26:22]);
	 assign reg_readselB[0] = ((~reg_readselB_rd) & (~reg_readselB_rt)) | isBEX;
	 assign reg_readselB[1] = reg_readselB_rt | isBEX;
	 
	 genvar m;
	 generate
		for (m=0; m<5; m=m+1) begin: rs2
			mux_4to1_1bit rs2_mux(.a(inst_decode[17+m]), .b(inst_decode[22+m]), .c(inst_decode[12+m]), .d(1'b0), .sel(reg_readselB), .out(ctrl_readRegB[m]));
		end
	 endgenerate
	 
	 wire isItype, isItype_branch, isItype_branch_decode, isItype_decode;
	 wire isExec_BEX, isDecode_BEX;
	 
	 assign isItype_branch_decode = 
		(~inst_decode[31] & ~inst_decode[30] & ~inst_decode[29] & inst_decode[28] & ~inst_decode[27]) |
		(~inst_decode[31] & ~inst_decode[30] & inst_decode[29] & inst_decode[28] & ~inst_decode[27]);
	 
	 assign isItype_decode = (~inst_decode[31] & ~inst_decode[30] & inst_decode[29] & ~inst_decode[28] & inst_decode[27]) |
		(~inst_decode[31] & ~inst_decode[30] & inst_decode[29] & inst_decode[28] & inst_decode[27]) |
		(~inst_decode[31] & inst_decode[30] & ~inst_decode[29] & ~inst_decode[28] & ~inst_decode[27]) |
		(~inst_decode[31] & ~inst_decode[30] & ~inst_decode[29] & inst_decode[28] & ~inst_decode[27]) |
		(~inst_decode[31] & ~inst_decode[30] & inst_decode[29] & inst_decode[28] & ~inst_decode[27]) |
		(inst_decode[31] & ~inst_decode[30] & inst_decode[29] & ~inst_decode[28] & inst_decode[27]);
	
	 assign isDecode_BEX = inst_decode[31] & ~inst_decode[30] & inst_decode[29] & inst_decode[28] & ~inst_decode[27];
	 
	 // D/X
	 wire [31:0] exec_data_inA, exec_data_inB;
	 wire [31:0] inst_exec;
	 wire [31:0] pc_exec;
	 wire [31:0] inst_dx_in;
	 assign inst_dx_in = (isStall | isPCchange) ? (32'b0) : (inst_decode);
	 reg_32 data_a(.in(regfile_data_outA), .out(exec_data_inA), .write_enable(1'b1), .clk(clock), .reset(reset));
	 reg_32 data_b(.in(regfile_data_outB), .out(exec_data_inB), .write_enable(1'b1), .clk(clock), .reset(reset));
	 reg_32 ir_dx(.in(inst_dx_in), .out(inst_exec), .write_enable(1'b1), .clk(clock), .reset(reset));
	 reg_32 pc_dx(.in(pc_decode), .out(pc_exec), .write_enable(1'b1), .clk(clock), .reset(reset));
	 dffe_ref dff_isItype_branch(isItype_branch, isItype_branch_decode, clock, 1'b1, reset);
	 dffe_ref dff_isItype(isItype, isItype_decode, clock, 1'b1, reset);
	 dffe_ref dff_isExec_BEX(isExec_BEX, isDecode_BEX, clock, 1'b1, reset);
	 
	 // Execute
	 wire [31:0] alu_data_inA, alu_data_inB;
	 wire [4:0] alu_opcode, alu_shiftamt, alu_opcode_itype;
	 wire [31:0] alu_result;
	 wire [31:0] imm_sx;
	 wire [31:0] offset_sx_ji;
	 wire FLAG_NE, FLAG_LT, FLAG_OVF_ALU;
	 alu alu_exec(.data_operandA(alu_data_inA), .data_operandB(alu_data_inB), 
	 .ctrl_ALUopcode(alu_opcode), .ctrl_shiftamt(alu_shiftamt), .data_result(alu_result), 
	 .isNotEqual(FLAG_NE), .isLessThan(FLAG_LT), .overflow(FLAG_OVF_ALU));
	 mux_2to1_5bit mux_aluopcode(inst_exec[6:2], alu_opcode_itype, isItype, alu_opcode);
	 mux_2to1_5bit mux_aluopcode_itype(5'b00000, 5'b00001, (isItype_branch | isExec_BEX), alu_opcode_itype);
	 assign alu_shiftamt = inst_exec[11:7];
	 assign imm_sx[31:17] = {15{inst_exec[16]}};
	 assign imm_sx[16:0] = inst_exec[16:0];
	 assign offset_sx_ji = {5'b0, inst_exec[26:0]};
	 
	 // Exception
	 wire isAdd, isSub, isADDI, isMult, isDiv, isArithmetic;
	 assign isArithmetic = ~inst_exec[31] & ~inst_exec[30] & ~inst_exec[29] & ~inst_exec[28] & ~inst_exec[27];
	 assign isAdd = (isArithmetic) & (~inst_exec[6] & ~inst_exec[5] & ~inst_exec[4] & ~inst_exec[3] & ~inst_exec[2]);
	 assign isSub = (isArithmetic) & (~inst_exec[6] & ~inst_exec[5] & ~inst_exec[4] & ~inst_exec[3] & inst_exec[2]);
	 assign isADDI = ~inst_exec[31] & ~inst_exec[30] & inst_exec[29] & ~inst_exec[28] & inst_exec[27];
	 
	 // MultDiv
	 wire FLAG_OVF_MULTDIV;
	 wire FLAG_RDY_MULTDIV;
	 wire [31:0] data_result_multdiv;
	 wire [31:0] exec_result;
	 assign isMult = (isArithmetic) &
		(~inst_exec[6] & ~inst_exec[5] & inst_exec[4] & inst_exec[3] & ~inst_exec[2]);
	 assign isDiv = (isArithmetic) &
		(~inst_exec[6] & ~inst_exec[5] & inst_exec[4] & inst_exec[3] & inst_exec[2]);
	 multdiv multdiv_unit(.data_operandA(alu_data_inA), .data_operandB(alu_data_inB), 
		.ctrl_MULT(isMult), .ctrl_DIV(isDiv), .clock(clock), .data_result(data_result_multdiv),
		.data_exception(FLAG_OVF_MULTDIV), .data_resultRDY(FLAG_RDY_MULTDIV));
	 assign exec_result = (FLAG_RDY_MULTDIV) ? (data_result_multdiv) : (alu_result);

	 wire isStall_multdiv;
	 wire isStall_multdiv_negated;
	 assign isStall_multdiv_negated = ~isStall_multdiv;
	 
	 dffe_ref multdiv_stall_signal(.q(isStall_multdiv), .d(isStall_multdiv_negated), .clk(clock), .en(isMult | isDiv | FLAG_RDY_MULTDIV), .clr(reset));
	 
	 wire [31:0] inst_exception;
	 wire [2:0] exception_sel;
	 assign exception_sel[0] = isADDI | isMult;
	 assign exception_sel[1] = isSub | isMult;
	 assign exception_sel[2] = isDiv;
	 mux_8to1_32bit mux_(32'b10101000000000000000000000000001, 32'b10101000000000000000000000000010, 32'b10101000000000000000000000000011, 32'b10101000000000000000000000000100, 32'b10101000000000000000000000000101, inst_exec, inst_exec, inst_exec, exception_sel[0], exception_sel[1], exception_sel[2], inst_exception);
	 
	 // branches resolve here
	 wire [31:0] pc_br_out;
	 adder br_add(.x(pc_exec), .y(imm_sx), .sub(1'b0), .out(pc_br_out));
	 assign isBranch = (~inst_exec[31] & ~inst_exec[30] & ~inst_exec[29] & inst_exec[28] & ~inst_exec[27] & FLAG_NE) |
		(~inst_exec[31] & ~inst_exec[30] & inst_exec[29] & inst_exec[28] & ~inst_exec[27] & FLAG_LT);
	 assign isJump = 
		(~inst_exec[31] & ~inst_exec[30] & ~inst_exec[29] & ~inst_exec[28] & inst_exec[27]) | 
		(~inst_exec[31] & ~inst_exec[30] & ~inst_exec[29] & inst_exec[28] & inst_exec[27]) |
		(isExec_BEX & FLAG_NE);
	 assign isJR = (~inst_exec[31] & ~inst_exec[30] & inst_exec[29] & ~inst_exec[28] & ~inst_exec[27]);
	 wire [1:0] pc_sel;
	 assign pc_sel[1] = isJump | isJR;
	 assign pc_sel[0] = isBranch | isJR;
	 
	 genvar i;
	 generate
		for (i=0; i<32; i=i+1) begin: pc
			mux_4to1_1bit pc_mux(.a(pc_exec[i]), .b(pc_br_out[i]), .c(offset_sx_ji[i]), .d(alu_data_inA[i]), .sel(pc_sel), .out(pc_in_jump[i]));
		end
	 endgenerate
	 
	 // X/M
	 
	 wire [31:0] exec_data_inB_bypass;
	 wire [31:0] mem_data_inA;
	 wire [31:0] mem_data_inB;
	 wire [31:0] inst_xm_in, inst_mem, pc_mem;
	 wire xm_wren;
	 assign xm_wren = ~isStall_multdiv | FLAG_RDY_MULTDIV;
	 assign inst_xm_in = (FLAG_OVF_ALU | FLAG_OVF_MULTDIV) ? (inst_exception) : (inst_exec);
	 reg_32 data_alu_out_xm(.in(exec_result), .out(mem_data_inA), .write_enable(xm_wren), .clk(clock), .reset(reset));
	 reg_32 data_b_xm(.in(exec_data_inB_bypass), .out(mem_data_inB), .write_enable(xm_wren), .clk(clock), .reset(reset));
	 reg_32 ir_xm(.in(inst_xm_in), .out(inst_mem), .write_enable(~isStall_multdiv), .clk(clock), .reset(reset));
	 reg_32 pc_xm(.in(pc_exec), .out(pc_mem), .write_enable(1'b1), .clk(clock), .reset(reset));
	 
	 // Memory
	 wire [31:0] dmem_data_out;
	 assign wren = ~inst_mem[31] & ~inst_mem[30] & inst_mem[29] & inst_mem[28] & inst_mem[27];
	 assign dmem_data_out = q_dmem;
	 assign address_dmem = mem_data_inA[11:0];
	 
	 // M/W
	 wire [31:0] wb_data_out, wb_data_in_mem, wb_data_in_exec;
	 wire [31:0] inst_wb, pc_wb;
	 wire isException;
	 reg_32 data_mem_out(.in(dmem_data_out), .out(wb_data_in_mem), .write_enable(1'b1), .clk(clock), .reset(reset));
	 reg_32 data_alu_out_mw(.in(mem_data_inA), .out(wb_data_in_exec), .write_enable(1'b1), .clk(clock), .reset(reset));
	 reg_32 ir_mw(.in(inst_mem), .out(inst_wb), .write_enable(1'b1), .clk(clock), .reset(reset));
	 reg_32 pc_mw(.in(pc_mem), .out(pc_wb), .write_enable(1'b1), .clk(clock), .reset(reset));
	 
	 // WM bypass
	 wire isWMbypass, isWBRegZero, isWB_reg_modifying;
	 wire [31:0] data_bypass_wb;
	 assign isWMbypass = 
		(isWB_reg_modifying) & (inst_mem[26:22] == inst_wb[26:22]);
	 assign isWBRegZero = (inst_wb[26:22] == 5'b0);
	 mux_2to1_32bit mux_data_bypass_wb(data_writeReg, 32'b0, isWBRegZero, data_bypass_wb);
	 mux_2to1_32bit mux_data_(mem_data_inB, data_bypass_wb, isWMbypass, data);
	 
	 // WX bypass
	 wire isWXbypassA, isWXbypassB;
	 assign isWB_reg_modifying = ((~inst_wb[31] & ~inst_wb[30] & ~inst_wb[29] & ~inst_wb[28] & ~inst_wb[27]) |
		(~inst_wb[31] & ~inst_wb[30] & inst_wb[29] & ~inst_wb[28] & inst_wb[27]) |
		(~inst_wb[31] & inst_wb[30] & ~inst_wb[29] & ~inst_wb[28] & ~inst_wb[27]) |
		(inst_wb[31] & ~inst_wb[30] & inst_wb[29] & ~inst_wb[28] & inst_wb[27]));
	 assign isWXbypassA = 
		((((~inst_exec[31] & ~inst_exec[30] & ~inst_exec[29] & ~inst_exec[28] & ~inst_exec[27]) |
		(~inst_exec[31] & ~inst_exec[30] & inst_exec[29] & ~inst_exec[28] & inst_exec[27]) |
		(~inst_exec[31] & ~inst_exec[30] & inst_exec[29] & inst_exec[28] & inst_exec[27]) |
		(~inst_exec[31] & inst_exec[30] & ~inst_exec[29] & ~inst_exec[28] & ~inst_exec[27])) 
		& (inst_wb[26:22] == inst_exec[21:17]))
		|
		(((~inst_exec[31] & ~inst_exec[30] & ~inst_exec[29] & inst_exec[28] & ~inst_exec[27]) |
		(~inst_exec[31] & ~inst_exec[30] & inst_exec[29] & inst_exec[28] & ~inst_exec[27]) |
		(~inst_exec[31] & ~inst_exec[30] & inst_exec[29] & ~inst_exec[28] & ~inst_exec[27])) 
		& (inst_wb[26:22] == inst_exec[26:22]))
		| 
		(inst_exec[31] & ~inst_exec[30] & inst_exec[29] & inst_exec[28] & ~inst_exec[27]))
		& (isWB_reg_modifying);
	 assign isWXbypassB = 
		(((~inst_exec[31] & ~inst_exec[30] & ~inst_exec[29] & ~inst_exec[28] & ~inst_exec[27])
		& (inst_wb[26:22] == inst_exec[16:12]))
		|
		((~inst_exec[31] & ~inst_exec[30] & inst_exec[29] & inst_exec[28] & inst_exec[27])
		& (inst_wb[26:22] == inst_exec[26:22]))
		|
		(((~inst_exec[31] & ~inst_exec[30] & ~inst_exec[29] & inst_exec[28] & ~inst_exec[27]) |
		(~inst_exec[31] & ~inst_exec[30] & inst_exec[29] & inst_exec[28] & ~inst_exec[27]))
		& (inst_wb[26:22] == inst_exec[21:17])))
		& (isWB_reg_modifying);
		
	 // MX bypass
	 wire isMXbypassA, isMXbypassB, isMEM_reg_modifying, isMemRegZero, isMemInstSetX;
	 wire [31:0] data_bypass_mem, data_bypass_mem_zerocheck, mem_data_setx;
	 assign mem_data_setx[31:27] = {5{inst_mem[26]}};
	 assign mem_data_setx[26:0] = inst_mem[26:0];
	 assign isMemInstSetX = inst_mem[31] & ~inst_mem[30] & inst_mem[29] & ~inst_mem[28] & inst_mem[27];
	 assign isMemRegZero = (inst_mem[26:22] == 5'b0) & (~isMemInstSetX);
	 mux_2to1_32bit mux_data_bypass_mem(data_bypass_mem_zerocheck, mem_data_setx, isMemInstSetX, data_bypass_mem);
	 mux_2to1_32bit mux_data_bypass_mem_zerocheck(mem_data_inA, 32'b0, isMemRegZero, data_bypass_mem_zerocheck);
	 assign isMEM_reg_modifying = ((~inst_mem[31] & ~inst_mem[30] & ~inst_mem[29] & ~inst_mem[28] & ~inst_mem[27]) |
		(~inst_mem[31] & ~inst_mem[30] & inst_mem[29] & ~inst_mem[28] & inst_mem[27]) |
		(~inst_mem[31] & inst_mem[30] & ~inst_mem[29] & ~inst_mem[28] & ~inst_mem[27]) |
		(isMemInstSetX));
	 assign isMXbypassA = 
		((((~inst_exec[31] & ~inst_exec[30] & ~inst_exec[29] & ~inst_exec[28] & ~inst_exec[27]) |
		(~inst_exec[31] & ~inst_exec[30] & inst_exec[29] & ~inst_exec[28] & inst_exec[27]) |
		(~inst_exec[31] & ~inst_exec[30] & inst_exec[29] & inst_exec[28] & inst_exec[27]) |
		(~inst_exec[31] & inst_exec[30] & ~inst_exec[29] & ~inst_exec[28] & ~inst_exec[27])) 
		& (inst_mem[26:22] == inst_exec[21:17]))
		|
		(((~inst_exec[31] & ~inst_exec[30] & ~inst_exec[29] & inst_exec[28] & ~inst_exec[27]) |
		(~inst_exec[31] & ~inst_exec[30] & inst_exec[29] & inst_exec[28] & ~inst_exec[27]) |
		(~inst_exec[31] & ~inst_exec[30] & inst_exec[29] & ~inst_exec[28] & ~inst_exec[27])) 
		& (inst_mem[26:22] == inst_exec[26:22]))
		|
		(inst_exec[31] & ~inst_exec[30] & inst_exec[29] & inst_exec[28] & ~inst_exec[27]))
		& (isMEM_reg_modifying);
	 assign isMXbypassB = 
		(((~inst_exec[31] & ~inst_exec[30] & ~inst_exec[29] & ~inst_exec[28] & ~inst_exec[27])
		& (inst_mem[26:22] == inst_exec[16:12]))
		|
		((~inst_exec[31] & ~inst_exec[30] & inst_exec[29] & inst_exec[28] & inst_exec[27])
		& (inst_mem[26:22] == inst_exec[26:22]))
		|
		(((~inst_exec[31] & ~inst_exec[30] & ~inst_exec[29] & inst_exec[28] & ~inst_exec[27]) |
		(~inst_exec[31] & ~inst_exec[30] & inst_exec[29] & inst_exec[28] & ~inst_exec[27]))
		& (inst_mem[26:22] == inst_exec[21:17])))
		& (isMEM_reg_modifying);
	
	 // ALUinA select
	 wire [1:0] ALUinA_sel;
	 assign ALUinA_sel[0] = isWXbypassA;
	 assign ALUinA_sel[1] = isMXbypassA;
	 
	 genvar a;
	 generate
		for (a=0; a<32; a=a+1) begin: aluina
			mux_4to1_1bit aluina_mux(.a(exec_data_inA[a]), .b(data_bypass_wb[a]), .c(data_bypass_mem[a]), .d(data_bypass_mem[a]), .sel(ALUinA_sel), .out(alu_data_inA[a]));
		end
	 endgenerate 
	 
	 // ALUinB select
	 wire [1:0] ALUinB_sel;
	 assign ALUinB_sel[0] = isWXbypassB;
	 assign ALUinB_sel[1] = isMXbypassB;
	 
	 genvar b;
	 generate
		for (b=0; b<32; b=b+1) begin: aluinb
			mux_4to1_1bit aluinb_mux(.a(exec_data_inB[b]), .b(data_bypass_wb[b]), .c(data_bypass_mem[b]), .d(data_bypass_mem[b]), .sel(ALUinB_sel), .out(exec_data_inB_bypass[b]));
		end
	 endgenerate
	 mux_2to1_32bit mux_alu_data_inB(exec_data_inB_bypass, imm_sx, isItype & (~isItype_branch), alu_data_inB);
		
	 // Write Back
	 wire [4:0] writeReg_jalcheck;
	 wire isWBinst_jal;
	 wire [31:0] wb_data_setx;
	 wire [31:0] wb_data_out_jal_check;
	 assign wb_data_setx[31:27] = {5{inst_wb[26]}};
	 assign wb_data_setx[26:0] = inst_wb[26:0];
	 assign isWBinst_jal = (~inst_wb[31] & ~inst_wb[30] & ~inst_wb[29] & inst_wb[28] & inst_wb[27]);
	 wire isMem, isSetX;
	 assign isSetX = (inst_wb[31] & ~inst_wb[30] & inst_wb[29] & ~inst_wb[28] & inst_wb[27]);
	 mux_2to1_32bit mux_data_writeReg(wb_data_out_jal_check, wb_data_setx, isSetX, data_writeReg);
	 mux_2to1_32bit mux_wb_data_out_jal_check(wb_data_out, pc_wb, isWBinst_jal, wb_data_out_jal_check);
	 mux_2to1_32bit mux_wb_data_out(wb_data_in_exec, wb_data_in_mem, isMem, wb_data_out);
	 assign ctrl_writeEnable = (~inst_wb[31] & ~inst_wb[30] & ~inst_wb[29] & ~inst_wb[28] & ~inst_wb[27]) | 
		(~inst_wb[31] & ~inst_wb[30] & inst_wb[29] & ~inst_wb[28] & inst_wb[27]) | 
		(~inst_wb[31] & inst_wb[30] & ~inst_wb[29] & ~inst_wb[28] & ~inst_wb[27]) | 
		(~inst_wb[31] & ~inst_wb[30] & ~inst_wb[29] & inst_wb[28] & inst_wb[27]) |
		(inst_wb[31] & ~inst_wb[30] & inst_wb[29] & ~inst_wb[28] & inst_wb[27]);
	 assign isMem = ~inst_wb[31] & inst_wb[30] & ~inst_wb[29] & ~inst_wb[28] & ~inst_wb[27]; 
	 mux_2to1_32bit mux_ctrl_writeReg(writeReg_jalcheck, 5'd30, isSetX, ctrl_writeReg);
	 mux_2to1_32bit mux_writeReg_jalcheck(inst_wb[26:22], 5'd31, isWBinst_jal, writeReg_jalcheck);
	 
	 // Stall
	 assign isStall = (inst_exec[31:27] == 5'b01000) & 
		((ctrl_readRegA == inst_exec[26:22]) | 
		((ctrl_readRegB == inst_exec[26:22]) & (inst_decode[31:27] != 5'b00111)))
		| (isStall_multdiv & ~FLAG_RDY_MULTDIV)
		| ((isMult | isDiv) & (~FLAG_RDY_MULTDIV));
	
endmodule
