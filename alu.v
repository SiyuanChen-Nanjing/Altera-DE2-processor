module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);

   input [31:0] data_operandA, data_operandB;
   input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

   output [31:0] data_result;
   output isNotEqual, isLessThan, overflow;

   wire [31:0] out0, out1, out2, out3, out4, out5;

	genvar z;
	wire [31:0] equal_bitwise;
	generate
			for (z=0; z<32; z=z+1) begin: equal_check
				xor isnotequal_bit(equal_bitwise[z], data_operandA[z], data_operandB[z]);
			end
	endgenerate
	
	or zero(isNotEqual, equal_bitwise[0], equal_bitwise[1], equal_bitwise[2], equal_bitwise[3], equal_bitwise[4], equal_bitwise[5], equal_bitwise[6], equal_bitwise[7], equal_bitwise[8], equal_bitwise[9],
	equal_bitwise[10], equal_bitwise[11], equal_bitwise[12], equal_bitwise[13], equal_bitwise[14], equal_bitwise[15], equal_bitwise[16], equal_bitwise[17], equal_bitwise[18], equal_bitwise[19],
	equal_bitwise[20], equal_bitwise[21], equal_bitwise[22], equal_bitwise[23], equal_bitwise[24], equal_bitwise[25], equal_bitwise[26], equal_bitwise[27], equal_bitwise[28], equal_bitwise[29],
	equal_bitwise[30], equal_bitwise[31]);
	
	adder adder0(.x(data_operandA), .y(data_operandB), .sub(ctrl_ALUopcode[0]), .out(out0));
	
	wire [31:0] nB;
	genvar k;
	generate
		for (k=0;k<32;k=k+1) begin: invert
			not invertB(nB[k], data_operandB[k]);
		end
	endgenerate
	
	adder suber1(.x(data_operandA), .y(nB), .sub(ctrl_ALUopcode[0]), .out(out1));
	
	wire ov_add, ov_sub;
	
	wire nA_MSB, nB_MSB, nAdd_MSB, nSub_MSB;
	not not0(nA_MSB, data_operandA[31]);
	not not1(nB_MSB, data_operandB[31]);
	not not2(nAdd_MSB, out0[31]);
	not not3(nSub_MSB, out1[31]);
	
	wire t0, t1, t2, t3;
	and and0(t0, nA_MSB, nB_MSB, out0[31]);
	and and1(t1, data_operandA[31], data_operandB[31], nAdd_MSB);
	or or0(ov_add, t0, t1);
	
	and and2(t2, nA_MSB, data_operandB[31], out1[31]);
	and and3(t3, data_operandA[31], nB_MSB, nSub_MSB);
	or or1(ov_sub, t2, t3);
	
	mux_2to1_1bit mux_carry(ov_add, ov_sub, ctrl_ALUopcode[0], overflow);
	
	genvar i;
	generate
		for (i=0; i<32; i=i+1) begin: bitwise_and
			and and_bit(out2[i], data_operandA[i], data_operandB[i]);
		end
	endgenerate
	
	genvar j;
	generate
		for (j=0; j<32; j=j+1) begin: bitwise_or
			or or_bit(out3[j], data_operandA[j], data_operandB[j]);
		end
	endgenerate
	
	sll sll4(.in(data_operandA), .amt(ctrl_shiftamt), .out(out4));
	
	sra sra5(.in(data_operandA), .amt(ctrl_shiftamt), .out(out5));
	
	genvar m;
	generate
			for (m=0; m<32; m=m+1) begin: mux
				mux_8to1_1bit mux(out0[m], out1[m], out2[m], out3[m], out4[m], out5[m], 1'b0, 1'b0, ctrl_ALUopcode[0], ctrl_ALUopcode[1], ctrl_ALUopcode[2], data_result[m]);
			end
	endgenerate
	
	/*
	wire z0, z1, z2, z3;
	or zero0(z0, data_result[0], data_result[1], data_result[2], data_result[3], data_result[4], data_result[5], data_result[6], data_result[7]);
	or zero1(z1, data_result[8], data_result[9], data_result[10], data_result[11], data_result[12], data_result[13], data_result[14], data_result[15]);
	or zero2(z2, data_result[16], data_result[17], data_result[18], data_result[19], data_result[20], data_result[21], data_result[22], data_result[23]);
	or zero3(z3, data_result[24], data_result[25], data_result[26], data_result[27], data_result[28], data_result[29], data_result[30], data_result[31]);
	or zero4(isNotEqual, z0, z1, z2, z3);
	*/
	wire overflow_flipped, p0, p1;
	not flip(overflow_flipped, overflow);
	and and_less0(p0, data_result[31], overflow_flipped);
	and and_less1(p1, data_operandA[31], nB_MSB, overflow);
	or neg(isLessThan, p0, p1);
	
endmodule

module mux_8to1_1bit(i0, i1, i2, i3, i4, i5, i6, i7, s0, s1, s2, out);
	
	input i0, i1, i2, i3, i4, i5, i6, i7, s0, s1, s2;
	output out;
	
	//wire t0, t1, t2, t3, t4, t5;
	
	wire ns0, ns1, ns2;
	not not0(ns0, s0);
	not not1(ns1, s1);
	not not2(ns2, s2);
	
	wire t0, t1, t2, t3, t4, t5, t6, t7;
	and and0(t0, i0, ns0, ns1, ns2);
	and and1(t1, i1, s0, ns1, ns2);
	and and2(t2, i2, ns0, s1, ns2);
	and and3(t3, i3, s0, s1, ns2);
	and and4(t4, i4, ns0, ns1, s2);
	and and5(t5, i5, s0, ns1, s2);
	and and6(t6, i6, ns0, s1, s2);
	and and7(t7, i7, s0, s1, s2);
	
	or or0(out, t0, t1, t2, t3, t4, t5, t6, t7);
	
endmodule