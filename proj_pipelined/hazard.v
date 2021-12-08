// hazard unit; checks current pipeline state for hazards requiring stalling
module hazard (
    input  wire [2:0] ID_rX,
    input  wire [2:0] ID_rY,
    input  wire       EX_dmem_ren,
    input  wire [2:0] EX_rO,

    output wire       freeze_pc,
    output wire       freeze_if2id,
    output wire       bubble_id2ex
);
    wire dep_X, dep_Y;
    assign dep_X = ID_rX == EX_rO;
    assign dep_Y = ID_rY == EX_rO;

    // EX needs the result of a MEM read; we need to stall one cycle for memory result
    wire stall;
    assign stall = EX_dmem_ren && (dep_X || dep_Y);

    assign freeze_pc = stall;
    assign freeze_if2id = stall;
    assign bubble_id2ex = stall;
endmodule
