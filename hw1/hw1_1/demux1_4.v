module demux1_4(
	input wire Inp,
	input wire [1:0] S,
	output wire OutA,
	output wire OutB,
	output wire OutC,
	output wire OutD
);
	wire int1, int2;
	demux1_2 dmux_int (.Inp(Inp),  .S(S[1]), .OutA(int1), .OutB(int2));
	demux1_2 dmux_ab  (.Inp(int1), .S(S[0]), .OutA(OutA), .OutB(OutB));
	demux1_2 dmux_cd  (.Inp(int2), .S(S[0]), .OutA(OutC), .OutB(OutD));
endmodule
