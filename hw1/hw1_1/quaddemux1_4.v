module quaddemux1_4(
	input wire [3:0] Inp,
	input wire [1:0] S,
	output wire [3:0] OutA,
	output wire [3:0] OutB,
	output wire [3:0] OutC,
	output wire [3:0] OutD
);
	demux1_4 demuxes [3:0] (
		.Inp(Inp),
		.S(S),
		.OutA(OutA),
		.OutB(OutB),
		.OutC(OutC),
		.OutD(OutD)
	);
endmodule
