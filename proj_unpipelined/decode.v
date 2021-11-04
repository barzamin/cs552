`default_nettype none
module decode (
    input  wire clk,
    input  wire rst,

    input  wire [15:0] instr,
    input  wire [15:0] pc,

    output reg [3:0] alu_op,
    output reg [2:0] fcu_op,
    output reg halt,
    output reg err
);
    // -- register file
    wire [2:0] write_reg, read1_reg, read2_reg;
    wire [15:0] write_data, regv_1, regv_2;
    wire rf_write_en;
    rf register_file (
        .clk       (clk),
        .rst       (rst),
        
        .write_en  (rf_write_en),
        .write_reg (write_reg),
        .write_data(write_data),

        .read1_reg (read1_reg),
        .read1_data(regv_1),

        .read2_reg (read2_reg),
        .read2_data(regv_2)
    );

    // -- pull out some fields
    wire [4:0] opcode;
    wire [1:0] op_ext; // extended 2 bits at the LSB of the instruction, used as an additional function code for some arithmetic instructions. 
    assign opcode = instr[15:11];
    
    wire [4:0] imm5;
    wire [7:0] imm8;
    wire [10:0] disp11;
    assign imm5   = instr[4:0];
    assign imm8   = instr[7:0];
    assign disp11 = instr[10:0];

    // -- Flag Computation Unit optable
    localparam FCU_EQ  = 3'b000;
    localparam FCU_NEQ = 3'b001;
    localparam FCU_LT  = 3'b010;
    localparam FCU_GT  = 3'b011;
    localparam FCU_LE  = 3'b100;
    localparam FCU_GE  = 3'b101;
    localparam FCU_CRY = 3'b110; // filled in don't-care

    // -- ALU optable
    // pick some values for don't cares
    localparam ALU_XOR  = 4'b0000;
    localparam ALU_SLBI = 4'b0100;
    localparam ALU_ANDN = 4'b0001;
    localparam ALU_ADD  = 4'b0010;
    localparam ALU_SUB  = 4'b0110;
    localparam ALU_BTR  = 4'b1110;
    localparam ALU_SRL  = 4'b0011;
    localparam ALU_SLL  = 4'b1011;
    localparam ALU_ROR  = 4'b0111;
    localparam ALU_ROL  = 4'b1111;

    // -- opcode listing
    localparam OP_HALT  = 5'b00000;
    localparam OP_NOP   = 5'b00001;

    localparam OP_ADDI  = 5'b01000;
    localparam OP_SUBI  = 5'b01001;
    localparam OP_XORI  = 5'b01010;
    localparam OP_ANDNI = 5'b01011;

    localparam OP_ROLI  = 5'b10100;
    localparam OP_SLLI  = 5'b10101;
    localparam OP_RORI  = 5'b10110;
    localparam OP_SRLI  = 5'b10111;

    localparam OP_ST    = 5'b10000;
    localparam OP_LD    = 5'b10001;
    localparam OP_STU   = 5'b10011;


    localparam OP_BTR   = 5'b11001;
    localparam OP_ARITH = 5'b11011; // } instruction family (basic arithmetic and logic)
    localparam OP_ROLL  = 5'b11010; // } instructon family  (rotates + shifts)

    localparam OP_SEQ   = 5'b11100;
    localparam OP_SLT   = 5'b11101;
    localparam OP_SLE   = 5'b11110;
    localparam OP_SCO   = 5'b11111;

    localparam OP_BEQZ  = 5'b01100;
    localparam OP_BNEZ  = 5'b01101;
    localparam OP_BLTZ  = 5'b01110;
    localparam OP_BGEZ  = 5'b01111;

    localparam OP_LBI   = 5'b11000;
    localparam OP_SLBI  = 5'b10010;

    localparam OP_J     = 5'b00100;
    localparam OP_JR    = 5'b00101;
    localparam OP_JAL   = 5'b00110;
    localparam OP_JALR  = 5'b00111;

    // nops until we implement exceptions as bonus :)
    localparam OP_SIIC  = 5'b00010;
    localparam OP_RTI   = 5'b00011;

    // -- extended op listing
    localparam OPE_ADD  = 2'b00;
    localparam OPE_SUB  = 2'b01;
    localparam OPE_XOR  = 2'b10;
    localparam OPE_ANDN = 2'b11;

    // -- imm16 computation
    reg [15:0] imm16;
    wire [1:0] immcode;
    localparam IMMC_ZIMM5 = 3'b000;
    localparam IMMC_SIMM5 = 3'b010;
    localparam IMMC_ZIMM8 = 3'b001;
    localparam IMMC_SIMM8 = 3'b011;
    localparam IMMC_DISPL = 3'b100;

    always @* casex (immcode)
        IMMC_ZIMM5 : imm16 = {11'b0, imm5}; // zero extend
        IMMC_SIMM5 : imm16 = {{11{imm5[4]}}, imm5}; // sign extend
        IMMC_ZIMM8 : imm16 = {8'b0, imm8}; // zero extend
        IMMC_ZIMM8 : imm16 = {{8{imm8[7]}}, imm8}; // sign extend
        3'b1??     : imm16 = {{5{disp11[10]}}, disp11}; // sign extended displacement; IMMC_DISPL = 3'b100 but we don't-care two LSBs
    endcase

    // -- PC computation
    wire [15:0] joffset, next_pc_basic, next_pc_taken;
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
        alu_op = ALU_XOR;
        fcu_op = FCU_EQ;
        err = 1'b0;

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
            end
            OP_SUBI : begin
                alu_op = ALU_SUB;
            end
            OP_XORI : begin
                alu_op = ALU_XOR;
            end
            OP_ANDNI : begin
                alu_op = ALU_ANDN;
            end
            OP_ROLI : begin
                alu_op = ALU_ROL;
            end
            OP_SLLI : begin
                alu_op = ALU_SLL;
            end
            OP_RORI : begin
                alu_op = ALU_ROR;
            end
            OP_SRLI : begin
                alu_op = ALU_SRL;
            end

            // flag-setting instructions
            OP_SEQ : begin
                alu_op = ALU_SUB;
                fcu_op = FCU_EQ;
            end
            OP_SLT : begin
                alu_op = ALU_SUB;
                fcu_op = FCU_LT;
            end
            OP_SLE : begin
                alu_op = ALU_SUB;
                fcu_op = FCU_LE;
            end
            OP_SCO : begin
                alu_op = ALU_ADD;
                fcu_op = FCU_CRY;
            end
        endcase
    end
endmodule