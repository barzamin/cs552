module fetch(
    input  wire clk,
    input  wire rst,
    output wire err,

    input  wire [15:0] next_pc,
    output wire [15:0] pc,
    output wire [15:0] instr
);
    dff pc_flops [15:0] (
        .clk(clk),
        .rst(rst),
        .d(next_pc),
        .q(pc)
    );

    memory2c mem (
        .clk       (clk),
        .rst       (rst),
        .wr        (1'b0), // we can't write to imem
        .data_in   (16'h0000), // ibid
        .createdump(1'b0), // don't need to check imem at end of run, since it doesn't mutate
        .addr      (pc),
        .enable    (1'b1), // enable memory so we can read!
        .data_out  (instr)
    );

    assign err = 0;
endmodule
