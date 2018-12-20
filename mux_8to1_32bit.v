module mux_8to1_32bit(i0, i1, i2, i3, i4, i5, i6, i7, s0, s1, s2, out);

	input [31:0] i0, i1, i2, i3, i4, i5, i6, i7;
	input s0, s1, s2;
	output [31:0] out;
	
	genvar i;
		generate
			for (i=0; i<32; i=i+1) begin: mux
				mux_8to1_1bit mux(i0[i], i1[i], i2[i], i3[i], i4[i], i5[i], i6[i], i7[i], s0, s1, s2, out[i]);
			end
		endgenerate
		
endmodule
	