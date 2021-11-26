module forwarder (
    // what we need in EX
    input  wire [2:0] EX_rX,
    input  wire [2:0] EX_rY,

    // what we have in EX/MEM and MEM/WB
    input  wire [2:0] MEM_rO,
    input  wire       MEM_rf_wen,
    input  wire [2:0] WB_rO,
    input  wire       WB_rf_wen,

    // what we need in MEM
    input  wire [2:0] MEM_rY,

    // control for EX-internal forwarding
    output wire [1:0] EX_fwd_X,
    output wire [1:0] EX_fwd_Y,

    // control for MEM forwarding
    output wire MEM_fwd_WB_vY
);
    `include "ops.vh"

    wire mem_has_EX_X, mem_has_EX_Y;
    assign mem_has_EX_X = MEM_rf_wen && (MEM_rO == EX_rX);
    assign mem_has_EX_Y = MEM_rf_wen && (MEM_rO == EX_rY);

    wire wb_has_EX_X, wb_has_EX_Y;
    assign wb_has_EX_X = WB_rf_wen && (WB_rO == EX_rX);
    assign wb_has_EX_Y = WB_rf_wen && (WB_rO == EX_rY);

    // note mem->ex takes priority over wb->ex
    assign EX_fwd_X = mem_has_EX_X ? FWDX_MEM :
                       wb_has_EX_X ? FWDX_WB
                                   : FWDX_PASS;
    assign EX_fwd_Y = mem_has_EX_Y ? FWDX_MEM :
                       wb_has_EX_Y ? FWDX_WB
                                   : FWDX_PASS;

    // fwd WB -> MEM if WB writes reg we're writing out of
    assign MEM_fwd_WB_vY = WB_rf_wen && (WB_rO == MEM_rY);
endmodule
