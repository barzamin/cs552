module flop_if2id(
    input  wire clk,
    input  wire rst,

    input  wire write_en,

    input  wire [15:0] i_instr,
    output wire [15:0] o_instr,

    input  wire [15:0] i_next_pc_basic,
    output wire [15:0] o_next_pc_basic
);
    // delay rst so we don't halt on all-zero IF flops
    wire if_valid;
    register #(.WIDTH(1)) r_if_valid (
        .clk(clk), .rst(rst), .write_en(1'b1),
        .write_data(1'b1), .read_data(if_valid)
    );

    wire [15:0] flop_o_instr;
    assign o_instr = if_valid ? flop_o_instr : 16'h0800; // inject NOP if we don't have valid data yet

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
        .read_data (flop_o_instr)
    );
endmodule

