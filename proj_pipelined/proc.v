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
    //
    // !!!! TODO !!!!
    // - rethink naming conventions


    // -- INSTRUCTION FETCH
    wire [15:0] IF_next_pc_basic;
    wire [15:0] IF_instr;
    fetch fetch (
        .clk              (clk),
        .rst              (rst),
        .err              (IF_err),
        .next_pc_displaced(/*TODO*/),
        .next_pc_basic    (IF_next_pc_basic),
        .instr            (IF_instr)
    );

    // -- BOUNDARY: IF/ID
    wire [15:0] ID_next_pc_basic;
    wire [15:0] ID_instr;
    flop_if2id fl_if2id (
        .clk(clk),
        .rst(rst),

        .i_next_pc_basic(IF_next_pc_basic),
        .o_next_pc_basic(ID_next_pc_basic),

        .i_instr(IF_instr),
        .o_instr(ID_instr)
    );

    // -- INSTRUCTION DECODE
    wire [15:0] ID_vX, ID_vY;
    wire [2:0]  ID_rX, ID_rY, ID_rO;
    wire [15:0] ID_imm16;
    wire [3:0]  ID_alu_op;
    wire        ID_alu_b_imm;
    decode decode (
        .clk          (clk),
        .rst          (rst),
        .err          (ID_err),

        .next_pc_basic(ID_next_pc_basic),
        .instr        (ID_instr),

        .rX           (ID_rX),
        .rY           (ID_rY),
        .rO           (ID_rO),
        .vX           (ID_vX),
        .vY           (ID_vY),
        .imm16        (ID_imm16),

        // .wb_rf_en     (wb_rf_en),
        // .wb_reg       (wb_reg),
        // .wb_data      (wb_data),

        .alu_op       (ID_alu_op),
        .alu_b_imm    (ID_alu_b_imm)
    );

    // -- BOUNDARY: ID/EX
    wire [3:0]  ID2EX_alu_op;

    wire [2:0]  ID2EX_rX, ID2EX_rY, ID2EX_rO;
    wire [15:0] ID2EX_vX, ID2EX_vY;
    wire [15:0] ID2EX_imm16;
    wire ID2EX_alu_b_imm;

    flop_id2ex fl_id2ex (
        .clk(clk),
        .rst(rst),

        .i_alu_op(ID_alu_op),
        .o_alu_op(ID2EX_alu_op),


        .i_alu_b_imm(ID_alu_b_imm),
        .o_alu_b_imm(ID2EX_alu_b_imm),
        .i_imm16    (ID_imm16),
        .o_imm16    (ID2EX_imm16),

        // rX, rY, rO
        .i_rX(ID_rX),
        .o_rX(ID2EX_rX),
        .i_rY(ID_rY),
        .o_rY(ID2EX_rY),
        .i_rO(ID_rO),
        .o_rO(ID2EX_rO),

        // vX, vY
        .i_vX(ID_vX),
        .o_vX(ID2EX_vX),
        .i_vY(ID_vY),
        .o_vY(ID2EX_vY)
    );

    // -- EXECUTE
    execute execute (
        .err   (EX_err),

        .alu_op   (ID2EX_alu_op),
        .alu_b_imm(ID2EX_alu_b_imm),

        .vX    (ID2EX_vX),
        .vY    (ID2EX_vY),
        .imm16 (ID2EX_imm16)
    );

    // -- BOUNDARY: EX/MEM
    flop_ex2mem fl_ex2mem (
        .clk(clk),
        .rst(rst)
    );

    // -- MEMORY
    memory memory (
        .clk       (clk),
        .rst       (rst),
        .err       (MEM_err),

        .addr      (addr),

        .read_en   (read_en),
        .read_data (read_data),
        .write_en  (write_en),
        .write_data(write_data),


        .halt      (EX2MEM_halt)
    );

    // -- BOUNDARY: MEM/WB
    flop_mem2wb fl_mem2wb (
        .clk(clk),
        .rst(rst)
    );

    // -- WRITEBACK
    writeback writeback (
        .err(WB_err)
    );

    // ---- HAZARD COMPUTATION UNIT ----
    hazard hazard (
    );
endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
