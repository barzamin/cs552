module execute(
    input wire [3:0] alu_op,
    input wire [2:0] fcu_op,

    output wire [15:0] alu_out,
    output wire flag,
    output wire err
);
    wire [15:0] alu_A, alu_B; // alu inputs

    wire alu_carry; // wire from ALU to FCU
    alu alu(
        .op      (alu_op),
        .A       (alu_A),
        .B       (alu_B),
        .out     (alu_out),
        .carryout(alu_carry)
    );

    fcu fcu(
        .op       (fcu_op),
        .alu_out  (alu_out),
        .alu_carry(alu_carry),
        .flag     (flag)
    );

    assign err = 1'b0;
endmodule