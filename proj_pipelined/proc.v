/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module proc (/*AUTOARG*/
   // Outputs
   err, 
   // Inputs
   clk, rst
);

    input wire clk;
    input wire rst;

    output wire err;

    // None of the above lines can be modified
    // but i did anyway. because karu wrote this in 2009 and apparently didn't think nettypes were important??

    wire IF_err, ID_err, EX_err, MEM_err, WB_err;
    // compute an error signal for debugging bad states
    assign err = |{IF_err, ID_err, EX_err, MEM_err, WB_err};


    // IF -> ID -> EX -> MEM -> WB

    // ==== notes: ====
    // 
    // branches are predicted in IF, and resolved in EX;
    // this means we will need to squash two instructions each time we mispredict a branch.

    wire freeze_pc, freeze_if2id, bubble_id2ex;

    // -- INSTRUCTION FETCH
    wire [15:0] IF_next_pc_basic;
    wire [15:0] IF_instr;
    fetch fetch (
        .clk              (clk),
        .rst              (rst),
        .freeze_pc        (freeze_pc),
        .err              (IF_err),
        .next_pc_displaced(/*TODO*/),
        .next_pc_basic    (IF_next_pc_basic),
        .instr            (IF_instr)
    );

    // -- BOUNDARY: IF/ID
    wire [15:0] ID_next_pc_basic;
    wire [15:0] ID_instr;
    flop_if2id fl_if2id (
        .clk            (clk),
        .rst            (rst),
        .write_en       (~freeze_if2id),

        .i_next_pc_basic(IF_next_pc_basic),
        .o_next_pc_basic(ID_next_pc_basic),

        .i_instr        (IF_instr),
        .o_instr        (ID_instr)
    );

    // -- INSTRUCTION DECODE
    wire ID_halt;
    wire [15:0] ID_vX, ID_vY;
    wire [2:0]  ID_rX, ID_rY, ID_rO;
    wire [15:0] ID_imm16;
    wire [3:0]  ID_alu_op;
    wire        ID_alu_b_imm;
    wire [2:0]  ID_fcu_op;
    wire [1:0]  ID_wb_op;
    wire        ID_dmem_ren, ID_dmem_wen;
    wire        ID_rf_wen;
    // -- loopbacks
    wire        WB_rf_wen;
    wire [2:0]  WB_rO;
    wire [15:0] WB_wb_data;
    decode decode (
        .clk          (clk),
        .rst          (rst),
        .err          (ID_err),

        .halt         (ID_halt),

        .next_pc_basic(ID_next_pc_basic),
        .instr        (ID_instr),

        .rX           (ID_rX),
        .rY           (ID_rY),
        .rO           (ID_rO),
        .vX           (ID_vX),
        .vY           (ID_vY),
        .imm16        (ID_imm16),

        .alu_op       (ID_alu_op),
        .alu_b_imm    (ID_alu_b_imm),
        .fcu_op       (ID_fcu_op),

        .rf_wen       (ID_rf_wen),
        .wb_op        (ID_wb_op),

        .dmem_ren     (ID_dmem_ren),
        .dmem_wen     (ID_dmem_wen),

        // -- writeback loopbacks for write port on rf
        .WB_rf_wen    (WB_rf_wen),
        .WB_rO        (WB_rO),
        .WB_wb_data   (WB_wb_data)
    );

    // -- BOUNDARY: ID/EX
    wire [3:0]  ID2EX_alu_op;
    wire        ID2EX_alu_b_imm;
    wire [2:0]  ID2EX_fcu_op;

    wire [2:0]  ID2EX_rX, ID2EX_rY, ID2EX_rO;
    wire [15:0] ID2EX_vX, ID2EX_vY;
    wire [15:0] ID2EX_imm16;
    wire        ID2EX_halt;

    wire [1:0]  ID2EX_wb_op;

    wire        ID2EX_dmem_wen, ID2EX_dmem_ren;
    wire        ID2EX_rf_wen;

    flop_id2ex fl_id2ex (
        .clk        (clk),
        .rst        (rst),
        .bubble     (bubble_id2ex),

        .i_halt     (ID_halt),
        .o_halt     (ID2EX_halt),

        .i_alu_op   (ID_alu_op),
        .o_alu_op   (ID2EX_alu_op),
        .i_alu_b_imm(ID_alu_b_imm),
        .o_alu_b_imm(ID2EX_alu_b_imm),

        .i_fcu_op   (ID_fcu_op),
        .o_fcu_op   (ID2EX_fcu_op),

        .i_rf_wen   (ID_rf_wen),
        .o_rf_wen   (ID2EX_rf_wen),
        .i_wb_op    (ID_wb_op),
        .o_wb_op    (ID2EX_wb_op),

        .i_dmem_ren (   ID_dmem_ren),
        .o_dmem_ren (ID2EX_dmem_ren),
        .i_dmem_wen (   ID_dmem_wen),
        .o_dmem_wen (ID2EX_dmem_wen),

        .i_imm16    (ID_imm16),
        .o_imm16    (ID2EX_imm16),

        // rX, rY, rO
        .i_rX       (ID_rX),
        .o_rX       (ID2EX_rX),
        .i_rY       (ID_rY),
        .o_rY       (ID2EX_rY),
        .i_rO       (ID_rO),
        .o_rO       (ID2EX_rO),

        // vX, vY
        .i_vX       (ID_vX),
        .o_vX       (ID2EX_vX),
        .i_vY       (ID_vY),
        .o_vY       (ID2EX_vY)
    );

    // -- EXECUTE
    wire [15:0] EX_alu_out;
    // -- forwarding control
    wire [1:0] EX_fwd_X, EX_fwd_Y;
    // -- needed for MEM->EX fwd path
    wire [15:0] EX2MEM_alu_out;
    // -- (possibly) forwarded version
    wire [15:0] EX_vY;
    execute execute (
        .err      (EX_err),

        .alu_op   (ID2EX_alu_op),
        .alu_b_imm(ID2EX_alu_b_imm),
        .fcu_op   (ID2EX_fcu_op),

        .vX       (ID2EX_vX),
        .vY       (ID2EX_vY),
        .imm16    (ID2EX_imm16),

        .alu_out  (EX_alu_out),

        // -- forwarding control
        .fwd_X      (EX_fwd_X),
        .fwd_Y      (EX_fwd_Y),

        // -- forwarding datapaths
        .WB_wb_data (WB_wb_data),
        .MEM_alu_out(EX2MEM_alu_out),

        // -- potentially forwarded vY to pass down
        .EX_vY      (EX_vY)
    );

    // -- BOUNDARY: EX/MEM
    wire EX2MEM_halt;
    wire [1:0]  EX2MEM_wb_op;
    wire [2:0] EX2MEM_rY;
    wire [15:0] EX2MEM_vY;
    wire EX2MEM_dmem_ren, EX2MEM_dmem_wen;
    wire [2:0] EX2MEM_rO;
    wire EX2MEM_rf_wen;
    flop_ex2mem fl_ex2mem (
        .clk   (clk),
        .rst   (rst),

        .i_halt(ID2EX_halt),
        .o_halt(EX2MEM_halt),

        .i_wb_op(ID2EX_wb_op),
        .o_wb_op(EX2MEM_wb_op),

        .i_alu_out(EX_alu_out),
        .o_alu_out(EX2MEM_alu_out),

        // todo use forwarded ver. note(petra) is this even relevnt anymore? since we select forwarded vY (from WB) in MEM
        // NOPE THIS IS IMPORTANT LMFAO
        .i_rY(ID2EX_rY),
        .o_rY(EX2MEM_rY),
        .i_vY(EX_vY),
        .o_vY(EX2MEM_vY),

        .i_dmem_ren(ID2EX_dmem_ren),
        .o_dmem_ren(EX2MEM_dmem_ren),
        .i_dmem_wen(ID2EX_dmem_wen),
        .o_dmem_wen(EX2MEM_dmem_wen),

        .i_rO(ID2EX_rO),
        .o_rO(EX2MEM_rO),
        .i_rf_wen(ID2EX_rf_wen),
        .o_rf_wen(EX2MEM_rf_wen)
    );

    // -- MEMORY
    wire [15:0] MEM_dmem_out;
    wire MEM_fwd_WB_vY;
    memory memory (
        .clk       (clk),
        .rst       (rst),
        .err       (MEM_err),
        .halt      (EX2MEM_halt),

        .addr      (EX2MEM_alu_out),

        .read_en   (EX2MEM_dmem_ren),
        .read_data (MEM_dmem_out),
        .write_en  (EX2MEM_dmem_wen),
        .vY        (EX2MEM_vY),

        // -- forwarding
        .fwd_WB_vY (MEM_fwd_WB_vY),
        .WB_wb_data(WB_wb_data)
    );

    // -- BOUNDARY: MEM/WB
    wire [1:0]  MEM2WB_wb_op;
    wire [15:0] MEM2WB_alu_out;
    wire [15:0] MEM2WB_dmem_out;
    wire [15:0] MEM2WB_link_pc; // todo
    wire        MEM2WB_flag;
    // wire [2:0]  MEM2WB_rO;
    // wire        MEM2WB_rf_wen;
    flop_mem2wb fl_mem2wb (
        .clk(clk),
        .rst(rst),

        .i_wb_op   (EX2MEM_wb_op),
        .o_wb_op   (MEM2WB_wb_op),

        .i_dmem_out(MEM_dmem_out),
        .o_dmem_out(MEM2WB_dmem_out),

        .i_alu_out(EX2MEM_alu_out),
        .o_alu_out(MEM2WB_alu_out),

        .i_rO(EX2MEM_rO),
        .o_rO(WB_rO),
        .i_rf_wen(EX2MEM_rf_wen),
        .o_rf_wen(WB_rf_wen)
    );

    // -- WRITEBACK
    writeback writeback (
        .err(WB_err),

        .wb_op   (MEM2WB_wb_op),
        .alu_out (MEM2WB_alu_out),
        .dmem_out(MEM2WB_dmem_out),
        .link_pc (MEM2WB_link_pc),
        .flag    (MEM2WB_flag),

        .wb_data (WB_wb_data)
    );

    // ---- FORWARDING CONTROL UNIT ----
    forwarder i_forwarder (
        .EX_rX     (ID2EX_rX),
        .EX_rY     (ID2EX_rY),
        .MEM_rO    (EX2MEM_rO),
        .MEM_rf_wen(EX2MEM_rf_wen),
        .WB_rO     (WB_rO),
        .WB_rf_wen (WB_rf_wen),
        .MEM_rY    (EX2MEM_rY),

        .EX_fwd_X  (EX_fwd_X),
        .EX_fwd_Y  (EX_fwd_Y),
        .MEM_fwd_WB_vY(MEM_fwd_WB_vY)
    );


    // ---- HAZARD IDENTIFICATION UNIT ----
    hazard hazard (
        .ID_rX       (ID_rX),
        .ID_rY       (ID_rY),
        .EX_dmem_ren(ID2EX_dmem_ren),
        .EX_rO       (ID2EX_rO),

        .freeze_pc   (freeze_pc),
        .freeze_if2id(freeze_if2id),
        .bubble_id2ex(bubble_id2ex)
    );

endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
