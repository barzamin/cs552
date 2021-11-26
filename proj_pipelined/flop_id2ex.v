module flop_id2ex(
    input  wire clk,
    input  wire rst,
    input  wire bubble,

    input  wire i_halt,
    output wire o_halt,

    input  wire  [3:0] i_alu_op,
    output wire  [3:0] o_alu_op,
    input  wire        i_alu_b_imm,
    output wire        o_alu_b_imm,

    input  wire  [2:0] i_fcu_op,
    output wire  [2:0] o_fcu_op,

    input  wire i_rf_wen,
    output wire o_rf_wen,
    input  wire  [1:0] i_wb_op,
    output wire  [1:0] o_wb_op,

    input  wire i_dmem_ren,
    output wire o_dmem_ren,
    input  wire i_dmem_wen,
    output wire o_dmem_wen,

    input  wire [2:0] i_rX,
    output wire [2:0] o_rX,
    input  wire [2:0] i_rY,
    output wire [2:0] o_rY,
    input  wire [2:0] i_rO,
    output wire [2:0] o_rO,

    input  wire [15:0] i_vX,
    output wire [15:0] o_vX,
    input  wire [15:0] i_vY,
    output wire [15:0] o_vY,

    input  wire [15:0] i_imm16,
    output wire [15:0] o_imm16
);
    // TODO !!!
    wire write_en;
    assign write_en = 1'b1;

    register #(.WIDTH(1)) r_halt (
        .clk(clk), .rst(rst), .write_en(write_en),
        .write_data(i_halt & ~bubble), .read_data(o_halt)
    );

    register #(.WIDTH(4)) r_alu_op (
        .clk(clk), .rst(rst), .write_en(write_en),
        .write_data(i_alu_op), .read_data(o_alu_op)
    );

    register #(.WIDTH(1)) r_alu_b_imm (
        .clk(clk), .rst(rst), .write_en(write_en),
        .write_data(i_alu_b_imm), .read_data(o_alu_b_imm)
    );

    register #(.WIDTH(3)) r_fcu_op (
        .clk(clk), .rst(rst), .write_en(write_en),
        .write_data(i_fcu_op), .read_data(o_fcu_op)
    );


    // -- writeback control
    register #(.WIDTH(1)) r_rf_wen (
        .clk(clk), .rst(rst), .write_en(write_en),
        .write_data(i_rf_wen & ~bubble), .read_data(o_rf_wen)
    );

    register #(.WIDTH(2)) r_wb_op (
        .clk(clk), .rst(rst), .write_en(write_en),
        .write_data(i_wb_op), .read_data(o_wb_op)
    );

    // -- mem control
    register #(.WIDTH(1)) r_dmem_ren (
        .clk(clk), .rst(rst), .write_en(write_en),
        .write_data(i_dmem_ren & ~bubble), .read_data(o_dmem_ren)
    );

    register #(.WIDTH(1)) r_dmem_wen (
        .clk(clk), .rst(rst), .write_en(write_en),
        .write_data(i_dmem_wen & ~bubble), .read_data(o_dmem_wen)
    );

    // -- register numbers
    register #(.WIDTH(3)) r_rX (
        .clk(clk), .rst(rst), .write_en(write_en),
        .write_data(i_rX), .read_data(o_rX)
    );

    register #(.WIDTH(3)) r_rY (
        .clk(clk), .rst(rst), .write_en(write_en),
        .write_data(i_rY), .read_data(o_rY)
    );


    register #(.WIDTH(3)) r_rO (
        .clk(clk), .rst(rst), .write_en(write_en),
        .write_data(i_rO), .read_data(o_rO)
    );

    // -- register values
    register #(.WIDTH(16)) r_vX (
        .clk(clk), .rst(rst), .write_en(write_en),
        .write_data(i_vX), .read_data(o_vX)
    );

    register #(.WIDTH(16)) r_vY (
        .clk(clk), .rst(rst), .write_en(write_en),
        .write_data(i_vY), .read_data(o_vY)
    );

    // -- immediate value
    register #(.WIDTH(16)) r_imm16 (
        .clk(clk), .rst(rst), .write_en(write_en),
        .write_data(i_imm16), .read_data(o_imm16)
    );
endmodule
