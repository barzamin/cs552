module flop_ex2mem(
    input  wire clk,
    input  wire rst,

    input  wire i_halt,
    output wire o_halt,

    input  wire i_rf_wen,
    output wire o_rf_wen,
    input  wire  [1:0] i_wb_op,
    output wire  [1:0] o_wb_op,

    input  wire [2:0] i_rO,
    output wire [2:0] o_rO,

    input  wire [15:0] i_alu_out,
    output wire [15:0] o_alu_out,

    input  wire [2:0] i_rY,
    output wire [2:0] o_rY,
    input  wire [15:0] i_vY,
    input  wire [15:0] o_vY,

    input  wire i_dmem_ren,
    output wire o_dmem_ren,
    input  wire i_dmem_wen,
    output wire o_dmem_wen
);
    // TODO !!!
    wire write_en;
    assign write_en = 1'b1;

    register #(.WIDTH(1)) r_halt (
        .clk(clk), .rst(rst), .write_en(write_en),
        .write_data(i_halt), .read_data(o_halt)
    );

    register #(.WIDTH(16)) r_alu_out (
        .clk(clk), .rst(rst), .write_en(write_en),
        .write_data(i_alu_out), .read_data(o_alu_out)
    );

    register #(.WIDTH(3)) r_rY (
        .clk(clk), .rst(rst), .write_en(write_en),
        .write_data(i_rY), .read_data(o_rY)
    );

    register #(.WIDTH(16)) r_vY (
        .clk(clk), .rst(rst), .write_en(write_en),
        .write_data(i_vY), .read_data(o_vY)
    );

    // -- writeback control
    register #(.WIDTH(3)) r_rO (
        .clk(clk), .rst(rst), .write_en(write_en),
        .write_data(i_rO), .read_data(o_rO)
    );

    register #(.WIDTH(1)) r_rf_wen (
        .clk(clk), .rst(rst), .write_en(write_en),
        .write_data(i_rf_wen), .read_data(o_rf_wen)
    );

    register #(.WIDTH(2)) r_wb_op (
        .clk(clk), .rst(rst), .write_en(write_en),
        .write_data(i_wb_op), .read_data(o_wb_op)
    );

    // -- memory control
    register #(.WIDTH(1)) r_dmem_ren (
        .clk(clk), .rst(rst), .write_en(write_en),
        .write_data(i_dmem_ren), .read_data(o_dmem_ren)
    );
    register #(.WIDTH(1)) r_dmem_wen (
        .clk(clk), .rst(rst), .write_en(write_en),
        .write_data(i_dmem_wen), .read_data(o_dmem_wen)
    );
endmodule
