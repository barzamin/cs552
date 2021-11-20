`default_nettype none
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

    // compute an err signal for debugging bad states
    wire fetch_err, decode_err, exec_err, mem_err, wb_err;
    assign err = fetch_err | decode_err | exec_err | mem_err | wb_err;

    // -- FETCH
    wire [15:0] instr;   // current instruction
    wire [15:0] pc;      // current pc
    wire [15:0] next_pc; // next pc to read; looped back to FETCH
    fetch fetch (
        .rst    (rst),
        .clk    (clk),
        .err    (fetch_err),

        .next_pc(next_pc),

        .instr  (instr),
        .pc     (pc)
    );

    // -- DECODE
    wire halt; // TODO! asserted when the processor is halting
    wire [3:0] alu_op;   // alu opcode. sent to EXECUTE
    wire [2:0] fcu_op;   // flag computation unit opcode. sent to EXECUTE
    wire [1:0] wb_op;    // writeback operation for WRITEBACK stage
    wire [15:0] wb_data; // loops back from WRITEBACK stage (well, not "stage" b/c this is unpipelined, but)
    wire [1:0] flow_ty;
    wire [15:0] next_pc_basic, next_pc_taken;
    wire mem_read_en, mem_write_en;
    wire alu_b_imm;
    wire [15:0] regv_1, regv_2, imm16; // register and immediate data
    decode decode (
        .rst          (rst),
        .clk          (clk),
        .err          (decode_err),

        .pc           (pc),
        .instr        (instr),

        .halt         (halt),

        .alu_op       (alu_op),
        .fcu_op       (fcu_op),

        .regv_1       (regv_1),
        .regv_2       (regv_2),
        .imm16        (imm16),

        .flow_ty      (flow_ty),
        .next_pc_basic(next_pc_basic),
        .next_pc_taken(next_pc_taken),

        .alu_b_imm    (alu_b_imm),

        .mem_read_en  (mem_read_en),
        .mem_write_en (mem_write_en),

        .wb_op        (wb_op),
        .wb_data      (wb_data)
    );

    // -- EXECUTE
    wire flag; // current flag, used for Sxx instructions and conditional branches
    wire [15:0] alu_out;
    execute execute (
        .err          (exec_err),

        .flag         (flag),
        .alu_op       (alu_op),
        .fcu_op       (fcu_op),

        .regv_1       (regv_1),
        .regv_2       (regv_2),
        .imm16        (imm16),

        .flow_ty      (flow_ty),
        .next_pc_basic(next_pc_basic),
        .next_pc_taken(next_pc_taken),

        .alu_b_imm    (alu_b_imm),

        .alu_out      (alu_out),
        .next_pc      (next_pc)
    );

    // -- MEMORY
    wire [15:0] mem_out;
    memory memory (
        .clk       (clk),
        .rst       (rst),
        .err       (mem_err),
        .halt      (halt),

        .addr      (alu_out), // we always use the ALU output to index M
        .read_en   (mem_read_en),
        .write_en  (mem_write_en),
        .read_data (mem_out),
        .write_data(regv_2)
    );

    // -- WRITEBACK
    writeback writeback (
        .err          (wb_err),

        .wb_op        (wb_op),
        .next_pc_basic(next_pc_basic),
        .flag         (flag),
        .alu_out      (alu_out),
        .mem_out      (mem_out),

        .wb_data      (wb_data)
    );
endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
