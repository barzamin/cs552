`default_nettype none
module control(
    input wire [4:0] opcode,
    input wire [1:0] op_ext,

    output reg halt,
    output reg err,

    output reg [3:0] alu_op,
    output reg [2:0] fcu_op,
    output reg [1:0] flow_ty,

    output reg instr_rformat,
    output reg writeto_rs,
    output reg readfrom_rd,
    output reg link,

    output reg siic,
    output reg rti,

    output reg [1:0] wb_op,
    output reg writeflag,
    output reg rf_write_en,

    output reg [2:0] immcode,
    output reg alu_b_imm,

    output reg dmem_ren,
    output reg dmem_wen
);
    `include "ops.vh"

    always @* begin
        // defaults to prevent latching. note some are arbitrary
        halt = 1'b0;
        err = 1'b0;

        alu_op = ALU_PSA;
        fcu_op = FCU_EQ;
        flow_ty = FLOW_BASIC;

        instr_rformat = 1'b0;
        writeto_rs = 1'b0;
        readfrom_rd = 1'b0;
        link = 1'b0;

        siic = 1'b0;
        rti = 1'b0;

        wb_op = WB_ALU;
        writeflag = 1'b0;
        rf_write_en = 1'b0;

        immcode = IMMC_ZIMM5;
        alu_b_imm = 1'b0;

        dmem_wen = 1'b0;
        dmem_ren = 1'b0;

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
                    default : alu_op = ALU_ADD; // 2'b00
                    2'b01   : alu_op = ALU_SUB;
                    2'b10   : alu_op = ALU_XOR;
                    2'b11   : alu_op = ALU_ANDN;
                endcase
                rf_write_en = 1'b1;
            end

            OP_ROLL : begin
                instr_rformat = 1'b1;
                case (op_ext)
                    default : alu_op = ALU_ROL; // 2'b00
                    2'b01   : alu_op = ALU_SLL;
                    2'b10   : alu_op = ALU_ROR;
                    2'b11   : alu_op = ALU_SRL;
                endcase
                rf_write_en = 1'b1;
            end

            // -- flag-setting instructions
            OP_SEQ : begin
                instr_rformat = 1'b1;

                alu_op = ALU_SUB;
                fcu_op = FCU_EQ;

                writeflag = 1'b1;
                rf_write_en = 1'b1;
            end
            OP_SLT : begin
                instr_rformat = 1'b1;

                alu_op = ALU_SUB;
                fcu_op = FCU_LT;

                writeflag = 1'b1;
                rf_write_en = 1'b1;
            end
            OP_SLE : begin
                instr_rformat = 1'b1;

                alu_op = ALU_SUB;
                fcu_op = FCU_LE;

                writeflag = 1'b1;
                rf_write_en = 1'b1;
            end
            OP_SCO : begin
                instr_rformat = 1'b1;

                alu_op = ALU_ADD;
                fcu_op = FCU_CRY;

                writeflag = 1'b1;
                rf_write_en = 1'b1;
            end

            // -- immediate loads
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

            // -- conditional branches
            OP_BEQZ : begin
                alu_op = ALU_PSA; // pass through Rs; we check if zero
                immcode = IMMC_SIMM8;

                fcu_op = FCU_EQ;
                flow_ty = FLOW_COND;
            end
            OP_BNEZ : begin
                alu_op = ALU_PSA; // pass through Rs; we check if zero
                immcode = IMMC_SIMM8;

                fcu_op = FCU_NEQ;
                flow_ty = FLOW_COND;
            end
            OP_BLTZ : begin
                alu_op = ALU_PSA; // pass through Rs; we check if zero
                immcode = IMMC_SIMM8;

                fcu_op = FCU_GT; // 0 greater than x
                flow_ty = FLOW_COND;
            end
            OP_BGEZ : begin
                alu_op = ALU_PSA; // pass through Rs; we check if zero
                immcode = IMMC_SIMM8;

                fcu_op = FCU_LE; // 0 less than or equal to x
                flow_ty = FLOW_COND;
            end

            // -- unconditional branches
            OP_J : begin
                immcode = IMMC_DISPL;
                flow_ty = FLOW_JUMP;
            end
            OP_JR : begin // "jump register"
                // alu_out <- Rs + sext(imm8)
                alu_op = ALU_ADD;
                immcode = IMMC_SIMM8;
                alu_b_imm = 1'b1;

                // next_pc <- alu_out
                flow_ty = FLOW_ALU;
            end

            // -- linked unconditional jumps
            OP_JAL : begin
                immcode = IMMC_DISPL;
                flow_ty = FLOW_JUMP;

                link = 1'b1; // Rs <- 7

                wb_op = WB_LINK;
                rf_write_en = 1'b1; // and write it back
            end
            OP_JALR : begin
                // alu_out <- Rs + sext(imm8)
                alu_op = ALU_ADD;
                immcode = IMMC_SIMM8;
                alu_b_imm = 1'b1;

                // next_pc <- alu_out
                flow_ty = FLOW_ALU;

                link = 1'b1;

                wb_op = WB_LINK;
                rf_write_en = 1'b1; // and write it back
            end

            // -- memory load and store
            OP_ST : begin
                dmem_wen = 1'b1;

                // compute address as
                //  alu_out <- Rs + sext(imm5)
                alu_op = ALU_ADD;
                alu_b_imm = 1'b1;
                immcode = IMMC_SIMM5;

                readfrom_rd = 1'b1;
            end
            OP_LD : begin
                dmem_ren = 1'b1;

                // compute address as
                //  alu_out <- Rs + sext(imm5)
                alu_op = ALU_ADD;
                alu_b_imm = 1'b1;
                immcode = IMMC_SIMM5;

                wb_op = WB_MEM;
                rf_write_en = 1'b1;
            end

            // weird one! "store and update"; computes address as Rs + sext(imm5) but writes that back to Rs!
            OP_STU : begin
                dmem_wen = 1'b1;

                // compute address as
                //  alu_out <- Rs + sext(imm5)
                alu_op = ALU_ADD;
                alu_b_imm = 1'b1;
                immcode = IMMC_SIMM5;

                readfrom_rd = 1'b1;

                // also write back
                wb_op = WB_ALU;
                writeto_rs = 1'b1;
                rf_write_en = 1'b1;
            end

            OP_SIIC : begin
                flow_ty = FLOW_JUMP;
                siic = 1'b1;
            end

            OP_RTI : begin
                flow_ty = FLOW_ALU;
                rti = 1'b1;
            end

            default : begin
                err = 1'b1; // bad instruction!
            end
        endcase
    end
endmodule
