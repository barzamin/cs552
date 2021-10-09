module fetch(
    input  wire clk,
    input  wire rst,
    input  wire [15:0] offset,
    output wire err,
    output wire [15:0] instr
);
    wire [15:0] pc;
    wire [15:0] next_pc;
    dff pc_flops [15:0] (
        .clk(clk),
        .rst(rst),
        .d(next_pc),
        .q(pc)
    );

    // cascading two adders sucks. definitely a better way to do this
    wire [15:0] pc_intermediate;
    adder16 pc_adder1(
        .A   (pc),
        .B   (16'h2),
        .S   (pc_intermediate),
        .Cin (1'b0),
        .Cout()
    );

    adder16 pc_adder2(
        .A   (pc_intermediate),
        .B   (offset),
        .S   (next_pc),
        .Cin (1'b0),
        .Cout()
    );

    memory2c mem (
        .clk       (clk),
        .rst       (rst),
        .wr        (1'b0), // never need to write in this problem
        .data_in   (16'h0000), // ibid
        .createdump(1'b0), // don't need to check memory at end of run
        .addr      (pc),
        .enable    (1'b1), // enable memory so we can read!
        .data_out  (instr)
    );

    assign err = 0;
endmodule
