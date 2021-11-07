`default_nettype none
module decode (
    input  wire clk,
    input  wire rst,
    output reg err,

    input  wire [15:0] instr,
    input  wire [15:0] pc,

    output reg  [1:0]  wb_op,
    input  wire [15:0] wb_data,

    output reg [3:0] alu_op,
    output reg [2:0] fcu_op,

    output wire [15:0] regv_1,
    output wire [15:0] regv_2,
    output reg  [15:0] imm16,

    output reg  [1:0] flow_ty,
    output wire [15:0] next_pc_basic,
    output wire [15:0] next_pc_taken,

    output reg alu_b_imm,

    output reg halt
);
    // (nearly) all control op defs
    `include "ops.vh"

    // -- register file
    wire [2:0] rf_write_reg, read1_reg, read2_reg;
    reg rf_write_en;
    rf register_file (
        .clk       (clk),
        .rst       (rst),

        .write_en  (rf_write_en),
        .write_reg (rf_write_reg),
        .write_data(wb_data),

        .read1_reg (read1_reg),
        .read1_data(regv_1),

        .read2_reg (read2_reg),
        .read2_data(regv_2)
    );

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

    // -- select logic for rf regselects
    reg instr_rformat; // 1 - rformat, 0 - everything else
    reg writeto_rs;
    wire [2:0] rd_intermediate; // selected by format
    assign rd_intermediate = instr_rformat ? field_rd_rfmt : field_rd_ifmt;
    assign read1_reg = field_rs; // TODO
    assign read2_reg = field_rt_rfmt; // TODO
    assign rf_write_reg = writeto_rs ? field_rs : rd_intermediate;

    // -- imm16 computation
    reg [1:0] immcode;
    localparam IMMC_ZIMM5 = 3'b000;
    localparam IMMC_SIMM5 = 3'b010;
    localparam IMMC_ZIMM8 = 3'b001;
    localparam IMMC_SIMM8 = 3'b011;
    localparam IMMC_DISPL = 3'b100;

    always @* casex (immcode)
        IMMC_ZIMM5 : imm16 = {11'b0, imm5}; // zero extend
        IMMC_SIMM5 : imm16 = {{11{imm5[4]}}, imm5}; // sign extend
        IMMC_ZIMM8 : imm16 = {8'b0, imm8}; // zero extend
        IMMC_SIMM8 : imm16 = {{8{imm8[7]}}, imm8}; // sign extend
        default    : imm16 = {{5{disp11[10]}}, disp11}; // sign extended displacement; IMMC_DISPL = 3'b100 but we don't-care
    endcase

    // -- PC computation
    wire [15:0] joffset;
    assign joffset = imm16;
    pccomputer pccomputer (
        .pc           (pc),
        .joffset      (joffset),
        .next_pc_basic(next_pc_basic),
        .next_pc_taken(next_pc_taken)
    );

    // -- select logic
    always @* begin
        // defaults to prevent latching. note some are arbitrary
        halt = 1'b0;
        err = 1'b0;
        alu_op = ALU_PSA;
        fcu_op = FCU_EQ;
        flow_ty = FLOW_BASIC;
        immcode = IMMC_ZIMM5;
        instr_rformat = 1'b0;
        rf_write_en = 1'b0;
        writeto_rs = 1'b0;
        alu_b_imm = 1'b0;
        wb_op = WB_ALU;

        case (opcode)
            OP_HALT : begin
                halt = 1'b1; // TODO
            end

            OP_NOP : begin
                // nop :)
            end

            // immediate arithmetic
            OP_ADDI : begin
                alu_op = ALU_ADD;
                rf_write_en = 1'b1;
                immcode = IMMC_SIMM5;
                alu_b_imm = 1'b1;
            end
            OP_SUBI : begin
                alu_op = ALU_SUB;
                rf_write_en = 1'b1;
                immcode = IMMC_SIMM5;
                alu_b_imm = 1'b1;
            end
            OP_XORI : begin
                alu_op = ALU_XOR;
                rf_write_en = 1'b1;
                immcode = IMMC_ZIMM5;
                alu_b_imm = 1'b1;
            end
            OP_ANDNI : begin
                alu_op = ALU_ANDN;
                rf_write_en = 1'b1;
                immcode = IMMC_ZIMM5;
                alu_b_imm = 1'b1;
            end
            OP_ROLI : begin
                alu_op = ALU_ROL;
                rf_write_en = 1'b1;
                immcode = IMMC_ZIMM5;
                alu_b_imm = 1'b1;
            end
            OP_SLLI : begin
                alu_op = ALU_SLL;
                rf_write_en = 1'b1;
                immcode = IMMC_ZIMM5;
                alu_b_imm = 1'b1;
            end
            OP_RORI : begin
                alu_op = ALU_ROR;
                rf_write_en = 1'b1;
                immcode = IMMC_ZIMM5;
                alu_b_imm = 1'b1;
            end
            OP_SRLI : begin
                alu_op = ALU_SRL;
                rf_write_en = 1'b1;
                immcode = IMMC_ZIMM5;
                alu_b_imm = 1'b1;
            end

            // non-immediate arithmetic
            OP_BTR : begin
                alu_op = ALU_BTR;
                instr_rformat = 1'b1;
                rf_write_en = 1'b1;
            end

            OP_ARITH : begin
                instr_rformat = 1'b1;
                case (op_ext)
                    2'b00 : alu_op = ALU_ADD;
                    2'b01 : alu_op = ALU_SUB;
                    2'b10 : alu_op = ALU_XOR;
                    2'b11 : alu_op = ALU_ANDN;
                endcase
                rf_write_en = 1'b1;
            end

            OP_ROLL : begin
                instr_rformat = 1'b1;
                case (op_ext)
                    2'b00 : alu_op = ALU_ROL;
                    2'b01 : alu_op = ALU_SLL;
                    2'b10 : alu_op = ALU_ROR;
                    2'b11 : alu_op = ALU_SRL;
                endcase
                rf_write_en = 1'b1;
            end

            // flag-setting instructions
            OP_SEQ : begin
                instr_rformat = 1'b1;
                alu_op = ALU_SUB;
                fcu_op = FCU_EQ;
                rf_write_en = 1'b1;
            end
            OP_SLT : begin
                instr_rformat = 1'b1;
                alu_op = ALU_SUB;
                fcu_op = FCU_LT;
                rf_write_en = 1'b1;
            end
            OP_SLE : begin
                instr_rformat = 1'b1;
                alu_op = ALU_SUB;
                fcu_op = FCU_LE;
                rf_write_en = 1'b1;
            end
            OP_SCO : begin
                instr_rformat = 1'b1;
                alu_op = ALU_ADD;
                fcu_op = FCU_CRY;
                rf_write_en = 1'b1;
            end

            OP_LBI : begin
                rf_write_en = 1'b1;
                alu_op = ALU_PSB;
                writeto_rs = 1'b1;

                immcode = IMMC_SIMM8;
                alu_b_imm = 1'b1;
            end
            OP_SLBI : begin
                rf_write_en = 1'b1;
                alu_op = ALU_SLBI;
                writeto_rs = 1'b1;

                immcode = IMMC_SIMM8;
                alu_b_imm = 1'b1;
            end
        endcase
    end
endmodule