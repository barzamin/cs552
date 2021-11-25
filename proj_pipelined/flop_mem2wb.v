module flop_mem2wb(
    input  wire clk,
    input  wire rst,

    input  wire [1:0] i_wb_op,
    input  wire [1:0] o_wb_op,

    input  wire [15:0] i_dmem_out,
    output wire [15:0] o_dmem_out,

    input  wire [15:0] i_alu_out,
    output wire [15:0] o_alu_out
);
    // TODO !!!
    wire write_en;
    assign write_en = 1'b1;

    register #(.WIDTH(2)) r_wb_op (
        .clk(clk), .rst(rst), .write_en(write_en),
        .write_data(i_wb_op), .read_data(o_wb_op)
    );

    register #(.WIDTH(16)) r_dmem_out (
        .clk(clk), .rst(rst), .write_en(write_en),
        .write_data(i_dmem_out), .read_data(o_dmem_out)
    );

    register #(.WIDTH(16)) r_alu_out (
        .clk(clk), .rst(rst), .write_en(write_en),
        .write_data(i_alu_out), .read_data(o_alu_out)
    );
endmodule
