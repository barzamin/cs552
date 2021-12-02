module branch_controller (
    output wire err,

    input  wire [1:0]  ID_flow_ty,
    input  wire [15:0] ID_dbranch_tgt,

    input  wire [1:0]  EX_flow_ty,
    input  wire [15:0] EX_dbranch_tgt,
    input  wire [15:0] EX_alu_out,     // for ALU-computed branches
    input  wire        EX_flag,

    output wire        IF_rewrite_pc,
    output wire [15:0] IF_pc_rewrite_to,
    output wire        flush_if2id,
    output wire        flush_id2ex,

    output wire        force_bflow_id2ex
);
    `include "ops.vh"
    wire early_resteer, late_resteer;

    // can't do an early resteer if we have an older branch we're waiting on
    assign early_resteer = (ID_flow_ty == FLOW_JUMP) && (EX_flow_ty == FLOW_BASIC);

    assign force_bflow_id2ex = early_resteer; // don't resteer twice (can't just kill b/c JAL)

    assign late_resteer = ((EX_flow_ty == FLOW_COND) && EX_flag)
                         || EX_flow_ty == FLOW_ALU
                         || EX_flow_ty == FLOW_JUMP;

    assign err = early_resteer && late_resteer; // can't do both

    assign IF_pc_rewrite_to = early_resteer ? ID_dbranch_tgt : // else late
                   (EX_flow_ty == FLOW_ALU) ? EX_alu_out
                                            : EX_dbranch_tgt;

    assign IF_rewrite_pc    = early_resteer | late_resteer;
    assign flush_if2id      = early_resteer | late_resteer;
    assign flush_id2ex      = late_resteer;
endmodule
