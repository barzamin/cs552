`default_nettype none
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
    register pc_reg (
        .clk       (clk),
        .rst       (rst),
        .write_en  (1'b1), // TODO : halt
        .write_data(next_pc),
        .read_data (pc),
    );

    // next pc if we don't branch
    adder16 adder_pc_basic (
        .A   (pc),
        .B   (16'h2),
        .S   (next_pc_basic),
        .Cin (1'b0),
        .Cout()
    );

    // which do we take?
    assign prediction = 1'b0; // predict everything as NaT
    assign next_pc = prediction ? next_pc_displaced : next_pc_basic;

    assign err = 0;
endmodule
