module execute (
    input  wire clk,
    input  wire rst,
    output wire err,

    input  wire [15:0] regv_1,
    input  wire [15:0] regv_2,
    input  wire [15:0] imm16
);

    wire alu_zero, alu_ovf, alu_carry;
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