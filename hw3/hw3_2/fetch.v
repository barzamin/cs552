module fetch(
    input  wire clk,
    input  wire rst,
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

    // assign next_pc = pc + 2;
    adder16 pc_adder(
        .A   (pc),
        .B   (16'h2), // pc' = pc+2
        .S   (next_pc),
        .Cin (0),
        .Cout()
    );

    memory2c mem (
        .clk       (clk),
        .rst       (rst),
        .wr        (0), // never need to write in this problem
        .data_in   (0), // ibid
        .createdump(0), // don't need to check memory at end of run
        .addr      (pc),
        .enable    (1), // enable memory so we can read!
        .data_out  (instr)
    );
endmodule
