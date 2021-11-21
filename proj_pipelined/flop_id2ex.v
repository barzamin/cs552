module flop_id2ex(
    input  wire clk,
    input  wire rst,

    input  wire  [3:0] i_alu_op,
    output wire  [3:0] o_alu_op,

    input  wire [15:0] i_imm16,
    output wire [15:0] o_imm16,

    input  wire [15:0] i_rA_v,
    output wire [15:0] o_rA_v,
    input  wire [15:0] i_rB_v,
    output wire [15:0] o_rB_v
);
    // TODO !!!
    wire write_en;
    assign write_en = 1'b1;

    register #(.WIDTH(4)) r_alu_op (
        .clk(clk), .rst(rst), .write_en(write_en),
        .write_data(i_alu_op), .read_data(o_alu_op)
    );

    register #(.WIDTH(16)) r_imm16 (
        .clk(clk), .rst(rst), .write_en(write_en),
        .write_data(i_imm16), .read_data(o_imm16)
    );

    register #(.WIDTH(16)) r_rA_v (
        .clk(clk), .rst(rst), .write_en(write_en),
        .write_data(i_rA_v), .read_data(o_rA_v)
    );

    register #(.WIDTH(16)) r_rB_v (
        .clk(clk), .rst(rst), .write_en(write_en),
        .write_data(i_rB_v), .read_data(o_rB_v)
    );
endmodule
