module forwarder (
    // what we need in EX
    input  wire [2:0] EX_rX,
    input  wire [2:0] EX_rY,

    // what we have in EX/MEM and MEM/WB
    input  wire [2:0] MEM_rO,
    input  wire       MEM_rf_wen,
    input  wire [2:0] WB_rO,
    input  wire       WB_rf_wen,

    // control for EX-internal forwarding
    output wire [1:0] fwd_X,
    output wire [1:0] fwd_Y
);
    `include "ops.vh"

    wire mem_has_X, mem_has_Y;
    assign mem_has_X = MEM_rf_wen && (MEM_rO == EX_rX);
    assign mem_has_Y = MEM_rf_wen && (MEM_rO == EX_rY);

    wire wb_has_X, wb_has_Y;
    assign wb_has_X = WB_rf_wen && (WB_rO == EX_rX);
    assign wb_has_Y = WB_rf_wen && (WB_rO == EX_rY);

    // note mem->ex takes priority over wb->ex
    assign fwd_X = mem_has_X ? FWDX_MEM :
                    wb_has_X ? FWDX_WB
                             : FWDX_PASS;
    assign fwd_Y = mem_has_Y ? FWDX_MEM :
                    wb_has_Y ? FWDX_WB
                             : FWDX_PASS;
endmodule
