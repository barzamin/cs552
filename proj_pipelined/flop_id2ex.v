module flop_id2ex(
    input  wire clk,
    input  wire rst,
    input  wire bubble,
    input  wire force_basic_flow,

    input  wire i_halt,
    output wire o_halt,

    input  wire  [3:0] i_alu_op,
    output wire  [3:0] o_alu_op,
    input  wire        i_alu_b_imm,
    output wire        o_alu_b_imm,

    input  wire  [2:0] i_fcu_op,
    output wire  [2:0] o_fcu_op,

    input  wire [1:0] i_flow_ty,
    output wire [1:0] o_flow_ty,
    input  wire [15:0] i_dbranch_tgt,
    output wire [15:0] o_dbranch_tgt,

    input  wire [15:0] i_link_pc,
    output wire [15:0] o_link_pc,

    input  wire i_siic,
    output wire o_siic,
    input  wire i_rti,
    output wire o_rti,

    input  wire i_rf_wen,
    output wire o_rf_wen,
    input  wire  [1:0] i_wb_op,
    output wire  [1:0] o_wb_op,
    input  wire i_writeflag,
    output wire o_writeflag,

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
    `include "ops.vh"
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

    register #(.WIDTH(2)) r_flow_ty (
        .clk(clk), .rst(rst), .write_en(write_en),
        .write_data((bubble || force_basic_flow) ? FLOW_BASIC : i_flow_ty), .read_data(o_flow_ty)
    );

    register #(.WIDTH(16)) r_dbranch_tgt (
        .clk(clk), .rst(rst), .write_en(write_en),
        .write_data(i_dbranch_tgt), .read_data(o_dbranch_tgt)
    );

    register #(.WIDTH(16)) r_link_pc (
        .clk(clk), .rst(rst), .write_en(write_en),
        .write_data(i_link_pc), .read_data(o_link_pc)
    );

    register #(.WIDTH(1)) r_siic (
        .clk(clk), .rst(rst), .write_en(write_en),
        .write_data(i_siic & ~bubble), .read_data(o_siic)
    );

    register #(.WIDTH(1)) r_rti (
        .clk(clk), .rst(rst), .write_en(write_en),
        .write_data(i_rti & ~bubble), .read_data(o_rti)
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

    register #(.WIDTH(1)) r_writeflag (
        .clk(clk), .rst(rst), .write_en(write_en),
        .write_data(i_writeflag & ~bubble), .read_data(o_writeflag)
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
