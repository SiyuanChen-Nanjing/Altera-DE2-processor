module multdiv(data_operandA, data_operandB, ctrl_MULT, ctrl_DIV, clock, data_result, data_exception, data_resultRDY);
    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

	 wire isMult;
	 wire isDiv;
	 dffe_ref isMult_dff(.q(isMult), .d(ctrl_MULT), .clk(clock), .en(ctrl_MULT | ctrl_DIV), .clr(1'b0));
	 dffe_ref isDiv_dff(.q(isDiv), .d(ctrl_DIV), .clk(clock), .en(ctrl_MULT | ctrl_DIV));
	 
	 wire ovf, zero, mult_rdy, div_rdy, isDivByZero;
	 dffe_ref zero_dff(.q(isDivByZero), .d(zero), .clk(clock), .en(ctrl_DIV));
	 
	 nor isZero(zero, data_operandB[0], data_operandB[1], data_operandB[2], data_operandB[3], data_operandB[4], data_operandB[5], data_operandB[6], data_operandB[7], data_operandB[8], data_operandB[9],
	 data_operandB[10], data_operandB[11], data_operandB[12], data_operandB[13], data_operandB[4], data_operandB[15], data_operandB[16], data_operandB[17], data_operandB[18], data_operandB[19],
	 data_operandB[20], data_operandB[21], data_operandB[22], data_operandB[23], data_operandB[24], data_operandB[25], data_operandB[26], data_operandB[27], data_operandB[28], data_operandB[29],
	 data_operandB[30], data_operandB[31]);
	 
	 wire [31:0] mult_result, div_result_pos;
	 multiplier mult(.multplcd(data_operandA), .multplr(data_operandB), .start(ctrl_MULT), .clk(clock), .F_READY(mult_rdy), .overflow(ovf), .result(mult_result));
	
	 wire [31:0] data_operandA_div, data_operandB_div, data_operandA_neg, data_operandB_neg;
	 negater neg_A(data_operandA, data_operandA_neg);
	 negater neg_B(data_operandB, data_operandB_neg);
	 mux_2to1_32bit mux_div_A(.a(data_operandA), .b(data_operandA_neg), .sel(data_operandA[31]), .out(data_operandA_div));
	 mux_2to1_32bit mux_div_B(.a(data_operandB), .b(data_operandB_neg), .sel(data_operandB[31]), .out(data_operandB_div));
	 
	 divider div(.divisor(data_operandB_div), .dividend(data_operandA_div), .start(ctrl_DIV), .clk(clock), .F_READY(div_rdy), .result(div_result_pos));
	 wire [31:0] div_result_neg, div_result, div_result_final;
	 negater neg_div_result(div_result_pos, div_result_neg);
	 wire div_result_sign, div_result_sign_final;
	 xor div_sign(div_result_sign, data_operandA[31], data_operandB[31]);
	 dffe_ref div_sign_dff(.q(div_result_sign_final), .d(div_result_sign), .clk(clock), .en(ctrl_DIV));
	 mux_2to1_32bit mux_div_res(.a(div_result_pos), .b(div_result_neg), .sel(div_result_sign_final), .out(div_result));
	 mux_2to1_32bit mux_div_res_zero(.a(div_result), .b(32'b0), .sel(isDivByZero), .out(div_result_final));

	 wire data_resultRDY_intermediate;
	 mux_2to1_32bit mux_result(.a(div_result_final), .b(mult_result), .sel(isMult), .out(data_result));
	 mux_2to1_1bit mux_rdy(.a(div_rdy), .b(mult_rdy), .sel(isMult), .out(data_resultRDY_intermediate));
	 assign data_resultRDY = (isMult | isDiv) ? (data_resultRDY_intermediate) : (1'b0);
	 assign data_exception = (isMult & ovf) | (isDiv & zero);
	 
endmodule

module mux_2to1_32bit(a, b, sel, out);
	
	input [31:0] a, b;
	input sel;
	output [31:0] out;
	
	genvar i;
	generate
		for (i=0; i<32; i=i+1) begin: mux_32
			mux_2to1_1bit mux_bitwise(.a(a[i]), .b(b[i]), .sel(sel), .out(out[i]));
		end
	endgenerate

endmodule

module multiplier(multplcd, multplr, start, clk, F_READY, overflow, result);
	
	input [31:0] multplcd, multplr;
	input start, clk;
	output F_READY, overflow;
	output [31:0] result;
	
	wire [31:0] wprod_1_in_after_mux;
	wire [31:0] wprod_2_in_beforeshift;
	wire [31:0] wprod_1_in, wprod_2_in;
	wire [31:0] wprod_1_out, wprod_2_out;
	
	// read in the values
	wire [31:0] multplcd_readout;
	reg_32 multplcd_readin(.in(multplcd), .out(multplcd_readout), .write_enable(start), .clk(clk), .reset(1'b0));
	
	wire same_sign;
	dffe_ref ovf_shift_same_sign(.q(same_sign), .d((multplcd[31] & multplr[31]) | ((~multplcd[31]) & (~multplr[31]))), .clk(clk), .en(start), .clr(1'b0));
	
	wire isZero_multiplicand, isZero_multiplier;
	wire isZero_multiplicand_in, isZero_multiplier_in;
	
	nor zero_cand(isZero_multiplicand_in, multplcd[0], multplcd[1], multplcd[2], multplcd[3], multplcd[4], multplcd[5], multplcd[6], multplcd[7], multplcd[8], multplcd[9],
	 multplcd[10], multplcd[11], multplcd[12], multplcd[13], multplcd[4], multplcd[15], multplcd[16], multplcd[17], multplcd[18], multplcd[19],
	 multplcd[20], multplcd[21], multplcd[22], multplcd[23], multplcd[24], multplcd[25], multplcd[26], multplcd[27], multplcd[28], multplcd[29],
	 multplcd[30], multplcd[31]);
	 
	 nor zero_plier(isZero_multiplier_in, multplr[0], multplr[1], multplr[2], multplr[3], multplr[4], multplr[5], multplr[6], multplr[7], multplr[8], multplr[9],
	 multplr[10], multplr[11], multplr[12], multplr[13], multplr[4], multplr[15], multplr[16], multplr[17], multplr[18], multplr[19],
	 multplr[20], multplr[21], multplr[22], multplr[23], multplr[24], multplr[25], multplr[26], multplr[27], multplr[28], multplr[29],
	 multplr[30], multplr[31]);
	 
	 dffe_ref zero_dff_cand(.q(isZero_multiplicand), .d(isZero_multiplicand_in), .clk(clk), .en(start), .clr(1'b0));
	 dffe_ref zero_dff_lier(.q(isZero_multiplier), .d(isZero_multiplier_in), .clk(clk), .en(start), .clr(1'b0));
	
	// choose between initial value and intermediate value
	// wire [31:0] wprod_1_in_after_mux;
	mux_2to1_32bit mux_readin(.a(wprod_1_in), .b(multplr), .sel(start), .out(wprod_1_in_after_mux));
	
	reg_32 product_1(.in(wprod_1_in_after_mux), .out(wprod_1_out), .write_enable(1'b1), .clk(clk), .reset(1'b0));
	reg_32 product_2(.in(wprod_2_in), .out(wprod_2_out), .write_enable(1'b1), .clk(clk), .reset(start));
	
	wire isShift;
	
	wire signed [31:0] wmultiplcd, wmultiplcd_shifted;
	assign wmultiplcd = multplcd_readout;
	assign wmultiplcd_shifted = multplcd_readout<<1;
	
	wire overflow_shift, overflow_shift_temp;
	dffe_ref ovf_shift_dff(.q(overflow_shift), .d(1'b1), .clk(clk), .en(overflow_shift_temp), .clr(start));
	assign overflow_shift_temp = isShift & ((wmultiplcd[31] & (~wmultiplcd_shifted[31])) | ((~wmultiplcd[31]) & wmultiplcd_shifted[31]));
	
	// choose between multiplicand and shifted multiplicand
	wire [31:0] addsub_operand1_pos;

	mux_2to1_32bit mux_shift_multiplcd(.a(wmultiplcd), .b(wmultiplcd_shifted), .sel(isShift), .out(addsub_operand1_pos));
	
	// choose between neg and pos operand
	wire [31:0] addsub_operand1_neg, addsub_operand1;
	wire isSub;
	assign addsub_operand1_neg = ~addsub_operand1_pos;
	mux_2to1_32bit mux_sign(.a(addsub_operand1_pos), .b(addsub_operand1_neg), .sel(isSub), .out(addsub_operand1));
	
	// add/sub
	wire [31:0] addsub_result;
	adder addsub(.x(wprod_2_out), .y(addsub_operand1), .sub(isSub), .out(addsub_result));
	
	wire overflow_addsub, overflow_addsub_temp;
	dffe_ref ovf_addsub_dff(.q(overflow_addsub), .d(1'b1), .clk(clk), .en(overflow_addsub_temp), .clr(start));
	
	// choose between addsub and unchanged result
	wire isUnChange;
	mux_2to1_32bit mux_change(.a(addsub_result), .b(wprod_2_out), .sel(isUnChange), .out(wprod_2_in_beforeshift));

	assign overflow_addsub_temp = (~isUnChange) & ((isSub & (((~wprod_2_out[31]) & addsub_operand1_pos[31] & addsub_result[31]) | (wprod_2_out[31] & (~addsub_operand1_pos[31]) & (~addsub_result[31])))) |
	((~isSub) & (((~wprod_2_out[31]) & (~addsub_operand1_pos[31]) & addsub_result[31]) | (wprod_2_out[31] & addsub_operand1_pos[31] & (~addsub_result[31])))));
	
	wire isZero_result;
	 nor zero_result(isZero_result, result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7], result[8], result[9],
	 result[10], result[11], result[12], result[13], result[4], result[15], result[16], result[17], result[18], result[19],
	 result[20], result[21], result[22], result[23], result[24], result[25], result[26], result[27], result[28], result[29],
	 result[30], result[31]);
	
	assign overflow = overflow_addsub | overflow_shift | (((same_sign & result[31] & F_READY) | ((~same_sign) & (~result[31]) & F_READY)) & (~isZero_multiplicand) & (~isZero_multiplier)) | (same_sign & (multplcd_readout[31]) & isZero_result & F_READY) ;
	
	// shift
	wire signed [63:0] beforeshift, aftershift;
	assign beforeshift[31:0] = wprod_1_out;
	assign beforeshift[63:32] = wprod_2_in_beforeshift;
	assign aftershift = beforeshift>>>2;
	assign wprod_1_in = aftershift[31:0];
	assign wprod_2_in = aftershift[63:32];
	
	// control
	wire bit1, bit0;
	wire helper;
	dffe_ref helper_bit(.q(helper), .d(wprod_1_out[1]), .clk(clk), .en(1'b1), .clr(start));
	assign bit1 = wprod_1_out[1];
	assign bit0 = wprod_1_out[0];
	
	assign isUnChange = ((~bit1) & (~bit0) & (~helper)) | (bit1 & bit0 & helper);
	assign isSub = (bit1) & (((~bit0) & (~helper)) | ((bit0) & (~helper)) | ((~bit0) & (helper)));
	assign isShift = ((bit1) & (~bit0) & (~helper)) | ((~bit1) & (bit0) & (helper));
	
	// counter
	counter_5 counter(.reset(start), .clk(clk), .F_READY(F_READY));
	assign result = wprod_1_out;
	
endmodule

module divider(divisor, dividend, start, clk, F_READY, result);
	
	input [31:0] divisor, dividend;
	input start, clk;
	output F_READY;
	output [31:0] result;
	
	
	wire [31:0] divisor_readout;
	// read in the values, assume positive here
	
	// read in divisor
	reg_32 divisor_readin(.in(divisor), .out(divisor_readout), .write_enable(start), .clk(clk), .reset(1'b0));
	
	// read in dividend
	wire [31:0] quotient_in_imm, quotient_in, quotient_out, remainder_in;
	wire [31:0] remainder_out;
	mux_2to1_32bit mux_initialize_dividend(.a(quotient_in_imm), .b(dividend), .sel(start), .out(quotient_in));
	reg_32 quotient(.in(quotient_in), .out(quotient_out), .write_enable(1'b1), .clk(clk), .reset(1'b0));
	reg_32 remainder(.in(remainder_in), .out(remainder_out), .write_enable(1'b1), .clk(clk), .reset(start));
	
	// sub
	wire [31:0] sub_operand2, sub_result, remainder_before_shift;
	assign sub_operand2 = ~divisor_readout;
	adder subtractor(.x(remainder_out), .y(sub_operand2), .sub(1'b1), .out(sub_result));
	
	mux_2to1_32bit mux_sub(.a(sub_result), .b(remainder_out), .sel(sub_result[31]), .out(remainder_before_shift));
	
	wire [63:0] remainder_reg_before_shift, remainder_reg_after_shift;
	assign remainder_reg_before_shift[63:32] = remainder_before_shift;
	assign remainder_reg_before_shift[31:0] = quotient_out;
	assign remainder_reg_after_shift = remainder_reg_before_shift<<1;
	assign remainder_in = remainder_reg_after_shift[63:32];
	assign quotient_in_imm[31:1] = remainder_reg_after_shift[31:1];
	assign quotient_in_imm[0] = ~sub_result[31];
	
	assign result = quotient_out;
	
	counter_6 counter(.reset(start), .clk(clk), .F_READY(F_READY));
	
endmodule

module counter_5(reset, clk, F_READY);
	
	input reset, clk;
	output F_READY;
	
	wire q0;
	wire nq0;
	not not0(nq0, q0);
	dffe_ref dff0(.q(q0), .d(nq0), .clk(clk), .en(1'b1), .clr(reset));
	
	wire q1;
	wire nq1;
	not not1(nq1, q1);
	dffe_ref dff1(.q(q1), .d(nq1), .clk(nq0), .en(1'b1), .clr(reset));
	
	wire q2;
	wire nq2;
	not not2(nq2, q2);
	dffe_ref dff2(.q(q2), .d(nq2), .clk(nq1), .en(1'b1), .clr(reset));
	
	wire q3;
	wire nq3;
	not not3(nq3, q3);
	dffe_ref dff3(.q(q3), .d(nq3), .clk(nq2), .en(1'b1), .clr(reset));
	
	wire q4;
	wire nq4;
	not not4(nq4, q4);
	dffe_ref dff4(.q(q4), .d(nq4), .clk(nq3), .en(1'b1), .clr(reset));
	
	and res(F_READY, ~q0, ~q1, ~q2, ~q3, q4);

endmodule

module counter_6(reset, clk, F_READY);
	
	input reset, clk;
	output F_READY;
	
	wire q0;
	wire nq0;
	not not0(nq0, q0);
	dffe_ref dff0(.q(q0), .d(nq0), .clk(clk), .en(1'b1), .clr(reset));
	
	wire q1;
	wire nq1;
	not not1(nq1, q1);
	dffe_ref dff1(.q(q1), .d(nq1), .clk(nq0), .en(1'b1), .clr(reset));
	
	wire q2;
	wire nq2;
	not not2(nq2, q2);
	dffe_ref dff2(.q(q2), .d(nq2), .clk(nq1), .en(1'b1), .clr(reset));
	
	wire q3;
	wire nq3;
	not not3(nq3, q3);
	dffe_ref dff3(.q(q3), .d(nq3), .clk(nq2), .en(1'b1), .clr(reset));
	
	wire q4;
	wire nq4;
	not not4(nq4, q4);
	dffe_ref dff4(.q(q4), .d(nq4), .clk(nq3), .en(1'b1), .clr(reset));
	
	wire q5;
	wire nq5;
	not not5(nq5, q5);
	dffe_ref dff5(.q(q5), .d(nq5), .clk(nq4), .en(1'b1), .clr(reset));
	
	and res(F_READY, q0, ~q1, ~q2, ~q3, ~q4, q5);

endmodule

module negater(in, out);

	input [31:0] in;
	output [31:0] out;
	
	adder negate(.x(~in), .y(32'b1), .out(out), .sub(1'b0));

endmodule