module execute(
    input wire [3:0] alu_op,
    input wire [2:0] fcu_op,
    input wire [1:0] flow_ty,

    input wire [15:0] regv_1,
    input wire [15:0] regv_2,
    input wire [15:0] imm16,

    input wire [15:0] next_pc_basic,
    input wire [15:0] next_pc_taken,

    input wire alu_b_imm,

    output wire [15:0] alu_out,
    output reg [15:0] next_pc,
    output wire flag,
    output wire err
);
    `include "ops.vh"

    // -- alu input select
    wire [15:0] alu_A, alu_B; // alu inputs
    assign alu_A = regv_1;
    assign alu_B = alu_b_imm ? imm16 : regv_2;

    // -- alu
    wire alu_carry; // wire from ALU to FCU
    alu alu(
        .op      (alu_op),
        .A       (alu_A),
        .B       (alu_B),
        .out     (alu_out),
        .carryout(alu_carry)
    );

    // -- flag computation unit
    fcu fcu(
        .op       (fcu_op),
        .alu_out  (alu_out),
        .alu_carry(alu_carry),
        .flag     (flag)
    );

    // -- flow mux
    always @* casex (flow_ty)
        default   : next_pc = next_pc_basic; // FLOW_BASIC
        FLOW_JUMP : next_pc = next_pc_taken;
        FLOW_COND : next_pc = flag ? next_pc_taken : next_pc_basic;
        FLOW_ALU  : next_pc = alu_out;
    endcase

    assign err = 1'b0;
endmodule