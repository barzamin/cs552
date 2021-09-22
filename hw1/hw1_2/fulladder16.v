module fulladder16(
	input wire [15:0] A,
	input wire [15:0] B,
	output wire [15:0] S,
	output wire Cout
);
	wire [2:0] carries;
	fulladder4 adders [3:0] (
		.A(A),
		.B(B),
		.Cin({carries, 1'b0}),
		.Cout({Cout, carries}),
		.S(S)
	);
endmodule

