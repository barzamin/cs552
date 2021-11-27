module branch_controller (
    input  wire [1:0]  ID_flow_ty,
    input  wire [15:0] ID_dbranch_tgt,

    input  wire [1:0]  EX_flow_ty,
    input  wire [15:0] EX_dbranch_tgt,
    input  wire [15:0] EX_alu_out,     // for ALU-computed branches
    input  wire        EX_flag,

    output wire        IF_rewrite_pc,
    output wire [15:0] IF_pc_rewrite_to,
    output wire        flush_if2id,
    output wire        flush_id2ex
);
    `include "ops.vh"
    wire early_resteer, late_resteer;

    assign early_resteer = (ID_flow_ty == FLOW_JUMP);

    assign late_resteer = ((EX_flow_ty == FLOW_COND) && EX_flag)
                         || EX_flow_ty == FLOW_ALU;


    assign IF_pc_rewrite_to = (ID_flow_ty == FLOW_ALU) ? EX_alu_out : ID_dbranch_tgt;
    assign IF_rewrite_pc    = early_resteer | late_resteer;
    assign flush_if2id      = early_resteer | late_resteer;
    assign flush_id2ex      = late_resteer;
endmodule
