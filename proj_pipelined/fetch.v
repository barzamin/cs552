module fetch(
    input  wire clk,
    input  wire rst,
    output wire err,
    input  wire freeze_pc,

    // loopback from decode
    input  wire [15:0] pc_rewrite_to,
    input  wire        rewrite_pc,

    output wire [15:0] next_pc_basic,
    output wire [15:0] instr
);
    // pc register
    wire [15:0] next_pc;
    wire [15:0] pc;
    register pc_reg (
        .clk       (clk),
        .rst       (rst),
        .write_en  (~freeze_pc),
        .write_data(next_pc),
        .read_data (pc)
    );

    // next pc if we don't branch
    adder16 adder_pc_basic (
        .A   (pc),
        .B   (16'h2),
        .S   (next_pc_basic),
        .Cin (1'b0),
        .Cout()
    );

    // -- imem
    memory2c imem (
        .clk       (clk),
        .rst       (rst),
        .wr        (1'b0),  // imem is immutable
        .data_in   (16'h0), // ibid
        .createdump(1'b0),  // never need to dump
        .addr      (pc),
        .enable    (1'b1),
        .data_out  (instr)
    );

    // assume basic flow unless we have an active pc rewrite
    assign next_pc = rewrite_pc ? pc_rewrite_to : next_pc_basic;

    assign err = 1'b0;
endmodule
