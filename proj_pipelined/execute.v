module execute (
    output wire err,

    input  wire [3:0]  alu_op,

    input  wire [15:0] rA_v,
    input  wire [15:0] rB_v,
    input  wire [15:0] imm16
);

    wire alu_zero, alu_ovf, alu_carry;
    wire [15:0] alu_A;
    wire [15:0] alu_B;
    wire [15:0] alu_out;
    alu alu(
        .op      (alu_op),
        .A       (alu_A),
        .B       (alu_B),
        .out     (alu_out),
        .zero    (alu_zero),
        .ovf     (alu_ovf),
        .carryout(alu_carry)
    );


    assign err = 1'b0;
endmodule
