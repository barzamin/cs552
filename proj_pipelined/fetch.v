module fetch(
    input  wire clk,
    input  wire rst,
    output wire err,

    input  wire [15:0] next_pc_displaced, // coming in from decode

    output wire [15:0] next_pc_basic,
    output wire [15:0] instr
);
    // pc register
    wire [15:0] next_pc;
    wire [15:0] pc;
    register pc_reg (
        .clk       (clk),
        .rst       (rst),
        .write_en  (1'b1), // TODO : halt
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
        .wr        (1'b0), // imem is immutable
        .data_in   (16'h0), // ibid
        .createdump(1'b0), // never need to dump
        .addr      (pc),
        .enable    (1'b1),
        .data_out  (instr)
    );

    // which do we take?
    // assign next_pc = prediction ? next_pc_displaced : next_pc_basic;
    assign next_pc = next_pc_basic;

    assign err = 1'b0;
endmodule
