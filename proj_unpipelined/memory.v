module memory (
    input  wire clk,
    input  wire rst,
    output wire err,

    input  wire read_en,
    input  wire write_en,

    input  wire [15:0] addr,

    input  wire [15:0] write_data,

    output wire [15:0] read_data
);
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
        .createdump(1'b0) // don't need to dump (yet)
    );

    assign err = 1'b0;
endmodule