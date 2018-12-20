module sra(in, amt, out);
	
	input [31:0] in;
	input [4:0] amt;
	output [31:0] out;
	
	wire [31:0] t0, t1, t2, t3, t4, t5, t6, t7, t8;
	
	shifter_right_16 sixteen(in, t0);
	genvar i0;
	generate
		for (i0=0;i0<32;i0=i0+1) begin: mux0
		 mux_2to1_1bit mux0(in[i0], t0[i0], amt[4], t1[i0]);
		end
	endgenerate
	
	
	//mux_2to1_32bit mux0(in, t0, amt[4], t1);
	
	shifter_right_8 eight(t1, t2);
	genvar i1;
	generate
		for (i1=0;i1<32;i1=i1+1) begin: mux1
		 mux_2to1_1bit mux1(t1[i1], t2[i1], amt[3], t3[i1]);
		end
	endgenerate
	//mux_2to1_32bit mux1(t1, t2, amt[3], t3);
	
	shifter_right_4 four(t3, t4);
	genvar i2;
	generate
		for (i2=0;i2<32;i2=i2+1) begin: mux2
		 mux_2to1_1bit mux2(t3[i2], t4[i2], amt[2], t5[i2]);
		end
	endgenerate
	//mux_2to1_32bit mux2(t3, t4, amt[2], t5);
	
	shifter_right_2 two(t5, t6);
	genvar i3;
	generate
		for (i3=0;i3<32;i3=i3+1) begin: mux3
		 mux_2to1_1bit mux3(t5[i3], t6[i3], amt[1], t7[i3]);
		end
	endgenerate
	//mux_2to1_32bit mux3(t5, t6, amt[1], t7);
	
	shifter_right_1 one(t7, t8);
	genvar i4;
	generate
		for (i4=0;i4<32;i4=i4+1) begin: mux4
		 mux_2to1_1bit mux4(t7[i4], t8[i4], amt[0], out[i4]);
		end
	endgenerate
	//mux_2to1_32bit mux4(t7, t8, amt[0], out);
	
endmodule

module shifter_right_1(in, out);
	input [31:0] in;
	output [31:0] out;
	
	genvar i;
	generate
		for (i=0; i<31; i=i+1) begin: mux0
			assign out[i] = in[i+1];
		end
	endgenerate
	
	genvar j;
	generate
		for (j=31; j<32; j=j+1) begin: mux1
			assign out[j] = in[31];
		end
	endgenerate
	
endmodule

module shifter_right_2(in, out);
	input [31:0] in;
	output [31:0] out;
	
	genvar i;
	generate
		for (i=0; i<30; i=i+1) begin: mux0
			assign out[i] = in[i+2];
		end
	endgenerate
	
	genvar j;
	generate
		for (j=30; j<32; j=j+1) begin: mux1
			assign out[j] = in[31];
		end
	endgenerate

endmodule

module shifter_right_4(in, out);
	input [31:0] in;
	output [31:0] out;
	
	genvar i;
	generate
		for (i=0; i<28; i=i+1) begin: mux0
			assign out[i] = in[i+4];
		end
	endgenerate
	
	genvar j;
	generate
		for (j=28; j<32; j=j+1) begin: mux1
			assign out[j] = in[31];
		end
	endgenerate

endmodule

module shifter_right_8(in, out);
	input [31:0] in;
	output [31:0] out;
	
	genvar i;
	generate
		for (i=0; i<24; i=i+1) begin: mux0
			assign out[i] = in[i+8];
		end
	endgenerate
	
	genvar j;
	generate
		for (j=24; j<32; j=j+1) begin: mux1
			assign out[j] = in[31];
		end
	endgenerate

endmodule

module shifter_right_16(in, out);
	input [31:0] in;
	output [31:0] out;
	
	genvar i;
	generate
		for (i=0; i<16; i=i+1) begin: mux0
			assign out[i] = in[i+16];
		end
	endgenerate
	
	genvar j;
	generate
		for (j=16; j<32; j=j+1) begin: mux1
			assign out[j] = in[31];
		end
	endgenerate

endmodule

module mux_2to1_1bit(a, b, sel, out);
	
	input a, b, sel;
	output out;
	
	wire nsel, t0, t1;
	not not0(nsel, sel);
	
	and and0(t0, nsel, a);
	and and1(t1, sel, b);
	or or0(out, t0, t1);
	
endmodule