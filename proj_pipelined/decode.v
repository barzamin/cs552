module decode (
	input  wire clk,
	input  wire rst,
	output wire err,

	input  wire [15:0] instr,
    input  wire [15:0] next_pc_basic,
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

    // -- muxing logic to generate rf register select signals
    //    signals:
    //     - instr_rformat: 1 - rformat, 0 - everything else. selects where we get rd from
    //     - link: are we linking? if yes, writeback to r7
    //     - writeto_rs: when high, write to rs instead of rd
    //     - readfrom_rd: when high, read from rd on regv_2 instead of rt
    wire instr_rformat, link, writeto_rs, readfrom_rd;
    wire [2:0] rd_intermediate; // selected by format
    assign rd_intermediate = instr_rformat ? field_rd_rfmt : field_rd_ifmt;
    assign read1_reg = field_rs;
    assign read2_reg = readfrom_rd ? rd_intermediate : field_rt_rfmt;
    assign rf_write_reg = link ? 3'h7 :
                    writeto_rs ? field_rs : rd_intermediate;


    // -- register file
    rf register_file (
        .clk       (clk),
        .rst       (rst),

        .write_en  (rf_write_en),
        .write_reg (write_reg),
        .write_data(write_data),

        .read1_reg (read1_reg),
        .read1_data(read1_data),

        .read2_reg (read2_reg),
        .read2_data(read2_data)
    );

    // -- opcode decoding/control logic
    control control (
    	.opcode(opcode),
    	.op_ext(op_ext),

        .instr_rformat(instr_rformat),
        .writeto_rs   (writeto_rs),
        .readfrom_rd  (readfrom_rd),
        .link         (link),    	
    );
endmodule