module regfile (
    clock,
    ctrl_writeEnable,
    ctrl_reset, ctrl_writeReg,
    ctrl_readRegA, ctrl_readRegB, data_writeReg,
    data_readRegA, data_readRegB
);

   input clock, ctrl_writeEnable, ctrl_reset;
   input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
   input [31:0] data_writeReg;

   output [31:0] data_readRegA, data_readRegB;

   wire [31:0] readRegA_decoded, readRegB_decoded, writeReg_decoded;
	
	decoder5to32 writeDecoder(.c0(ctrl_writeReg[0]), .c1(ctrl_writeReg[1]), .c2(ctrl_writeReg[2]), .c3(ctrl_writeReg[3]), .c4(ctrl_writeReg[4]), .out(writeReg_decoded));
	decoder5to32 readDecoderA(.c0(ctrl_readRegA[0]), .c1(ctrl_readRegA[1]), .c2(ctrl_readRegA[2]), .c3(ctrl_readRegA[3]), .c4(ctrl_readRegA[4]), .out(readRegA_decoded));
	decoder5to32 readDecoderB(.c0(ctrl_readRegB[0]), .c1(ctrl_readRegB[1]), .c2(ctrl_readRegB[2]), .c3(ctrl_readRegB[3]), .c4(ctrl_readRegB[4]), .out(readRegB_decoded));
	
	wire w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, w16, w17, w18, w19, w20, w21, w22, w23, w24, w25, w26, w27, w28, w29, w30, w31;
	
	and and0(w0, writeReg_decoded[0], ctrl_writeEnable);
	and and1(w1, writeReg_decoded[1], ctrl_writeEnable);
	and and2(w2, writeReg_decoded[2], ctrl_writeEnable);
	and and3(w3, writeReg_decoded[3], ctrl_writeEnable);
	and and4(w4, writeReg_decoded[4], ctrl_writeEnable);
	and and5(w5, writeReg_decoded[5], ctrl_writeEnable);
	and and6(w6, writeReg_decoded[6], ctrl_writeEnable);
	and and7(w7, writeReg_decoded[7], ctrl_writeEnable);
	and and8(w8, writeReg_decoded[8], ctrl_writeEnable);
	and and9(w9, writeReg_decoded[9], ctrl_writeEnable);
	and and10(w10, writeReg_decoded[10], ctrl_writeEnable);
	and and11(w11, writeReg_decoded[11], ctrl_writeEnable);
	and and12(w12, writeReg_decoded[12], ctrl_writeEnable);
	and and13(w13, writeReg_decoded[13], ctrl_writeEnable);
	and and14(w14, writeReg_decoded[14], ctrl_writeEnable);
	and and15(w15, writeReg_decoded[15], ctrl_writeEnable);
	and and16(w16, writeReg_decoded[16], ctrl_writeEnable);
	and and17(w17, writeReg_decoded[17], ctrl_writeEnable);
	and and18(w18, writeReg_decoded[18], ctrl_writeEnable);
	and and19(w19, writeReg_decoded[19], ctrl_writeEnable);
	and and20(w20, writeReg_decoded[20], ctrl_writeEnable);
	and and21(w21, writeReg_decoded[21], ctrl_writeEnable);
	and and22(w22, writeReg_decoded[22], ctrl_writeEnable);
	and and23(w23, writeReg_decoded[23], ctrl_writeEnable);
	and and24(w24, writeReg_decoded[24], ctrl_writeEnable);
	and and25(w25, writeReg_decoded[25], ctrl_writeEnable);
	and and26(w26, writeReg_decoded[26], ctrl_writeEnable);
	and and27(w27, writeReg_decoded[27], ctrl_writeEnable);
	and and28(w28, writeReg_decoded[28], ctrl_writeEnable);
	and and29(w29, writeReg_decoded[29], ctrl_writeEnable);
	and and30(w30, writeReg_decoded[30], ctrl_writeEnable);
	and and31(w31, writeReg_decoded[31], ctrl_writeEnable);
	
	wire [31:0] w32, w33, w34, w35, w36, w37, w38, w39, w40, w41, w42, w43, w44, w45, w46, w47, w48, w49, w50, w51, w52, w53, w54, w55, w56, w57, w58, w59, w60, w61, w62, w63;
	
	reg_32 reg0(.in(32'b0), .out(w32), .write_enable(w0), .clk(~clock), .reset(ctrl_reset));
	reg_32 reg1(.in(data_writeReg), .out(w33), .write_enable(w1), .clk(~clock), .reset(ctrl_reset));
	reg_32 reg2(.in(data_writeReg), .out(w34), .write_enable(w2), .clk(~clock), .reset(ctrl_reset));
	reg_32 reg3(.in(data_writeReg), .out(w35), .write_enable(w3), .clk(~clock), .reset(ctrl_reset));
	reg_32 reg4(.in(data_writeReg), .out(w36), .write_enable(w4), .clk(~clock), .reset(ctrl_reset));
	reg_32 reg5(.in(data_writeReg), .out(w37), .write_enable(w5), .clk(~clock), .reset(ctrl_reset));
	reg_32 reg6(.in(data_writeReg), .out(w38), .write_enable(w6), .clk(~clock), .reset(ctrl_reset));
	reg_32 reg7(.in(data_writeReg), .out(w39), .write_enable(w7), .clk(~clock), .reset(ctrl_reset));
	reg_32 reg8(.in(data_writeReg), .out(w40), .write_enable(w8), .clk(~clock), .reset(ctrl_reset));
	reg_32 reg9(.in(data_writeReg), .out(w41), .write_enable(w9), .clk(~clock), .reset(ctrl_reset));
	reg_32 reg10(.in(data_writeReg), .out(w42), .write_enable(w10), .clk(~clock), .reset(ctrl_reset));
	reg_32 reg11(.in(data_writeReg), .out(w43), .write_enable(w11), .clk(~clock), .reset(ctrl_reset));
	reg_32 reg12(.in(data_writeReg), .out(w44), .write_enable(w12), .clk(~clock), .reset(ctrl_reset));
	reg_32 reg13(.in(data_writeReg), .out(w45), .write_enable(w13), .clk(~clock), .reset(ctrl_reset));
	reg_32 reg14(.in(data_writeReg), .out(w46), .write_enable(w14), .clk(~clock), .reset(ctrl_reset));
	reg_32 reg15(.in(data_writeReg), .out(w47), .write_enable(w15), .clk(~clock), .reset(ctrl_reset));
	reg_32 reg16(.in(data_writeReg), .out(w48), .write_enable(w16), .clk(~clock), .reset(ctrl_reset));
	reg_32 reg17(.in(data_writeReg), .out(w49), .write_enable(w17), .clk(~clock), .reset(ctrl_reset));
	reg_32 reg18(.in(data_writeReg), .out(w50), .write_enable(w18), .clk(~clock), .reset(ctrl_reset));
	reg_32 reg19(.in(data_writeReg), .out(w51), .write_enable(w19), .clk(~clock), .reset(ctrl_reset));
	reg_32 reg20(.in(data_writeReg), .out(w52), .write_enable(w20), .clk(~clock), .reset(ctrl_reset));
	reg_32 reg21(.in(data_writeReg), .out(w53), .write_enable(w21), .clk(~clock), .reset(ctrl_reset));
	reg_32 reg22(.in(data_writeReg), .out(w54), .write_enable(w22), .clk(~clock), .reset(ctrl_reset));
	reg_32 reg23(.in(data_writeReg), .out(w55), .write_enable(w23), .clk(~clock), .reset(ctrl_reset));
	reg_32 reg24(.in(data_writeReg), .out(w56), .write_enable(w24), .clk(~clock), .reset(ctrl_reset));
	reg_32 reg25(.in(data_writeReg), .out(w57), .write_enable(w25), .clk(~clock), .reset(ctrl_reset));
	reg_32 reg26(.in(data_writeReg), .out(w58), .write_enable(w26), .clk(~clock), .reset(ctrl_reset));
	reg_32 reg27(.in(data_writeReg), .out(w59), .write_enable(w27), .clk(~clock), .reset(ctrl_reset));
	reg_32 reg28(.in(data_writeReg), .out(w60), .write_enable(w28), .clk(~clock), .reset(ctrl_reset));
	reg_32 reg29(.in(data_writeReg), .out(w61), .write_enable(w29), .clk(~clock), .reset(ctrl_reset));
	reg_32 reg30(.in(data_writeReg), .out(w62), .write_enable(w30), .clk(~clock), .reset(ctrl_reset));
	reg_32 reg31(.in(data_writeReg), .out(w63), .write_enable(w31), .clk(~clock), .reset(ctrl_reset));
	
	tri_buff tri0a(.a(w32), .b(data_readRegA), .enable(readRegA_decoded[0]));
	tri_buff tri1a(.a(w33), .b(data_readRegA), .enable(readRegA_decoded[1]));
	tri_buff tri2a(.a(w34), .b(data_readRegA), .enable(readRegA_decoded[2]));
	tri_buff tri3a(.a(w35), .b(data_readRegA), .enable(readRegA_decoded[3]));
	tri_buff tri4a(.a(w36), .b(data_readRegA), .enable(readRegA_decoded[4]));
	tri_buff tri5a(.a(w37), .b(data_readRegA), .enable(readRegA_decoded[5]));
	tri_buff tri6a(.a(w38), .b(data_readRegA), .enable(readRegA_decoded[6]));
	tri_buff tri7a(.a(w39), .b(data_readRegA), .enable(readRegA_decoded[7]));
	tri_buff tri8a(.a(w40), .b(data_readRegA), .enable(readRegA_decoded[8]));
	tri_buff tri9a(.a(w41), .b(data_readRegA), .enable(readRegA_decoded[9]));
	tri_buff tri10a(.a(w42), .b(data_readRegA), .enable(readRegA_decoded[10]));
	tri_buff tri11a(.a(w43), .b(data_readRegA), .enable(readRegA_decoded[11]));
	tri_buff tri12a(.a(w44), .b(data_readRegA), .enable(readRegA_decoded[12]));
	tri_buff tri13a(.a(w45), .b(data_readRegA), .enable(readRegA_decoded[13]));
	tri_buff tri14a(.a(w46), .b(data_readRegA), .enable(readRegA_decoded[14]));
	tri_buff tri15a(.a(w47), .b(data_readRegA), .enable(readRegA_decoded[15]));
	tri_buff tri16a(.a(w48), .b(data_readRegA), .enable(readRegA_decoded[16]));
	tri_buff tri17a(.a(w49), .b(data_readRegA), .enable(readRegA_decoded[17]));
	tri_buff tri18a(.a(w50), .b(data_readRegA), .enable(readRegA_decoded[18]));
	tri_buff tri19a(.a(w51), .b(data_readRegA), .enable(readRegA_decoded[19]));
	tri_buff tri20a(.a(w52), .b(data_readRegA), .enable(readRegA_decoded[20]));
	tri_buff tri21a(.a(w53), .b(data_readRegA), .enable(readRegA_decoded[21]));
	tri_buff tri22a(.a(w54), .b(data_readRegA), .enable(readRegA_decoded[22]));
	tri_buff tri23a(.a(w55), .b(data_readRegA), .enable(readRegA_decoded[23]));
	tri_buff tri24a(.a(w56), .b(data_readRegA), .enable(readRegA_decoded[24]));
	tri_buff tri25a(.a(w57), .b(data_readRegA), .enable(readRegA_decoded[25]));
	tri_buff tri26a(.a(w58), .b(data_readRegA), .enable(readRegA_decoded[26]));
	tri_buff tri27a(.a(w59), .b(data_readRegA), .enable(readRegA_decoded[27]));
	tri_buff tri28a(.a(w60), .b(data_readRegA), .enable(readRegA_decoded[28]));
	tri_buff tri29a(.a(w61), .b(data_readRegA), .enable(readRegA_decoded[29]));
	tri_buff tri30a(.a(w62), .b(data_readRegA), .enable(readRegA_decoded[30]));
	tri_buff tri31a(.a(w63), .b(data_readRegA), .enable(readRegA_decoded[31]));
	
	tri_buff tri0b(.a(w32), .b(data_readRegB), .enable(readRegB_decoded[0]));
	tri_buff tri1b(.a(w33), .b(data_readRegB), .enable(readRegB_decoded[1]));
	tri_buff tri2b(.a(w34), .b(data_readRegB), .enable(readRegB_decoded[2]));
	tri_buff tri3b(.a(w35), .b(data_readRegB), .enable(readRegB_decoded[3]));
	tri_buff tri4b(.a(w36), .b(data_readRegB), .enable(readRegB_decoded[4]));
	tri_buff tri5b(.a(w37), .b(data_readRegB), .enable(readRegB_decoded[5]));
	tri_buff tri6b(.a(w38), .b(data_readRegB), .enable(readRegB_decoded[6]));
	tri_buff tri7b(.a(w39), .b(data_readRegB), .enable(readRegB_decoded[7]));
	tri_buff tri8b(.a(w40), .b(data_readRegB), .enable(readRegB_decoded[8]));
	tri_buff tri9b(.a(w41), .b(data_readRegB), .enable(readRegB_decoded[9]));
	tri_buff tri10b(.a(w42), .b(data_readRegB), .enable(readRegB_decoded[10]));
	tri_buff tri11b(.a(w43), .b(data_readRegB), .enable(readRegB_decoded[11]));
	tri_buff tri12b(.a(w44), .b(data_readRegB), .enable(readRegB_decoded[12]));
	tri_buff tri13b(.a(w45), .b(data_readRegB), .enable(readRegB_decoded[13]));
	tri_buff tri14b(.a(w46), .b(data_readRegB), .enable(readRegB_decoded[14]));
	tri_buff tri15b(.a(w47), .b(data_readRegB), .enable(readRegB_decoded[15]));
	tri_buff tri16b(.a(w48), .b(data_readRegB), .enable(readRegB_decoded[16]));
	tri_buff tri17b(.a(w49), .b(data_readRegB), .enable(readRegB_decoded[17]));
	tri_buff tri18b(.a(w50), .b(data_readRegB), .enable(readRegB_decoded[18]));
	tri_buff tri19b(.a(w51), .b(data_readRegB), .enable(readRegB_decoded[19]));
	tri_buff tri20b(.a(w52), .b(data_readRegB), .enable(readRegB_decoded[20]));
	tri_buff tri21b(.a(w53), .b(data_readRegB), .enable(readRegB_decoded[21]));
	tri_buff tri22b(.a(w54), .b(data_readRegB), .enable(readRegB_decoded[22]));
	tri_buff tri23b(.a(w55), .b(data_readRegB), .enable(readRegB_decoded[23]));
	tri_buff tri24b(.a(w56), .b(data_readRegB), .enable(readRegB_decoded[24]));
	tri_buff tri25b(.a(w57), .b(data_readRegB), .enable(readRegB_decoded[25]));
	tri_buff tri26b(.a(w58), .b(data_readRegB), .enable(readRegB_decoded[26]));
	tri_buff tri27b(.a(w59), .b(data_readRegB), .enable(readRegB_decoded[27]));
	tri_buff tri28b(.a(w60), .b(data_readRegB), .enable(readRegB_decoded[28]));
	tri_buff tri29b(.a(w61), .b(data_readRegB), .enable(readRegB_decoded[29]));
	tri_buff tri30b(.a(w62), .b(data_readRegB), .enable(readRegB_decoded[30]));
	tri_buff tri31b(.a(w63), .b(data_readRegB), .enable(readRegB_decoded[31]));
	
	
endmodule

module tri_buff(a, b, enable);

	input [31:0] a;
	input enable;
	output [31:0] b;
	
	assign b = enable ? a : 32'bZ;

endmodule

module decoder5to32(c0, c1, c2, c3, c4, out);

	input c0, c1, c2, c3, c4;
	output [31:0] out;
	
	wire c0n;
	wire c1n;
	wire c2n;
	wire c3n;
	wire c4n;
	
	not not0(c0n, c0);
	not not1(c1n, c1);
	not not2(c2n, c2);
	not not3(c3n, c3);
	not not4(c4n, c4);

	and and0(out[0], c4n, c3n, c2n, c1n, c0n);
	and and1(out[1], c4n, c3n, c2n, c1n, c0);
	and and2(out[2], c4n, c3n, c2n, c1, c0n);
	and and3(out[3], c4n, c3n, c2n, c1, c0);
	and and4(out[4], c4n, c3n, c2, c1n, c0n);
	and and5(out[5], c4n, c3n, c2, c1n, c0);
	and and6(out[6], c4n, c3n, c2, c1, c0n);
	and and7(out[7], c4n, c3n, c2, c1, c0);
	and and8(out[8], c4n, c3, c2n, c1n, c0n);
	and and9(out[9], c4n, c3, c2n, c1n, c0);
	and and10(out[10], c4n, c3, c2n, c1, c0n);
	and and11(out[11], c4n, c3, c2n, c1, c0);
	and and12(out[12], c4n, c3, c2, c1n, c0n);
	and and13(out[13], c4n, c3, c2, c1n, c0);
	and and14(out[14], c4n, c3, c2, c1, c0n);
	and and15(out[15], c4n, c3, c2, c1, c0);
	and and16(out[16], c4, c3n, c2n, c1n, c0n);
	and and17(out[17], c4, c3n, c2n, c1n, c0);
	and and18(out[18], c4, c3n, c2n, c1, c0n);
	and and19(out[19], c4, c3n, c2n, c1, c0);
	and and20(out[20], c4, c3n, c2, c1n, c0n);
	and and21(out[21], c4, c3n, c2, c1n, c0);
	and and22(out[22], c4, c3n, c2, c1, c0n);
	and and23(out[23], c4, c3n, c2, c1, c0);
	and and24(out[24], c4, c3, c2n, c1n, c0n);
	and and25(out[25], c4, c3, c2n, c1n, c0);
	and and26(out[26], c4, c3, c2n, c1, c0n);
	and and27(out[27], c4, c3, c2n, c1, c0);
	and and28(out[28], c4, c3, c2, c1n, c0n);
	and and29(out[29], c4, c3, c2, c1n, c0);
	and and30(out[30], c4, c3, c2, c1, c0n);
	and and31(out[31], c4, c3, c2, c1, c0);

endmodule