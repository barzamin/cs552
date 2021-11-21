module decode (
	input  wire clk,
	input  wire rst,
	output wire err,

    // inputs from IF/ID
	input  wire [15:0] instr,
    input  wire [15:0] next_pc_basic,

    // loopback from MEM/WB
    input  wire        wb_rf_en,
    input  wire [2:0]  wb_reg,
    input  wire [15:0] wb_data,

    // outputs for downstream stages
    output wire [3:0]  alu_op,

    output wire [2:0]  rA,
    output wire [2:0]  rB,
    output wire [15:0] rA_v,
    output wire [15:0] rB_v,

    output reg  [15:0] imm16,

    output wire [2:0]  rDest
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
    wire [2:0] read1_reg, read2_reg, write_reg;
    rf register_file (
        .clk       (clk),
        .rst       (rst),

        .write_en  (wb_rf_en),
        .write_reg (wb_reg),
        .write_data(wb_data),

        .read1_reg (read1_reg),
        .read1_data(rA_v),

        .read2_reg (read2_reg),
        .read2_data(rB_v)
    );

    // -- muxing logic to generate rf register select signals
    //    signals:
    //     - instr_rformat: 1 - rformat, 0 - everything else. selects where we get rd from
    //     - link: are we linking? if yes, writeback to r7
    //     - writeto_rs: when high, write to rs instead of rd
    //     - readfrom_rd: when high, read from rd on rB_v instead of rt
    wire instr_rformat, link, writeto_rs, readfrom_rd;
    wire [2:0] rd_intermediate; // selected by format
    assign rd_intermediate = instr_rformat ? field_rd_rfmt : field_rd_ifmt;
    assign read1_reg = field_rs;
    assign read2_reg = readfrom_rd ? rd_intermediate : field_rt_rfmt;
    assign rDest  = link ? 3'h7 :
                    writeto_rs ? field_rs : rd_intermediate;


    // -- opcode decoding/control logic
    wire control_err;
    control control (
    	.opcode(opcode),
    	.op_ext(op_ext),

        .instr_rformat(instr_rformat),
        .writeto_rs   (writeto_rs),
        .readfrom_rd  (readfrom_rd),
        .link         (link),

        .err(control_err)
    );

    assign err = control_err; // TODO
endmodule
