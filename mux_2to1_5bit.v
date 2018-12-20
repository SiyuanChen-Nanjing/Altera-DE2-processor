module mux_2to1_5bit(a, b, sel, out);
	
	input [4:0] a, b;
	input sel;
	output [4:0] out;
	
	genvar i;
	generate
		for (i=0; i<5; i=i+1) begin: mux_5
			mux_2to1_1bit mux_bitwise(.a(a[i]), .b(b[i]), .sel(sel), .out(out[i]));
		end
	endgenerate

endmodule