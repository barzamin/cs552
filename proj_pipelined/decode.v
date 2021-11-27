`default_nettype none
module decode (
	input  wire clk,
	input  wire rst,
	output wire err,

    // inputs from IF/ID
	input  wire [15:0] instr,
    input  wire [15:0] next_pc_basic,

    // loopback from MEM/WB
    input  wire        WB_rf_wen,
    input  wire [2:0]  WB_rO,
    input  wire [15:0] WB_wb_data,

    // outputs for downstream stages
    output wire [3:0]  alu_op,
    output wire        alu_b_imm, // when 1, alu b input is muxed to imm16 instead of vY
    output wire [2:0]  fcu_op,

    output wire [1:0]  wb_op,
    output wire writeflag,

    output wire dmem_ren,
    output wire dmem_wen,

    output wire rf_wen,

    output wire [2:0]  rX,  // register number for reg file X sel
    output wire [2:0]  rY,  // register number for reg file Y sel
    output wire [2:0]  rO,  // register to write back into
    output wire [15:0] vX,  // value from rf for rX
    output wire [15:0] vY,  // value from rf for rY

    output reg  [15:0] imm16, // sign/zero-extended imm or displacement

    output wire [1:0] flow_ty,
    output wire [15:0] dbranch_tgt,

    output wire halt
);
    // (nearly) all control op defs
    `include "ops.vh"

    // -- pull out some fields
    wire [4:0] opcode;
    wire [1:0] op_ext; // extended 2 bits at the LSB of the instruction, used as an additional function code for some arithmetic instructions.
    assign opcode = instr[15:11];
    assign op_ext = instr[1:0];

    wire [4:0] imm5;
    wire [7:0] imm8;
    wire [10:0] disp11;
    assign imm5   = instr[4:0];
    assign imm8   = instr[7:0];
    assign disp11 = instr[10:0];

    wire [2:0] field_rs, field_rt_rfmt, field_rd_rfmt, field_rd_ifmt;
    assign field_rs      = instr[10:8];
    assign field_rt_rfmt = instr[7:5];
    assign field_rd_rfmt = instr[4:2];
    assign field_rd_ifmt = instr[7:5];

    // -- imm16 extension/computation
    wire [2:0] immcode;
    always @* case (immcode)
        IMMC_ZIMM5 : imm16 = {11'b0, imm5}; // zero extend
        IMMC_SIMM5 : imm16 = {{11{imm5[4]}}, imm5}; // sign extend
        IMMC_ZIMM8 : imm16 = {8'b0, imm8}; // zero extend
        IMMC_SIMM8 : imm16 = {{8{imm8[7]}}, imm8}; // sign extend
        default    : imm16 = {{5{disp11[10]}}, disp11}; // sign extended displacement; IMMC_DISPL = 3'b100 but we don't-care
    endcase

    // -- register file
    rf_bypassed register_file (
        .clk       (clk),
        .rst       (rst),

        .write_en  (WB_rf_wen),
        .write_reg (WB_rO),
        .write_data(WB_wb_data),

        .read1_reg (rX),
        .read1_data(vX),

        .read2_reg (rY),
        .read2_data(vY)
    );

    // -- muxing logic to generate rf register select signals
    //    signals:
    //     - instr_rformat: 1 - rformat, 0 - everything else. selects where we get rd from
    //     - link: are we linking? if yes, writeback to r7
    //     - writeto_rs: when high, write to rs instead of rd
    //     - readfrom_rd: when high, read from rd on rY instead of rt
    wire instr_rformat, link, writeto_rs, readfrom_rd;
    wire [2:0] rd_intermediate; // selected by format
    assign rd_intermediate = instr_rformat ? field_rd_rfmt : field_rd_ifmt;
    assign rX = field_rs;
    assign rY = readfrom_rd ? rd_intermediate : field_rt_rfmt;
    assign rO = link ? 3'h7 :
          writeto_rs ? field_rs : rd_intermediate;


    // -- compute branch target
    adder16 i_adder16 (
        .A   (next_pc_basic),
        .B   (imm16),
        .Cin (1'b0),
        .S   (dbranch_tgt),
        .Cout()
    );

    // -- opcode decoding/control logic
    wire control_err;
    control control (
    	.opcode(opcode),
    	.op_ext(op_ext),

        .instr_rformat(instr_rformat),
        .writeto_rs   (writeto_rs),
        .readfrom_rd  (readfrom_rd),
        .link         (link),
        .immcode      (immcode),

        .alu_op       (alu_op),
        .alu_b_imm    (alu_b_imm),

        .fcu_op       (fcu_op),
        .wb_op        (wb_op),
        .writeflag    (writeflag),

        .dmem_ren     (dmem_ren),
        .dmem_wen     (dmem_wen),
        .rf_write_en  (rf_wen),

        .flow_ty      (flow_ty),

        .halt         (halt),

        .err          (control_err)
    );

    assign err = control_err; // TODO
endmodule
