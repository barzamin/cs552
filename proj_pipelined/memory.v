module memory (
	input  wire clk,
	input  wire rst,
	output wire err,
    input  wire halt,

	input  wire read_en,
	input  wire write_en,

	input  wire [15:0] addr,

    output wire [15:0] read_data,

	input  wire [15:0] vY,

    input  wire [15:0] WB_wb_data,
    input  wire        fwd_WB_vY
);
    wire [15:0] write_data;
    assign write_data = fwd_WB_vY ? WB_wb_data : vY;

    wire mem_en;
    assign mem_en = read_en | write_en; // enable if we're doing any access
    memory2c membank (
        .rst       (rst),
        .clk       (clk),
        .wr        (write_en),
        .enable    (mem_en),
        .addr      (addr),
        .data_in   (write_data),
        .data_out  (read_data),
        .createdump(halt) // dump on halt
    );

	assign err = read_en && write_en; // can't have both read and write at same time!
endmodule
