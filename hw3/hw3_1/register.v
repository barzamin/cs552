module register(
	input  wire clk,
	input  wire rst,
	input  wire [15:0] write_data,
	input  wire write_en,
	output wire [15:0] read_data
);
	wire [15:0] d;
	assign d = write_en ? write_data : read_data; // loopback q -> d unless we're writing

	dff reg_flops [15:0] (
		.clk(clk),
		.rst(rst),
		.q(read_data),
		.d(d)
	);
endmodule