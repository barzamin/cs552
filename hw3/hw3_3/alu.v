module alu
(
    input wire op, // 0 = add, 1 = xor
    input wire [15:0] A,
    input wire [15:0] B,
    output wire [15:0] out
);
    wire [15:0] a_sum_b;
    adder16 adder (
        .A   (A),
        .B   (B),
        .S   (a_sum_b),
        .Cin (1'b0),
        .Cout()
    );

    wire [15:0] a_xor_b;
    assign a_xor_b = A ^ B;

    assign out = op ? a_xor_b : a_sum_b;
endmodule