module seqdec_26(
	input wire Inp,
	input wire Clk,
	input wire Reset,
	output wire Out
);
	reg [2:0] next_state;
	wire [2:0] state;
	dff state_flops [2:0] (
		.d(next_state),
		.q(state),
		.clk(Clk),
		.rst(Reset)
	);

	always @* case (state)
		3'b000: next_state = Inp ? 3'b001 : 3'b000; // 1
		3'b001: next_state = Inp ? 3'b000 : 3'b010; // 0
		3'b010: next_state = Inp ? 3'b000 : 3'b011; // 0
		3'b011: next_state = Inp ? 3'b100 : 3'b000; // 1
		3'b100: next_state = Inp ? 3'b101 : 3'b000; // 1
		3'b101: next_state = Inp ? 3'b000 : 3'b110; // 0
		3'b110: next_state = Inp ? 3'b001 : 3'b011;
	endcase

	assign Out = state == 3'b110;
endmodule
