module demux1_2(
	input wire Inp,
	input wire S,
	output wire OutA,
	output wire OutB
);
	wire Sbar, OutAbar, OutBbar;
	not1  not1_s (.in1(S), .out(Sbar));
	nand2 nand2_sel_a (.in1(Sbar), .in2(Inp), .out(OutAbar));
	nand2 nand2_sel_b (.in1(S),    .in2(Inp), .out(OutBbar));
	not1  not1_outa (.in1(OutAbar), .out(OutA));
	not1  not1_outb (.in1(OutBbar), .out(OutB));
endmodule
