/*------------------------------------------------------------------------------
--  single source of truth for all multi-bit control signals.
------------------------------------------------------------------------------*/


// -- Flag Computation Unit optable
localparam FCU_EQ  = 3'b000;
localparam FCU_NEQ = 3'b001;
localparam FCU_LT  = 3'b010;
localparam FCU_GT  = 3'b011;
localparam FCU_LE  = 3'b100;
localparam FCU_GE  = 3'b101;
localparam FCU_CRY = 3'b110; // filled in don't-care

// -- ALU optable
localparam ALU_PSA  = 4'b0000; // pick a value which is caught by default
localparam ALU_PSB  = 4'b1001;
localparam ALU_XOR  = 4'b1000;
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

// -- writeback ops
localparam WB_ALU  = 2'b00;
localparam WB_MEM  = 2'b01;
localparam WB_FLAG = 2'b10;
localparam WB_LINK = 2'b11;

// -- flow codes
localparam FLOW_BASIC = 2'b00;
localparam FLOW_ALU   = 2'b01;
localparam FLOW_JUMP  = 2'b10;
localparam FLOW_COND  = 2'b11;

// -- immediate format selection
localparam IMMC_ZIMM5 = 3'b000;
localparam IMMC_SIMM5 = 3'b010;
localparam IMMC_ZIMM8 = 3'b001;
localparam IMMC_SIMM8 = 3'b011;
localparam IMMC_DISPL = 3'b100;
