module fulladder1(
	input wire A,
	input wire B,
	input wire Cin,
	output wire S,
	output wire Cout
);
	wire sum_ab;
	wire not_ab_ovf, not_cin_ovf;

	xor2 xor_int (.in1(A), .in2(B), .out(sum_ab));
	xor2 xor_sum (.in1(sum_ab), .in2(Cin), .out(S));

	// a&b | (a^b)&cin
	nand2 na1 (.in1(A), .in2(B), .out(not_ab_ovf));
	nand2 na2 (.in1(sum_ab), .in2(Cin), .out(not_cin_ovf));
	nand2 na3 (.in1(not_ab_ovf), .in2(not_cin_ovf), .out(Cout));
endmodule
