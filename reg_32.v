module reg_32(in, out, write_enable, clk, reset);
	
	input write_enable, clk, reset;
	input [31:0] in;
	output [31:0] out;
	
	dffe_ref dff0(.q(out[0]), .d(in[0]), .clk(clk), .en(write_enable), .clr(reset));
	dffe_ref dff1(.q(out[1]), .d(in[1]), .clk(clk), .en(write_enable), .clr(reset));
	dffe_ref dff2(.q(out[2]), .d(in[2]), .clk(clk), .en(write_enable), .clr(reset));
	dffe_ref dff3(.q(out[3]), .d(in[3]), .clk(clk), .en(write_enable), .clr(reset));
	dffe_ref dff4(.q(out[4]), .d(in[4]), .clk(clk), .en(write_enable), .clr(reset));
	dffe_ref dff5(.q(out[5]), .d(in[5]), .clk(clk), .en(write_enable), .clr(reset));
	dffe_ref dff6(.q(out[6]), .d(in[6]), .clk(clk), .en(write_enable), .clr(reset));
	dffe_ref dff7(.q(out[7]), .d(in[7]), .clk(clk), .en(write_enable), .clr(reset));
	dffe_ref dff8(.q(out[8]), .d(in[8]), .clk(clk), .en(write_enable), .clr(reset));
	dffe_ref dff9(.q(out[9]), .d(in[9]), .clk(clk), .en(write_enable), .clr(reset));
	dffe_ref dff10(.q(out[10]), .d(in[10]), .clk(clk), .en(write_enable), .clr(reset));
	dffe_ref dff11(.q(out[11]), .d(in[11]), .clk(clk), .en(write_enable), .clr(reset));
	dffe_ref dff12(.q(out[12]), .d(in[12]), .clk(clk), .en(write_enable), .clr(reset));
	dffe_ref dff13(.q(out[13]), .d(in[13]), .clk(clk), .en(write_enable), .clr(reset));
	dffe_ref dff14(.q(out[14]), .d(in[14]), .clk(clk), .en(write_enable), .clr(reset));
	dffe_ref dff15(.q(out[15]), .d(in[15]), .clk(clk), .en(write_enable), .clr(reset));
	dffe_ref dff16(.q(out[16]), .d(in[16]), .clk(clk), .en(write_enable), .clr(reset));
	dffe_ref dff17(.q(out[17]), .d(in[17]), .clk(clk), .en(write_enable), .clr(reset));
	dffe_ref dff18(.q(out[18]), .d(in[18]), .clk(clk), .en(write_enable), .clr(reset));
	dffe_ref dff19(.q(out[19]), .d(in[19]), .clk(clk), .en(write_enable), .clr(reset));
	dffe_ref dff20(.q(out[20]), .d(in[20]), .clk(clk), .en(write_enable), .clr(reset));
	dffe_ref dff21(.q(out[21]), .d(in[21]), .clk(clk), .en(write_enable), .clr(reset));
	dffe_ref dff22(.q(out[22]), .d(in[22]), .clk(clk), .en(write_enable), .clr(reset));
	dffe_ref dff23(.q(out[23]), .d(in[23]), .clk(clk), .en(write_enable), .clr(reset));
	dffe_ref dff24(.q(out[24]), .d(in[24]), .clk(clk), .en(write_enable), .clr(reset));
	dffe_ref dff25(.q(out[25]), .d(in[25]), .clk(clk), .en(write_enable), .clr(reset));
	dffe_ref dff26(.q(out[26]), .d(in[26]), .clk(clk), .en(write_enable), .clr(reset));
	dffe_ref dff27(.q(out[27]), .d(in[27]), .clk(clk), .en(write_enable), .clr(reset));
	dffe_ref dff28(.q(out[28]), .d(in[28]), .clk(clk), .en(write_enable), .clr(reset));
	dffe_ref dff29(.q(out[29]), .d(in[29]), .clk(clk), .en(write_enable), .clr(reset));
	dffe_ref dff30(.q(out[30]), .d(in[30]), .clk(clk), .en(write_enable), .clr(reset));
	dffe_ref dff31(.q(out[31]), .d(in[31]), .clk(clk), .en(write_enable), .clr(reset));

endmodule

module dffe_ref(q, d, clk, en, clr);
   
   //Inputs
   input d, clk, en, clr;
   
   //Internal wire
   wire clr;

   //Output
   output q;
   
   //Register
   reg q;

   //Intialize q to 0
   initial
   begin
       q = 1'b0;
   end

   //Set value of q on positive edge of the clock or clear
   always @(posedge clk or posedge clr) begin
       //If clear is high, set q to 0
       if (clr) begin
           q <= 1'b0;
       //If enable is high, set q to the value of d
       end else if (en) begin
           q <= d;
       end
   end
endmodule
