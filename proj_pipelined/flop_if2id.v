module flop_if2id(
    input  wire clk,
    input  wire rst,

    input  wire [15:0] i_instr,
    output wire [15:0] o_instr,

    input  wire [15:0] i_next_pc_basic,
    output wire [15:0] o_next_pc_basic
);
    // TODO !!!
    wire write_en;
    assign write_en = 1'b1;

    register #(.WIDTH(16)) r_next_pc_basic (
        .clk       (clk),
        .rst       (rst),
        .write_en  (write_en),
        .write_data(i_next_pc_basic),
        .read_data (o_next_pc_basic)
    );

    register #(.WIDTH(16)) r_instr (
        .clk       (clk),
        .rst       (rst),
        .write_en  (write_en),
        .write_data(i_instr),
        .read_data (o_instr)
    );
endmodule

