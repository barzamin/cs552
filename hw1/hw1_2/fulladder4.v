module fulladder4(
	input wire [3:0] A,
	input wire [3:0] B,
	input wire Cin,
	output wire [3:0] S,
	output wire Cout
);
	wire [2:0] carries;

	fulladder1 adders [3:0] (
		.A(A),
		.B(B),
		.Cin({carries, Cin}),
		.Cout({Cout, carries}),
		.S(S)
	);
endmodule
