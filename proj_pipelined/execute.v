`default_nettype none
module execute (
    output wire err,

    input  wire [3:0]  alu_op,
    input  wire        alu_b_imm,

    input  wire [2:0]  fcu_op,

    input  wire [15:0] vX,
    input  wire [15:0] vY,
    input  wire [15:0] imm16,

    output wire [15:0] alu_out
);
    wire [15:0] alu_A, alu_B;

    assign alu_A = vX;
    assign alu_B = alu_b_imm ? imm16 : vY;

    wire alu_zero, alu_ovf, alu_carry;
    alu alu (
        .op      (alu_op),
        .A       (alu_A),
        .B       (alu_B),
        .out     (alu_out),
        .zero    (alu_zero),
        .ovf     (alu_ovf),
        .carryout(alu_carry)
    );

    wire flag;
    fcu fcu (
        .op     (fcu_op),

        .alu_out(alu_out),
        .zero   (alu_ovf),
        .carry  (alu_carry),
        .ovf    (alu_ovf),

        .flag   (flag)
    );

    assign err = 1'b0;
endmodule
