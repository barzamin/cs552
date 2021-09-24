module reversor(
	input  wire [15:0] in,
	input  wire reverse,
	output wire [15:0] out
);
	// since we can't use `generate`, this isn't parameterized, which is bad practice.
	// code generated with:
	// WIDTH = 16
	// for i in range(WIDTH):
	//     print(f'mux2_1 mux{i:02}(.in0(in[{i:<2}]), .in1(in[{WIDTH-1-i:<2}]), .s(reverse), .out(out[{i:<2}]));')

	mux2_1 mux00(.in0(in[0 ]), .in1(in[15]), .s(reverse), .out(out[0 ]));
	mux2_1 mux01(.in0(in[1 ]), .in1(in[14]), .s(reverse), .out(out[1 ]));
	mux2_1 mux02(.in0(in[2 ]), .in1(in[13]), .s(reverse), .out(out[2 ]));
	mux2_1 mux03(.in0(in[3 ]), .in1(in[12]), .s(reverse), .out(out[3 ]));
	mux2_1 mux04(.in0(in[4 ]), .in1(in[11]), .s(reverse), .out(out[4 ]));
	mux2_1 mux05(.in0(in[5 ]), .in1(in[10]), .s(reverse), .out(out[5 ]));
	mux2_1 mux06(.in0(in[6 ]), .in1(in[9 ]), .s(reverse), .out(out[6 ]));
	mux2_1 mux07(.in0(in[7 ]), .in1(in[8 ]), .s(reverse), .out(out[7 ]));
	mux2_1 mux08(.in0(in[8 ]), .in1(in[7 ]), .s(reverse), .out(out[8 ]));
	mux2_1 mux09(.in0(in[9 ]), .in1(in[6 ]), .s(reverse), .out(out[9 ]));
	mux2_1 mux10(.in0(in[10]), .in1(in[5 ]), .s(reverse), .out(out[10]));
	mux2_1 mux11(.in0(in[11]), .in1(in[4 ]), .s(reverse), .out(out[11]));
	mux2_1 mux12(.in0(in[12]), .in1(in[3 ]), .s(reverse), .out(out[12]));
	mux2_1 mux13(.in0(in[13]), .in1(in[2 ]), .s(reverse), .out(out[13]));
	mux2_1 mux14(.in0(in[14]), .in1(in[1 ]), .s(reverse), .out(out[14]));
	mux2_1 mux15(.in0(in[15]), .in1(in[0 ]), .s(reverse), .out(out[15]));
endmodule