module adder(x, y, sub, out);

	input [31:0] x, y;
	input sub;
	output [31:0] out;

	wire c16;
	
	csa_16bit csa0(.x(x[15:0]), .y(y[15:0]), .cin(sub), .s(out[15:0]), .cout(c16));
	
	wire [15:0] t0, t1;
	wire p0, p1;
	csa_16bit csa1(.x(x[31:16]), .y(y[31:16]), .cin(1'b0), .s(t0), .cout(p0));
	csa_16bit csa2(.x(x[31:16]), .y(y[31:16]), .cin(1'b1), .s(t1), .cout(p1));
	
	genvar i;
	generate
		for (i=0; i<16; i=i+1) begin: mux
			mux_2to1_1bit mux1(t0[i], t1[i], c16, out[i+16]);
		end
	endgenerate

endmodule

module csa_16bit(x, y, cin, cout, s);

	input [15:0] x,y;
	output [15:0] s;
	input cin;
	output cout;


	wire c8;
	
	cla_8_bit cla0(.x(x[7:0]), .y(y[7:0]), .cin(cin), .s(s[7:0]), .cout(c8));
	
	wire [7:0] t0, t1;
	wire p0, p1;
	cla_8_bit cla1(.x(x[15:8]), .y(y[15:8]), .cin(1'b0), .s(t0), .cout(p0));
	cla_8_bit cla2(.x(x[15:8]), .y(y[15:8]), .cin(1'b1), .s(t1), .cout(p1));
	
	mux_2to1_1bit mux0(p0, p1, c8, cout);
	
	genvar i;
	generate
		for (i=0; i<8; i=i+1) begin: mux
			mux_2to1_1bit mux1(t0[i], t1[i], c8, s[i+8]);
		end
	endgenerate


endmodule

module cla_8_bit(x, y, cin, s, cout);

	input [7:0] x, y;
	input cin;
	output [7:0] s;
	output cout;
	
	wire p0, p1, p2, p3, p4, p5, p6, p7, g0, g1, g2, g3, g4, g5, g6, g7, c1, c2, c3, c4, c5, c6, c7;
	
	wire t0, t1, t2, t3, t4, t5, t6, t7, t8, t9, t10, t11, t12, t13, t14, t15, t16, t17,
		t18, t19, t20, t21, t22, t23, t24, t25, t26, t27, t28, t29, t30, t31, t32, t33, t34, t35;
	
	xor xor0(s[0], x[0], y[0], cin);
	and and0(g0, x[0], y[0]);
	or or0(p0, x[0], y[0]);
	and and1(t0, p0, cin);
	or or1(c1, t0, g0);
	
	xor xor1(s[1], x[1], y[1], c1);
	and and2(g1, x[1], y[1]);
	or or2(p1, x[1], y[1]);
	and and3(t1, p1, g0);
	and and4(t2, p1, p0, cin);
	or or3(c2, t1, t2, g1);
	
	xor xor2(s[2], x[2], y[2], c2);
	and and5(g2, x[2], y[2]);
	or or4(p2, x[2], y[2]);
	and and6(t3, p2, g1);
	and and7(t4, p2, p1, g0);
	and and8(t5, p2, p1, p0, cin);
	or or5(c3, t3, t4, t5, g2);
	
	xor xor3(s[3], x[3], y[3], c3);
	and and9(g3, x[3], y[3]);
	or or6(p3, x[3], y[3]);
	and and10(t6, p3, g2);
	and and11(t7, p3, p2, g1);
	and and12(t8, p3, p2, p1, g0);
	and and13(t9, p3, p2, p1, p0, cin);
	or or7(c4, t6, t7, t8, t9, g3);
	
	xor xor4(s[4], x[4], y[4], c4);
	and and14(g4, x[4], y[4]);
	or or8(p4, x[4], y[4]);
	and and15(t10, p4, g3);
	and and16(t11, p4, p3, g2);
	and and17(t12, p4, p3, p2, g1);
	and and18(t13, p4, p3, p2, p1, g0);
	and and19(t14, p4, p3, p2, p1, p0, cin);
	or or9(c5, t10, t11, t12, t13, t14, g4);
	
	xor xor5(s[5], x[5], y[5], c5);
	and and20(g5, x[5], y[5]);
	or or10(p5, x[5], y[5]);
	and and21(t15, p5, g4);
	and and22(t16, p5, p4, g3);
	and and23(t17, p5, p4, p3, g2);
	and and24(t18, p5, p4, p3, p2, g1);
	and and25(t19, p5, p4, p3, p2, p1, g0);
	and and26(t20, p5, p4, p3, p2, p1, p0, cin);
	or or11(c6, t15, t16, t17, t18, t19, t20, g5);
	
	xor xor6(s[6], x[6], y[6], c6);
	and and260(g6, x[6], y[6]);
	or or12(p6, x[6], y[6]);
	and and27(t21, p6, g5);
	and and28(t22, p6, p5, g4);
	and and29(t23, p6, p5, p4, g3);
	and and30(t24, p6, p5, p4, p3, g2);
	and and31(t25, p6, p5, p4, p3, p2, g1);
	and and32(t26, p6, p5, p4, p3, p2, p1, g0);
	and and33(t27, p6, p5, p4, p3, p2, p1, p0, cin);
	or or13(c7, t21, t22, t23, t24, t25, t26, t27, g6);
	
	xor xor7(s[7], x[7], y[7], c7);
	and and34(g7, x[7], y[7]);
	or or14(p7, x[7], y[7]);
	and and35(t28, p7, g6);
	and and36(t29, p7, p6, g5);
	and and37(t30, p7, p6, p5, g4);
	and and38(t31, p7, p6, p5, p4, g3);
	and and39(t32, p7, p6, p5, p4, p3, g2);
	and and40(t33, p7, p6, p5, p4, p3, p2, g1);
	and and41(t34, p7, p6, p5, p4, p3, p2, p1, g0);
	and and42(t35, p7, p6, p5, p4, p3, p2, p1, p0, cin);
	or or15(cout, t28, t29, t30, t31, t32, t33, t34, t35, g7);
	//and and43(p, p7, p6, p5, p4, p3, p2, p1, p0);

	
endmodule