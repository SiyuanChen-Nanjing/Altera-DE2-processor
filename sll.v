module sll(in, amt, out);
	
	input [31:0] in;
	input [4:0] amt;
	output [31:0] out;
	
	wire [31:0] t0, t1, t2, t3, t4, t5, t6, t7, t8;
	
	shifter_left_16 sixteen(in, t0);
	genvar i0;
	generate
		for (i0=0;i0<32;i0=i0+1) begin: mux0
		 mux_2to1_1bit mux0(in[i0], t0[i0], amt[4], t1[i0]);
		end
	endgenerate
	
	
	//mux_2to1_32bit mux0(in, t0, amt[4], t1);
	
	shifter_left_8 eight(t1, t2);
	genvar i1;
	generate
		for (i1=0;i1<32;i1=i1+1) begin: mux1
		 mux_2to1_1bit mux1(t1[i1], t2[i1], amt[3], t3[i1]);
		end
	endgenerate
	//mux_2to1_32bit mux1(t1, t2, amt[3], t3);
	
	shifter_left_4 four(t3, t4);
	genvar i2;
	generate
		for (i2=0;i2<32;i2=i2+1) begin: mux2
		 mux_2to1_1bit mux2(t3[i2], t4[i2], amt[2], t5[i2]);
		end
	endgenerate
	//mux_2to1_32bit mux2(t3, t4, amt[2], t5);
	
	shifter_left_2 two(t5, t6);
	genvar i3;
	generate
		for (i3=0;i3<32;i3=i3+1) begin: mux3
		 mux_2to1_1bit mux3(t5[i3], t6[i3], amt[1], t7[i3]);
		end
	endgenerate
	//mux_2to1_32bit mux3(t5, t6, amt[1], t7);
	
	shifter_left_1 one(t7, t8);
	genvar i4;
	generate
		for (i4=0;i4<32;i4=i4+1) begin: mux4
		 mux_2to1_1bit mux4(t7[i4], t8[i4], amt[0], out[i4]);
		end
	endgenerate
	//mux_2to1_32bit mux4(t7, t8, amt[0], out);
	
endmodule

module shifter_left_1(in, out);

	input [31:0] in;
	output [31:0] out;
	
	genvar i;
	generate
		for (i=0;i<1;i=i+1) begin: zero
			and and0(out[i], 1'b0, 1'b0);
		end
	endgenerate
	
	genvar j;
	generate
		for (j=1;j<32;j=j+1) begin: other
			and and1(out[j], 1'b1, in[j-1]);
		end
	endgenerate

endmodule

module shifter_left_2(in, out);

	input [31:0] in;
	output [31:0] out;
	
	genvar i;
	generate
		for (i=0;i<2;i=i+1) begin: zero
			and and0(out[i], 1'b0, 1'b0);
		end
	endgenerate
	
	genvar j;
	generate
		for (j=2;j<32;j=j+1) begin: other
			and and1(out[j], 1'b1, in[j-2]);
		end
	endgenerate

endmodule

module shifter_left_4(in, out);

	input [31:0] in;
	output [31:0] out;
	
	genvar i;
	generate
		for (i=0;i<4;i=i+1) begin: zero
			and and0(out[i], 1'b0, 1'b0);
		end
	endgenerate
	
	genvar j;
	generate
		for (j=4;j<32;j=j+1) begin: other
			and and1(out[j], 1'b1, in[j-4]);
		end
	endgenerate

endmodule

module shifter_left_8(in, out);

	input [31:0] in;
	output [31:0] out;
	
	genvar i;
	generate
		for (i=0;i<8;i=i+1) begin: zero
			and and0(out[i], 1'b0, 1'b0);
		end
	endgenerate
	
	genvar j;
	generate
		for (j=8;j<32;j=j+1) begin: other
			and and1(out[j], 1'b1, in[j-8]);
		end
	endgenerate

endmodule

module shifter_left_16(in, out);

	input [31:0] in;
	output [31:0] out;
	
	genvar i;
	generate
		for (i=0;i<16;i=i+1) begin: zero
			and and0(out[i], 1'b0, 1'b0);
		end
	endgenerate
		
	genvar j;
	generate
		for (j=16;j<32;j=j+1) begin: other
			and and1(out[j], 1'b1, in[j-16]);
		end
	endgenerate

endmodule