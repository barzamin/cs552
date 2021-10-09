module cla_fulladder(
    input wire A,
    input wire B,
    input wire C,
    output wire G,
    output wire P,
    output wire S
);
    assign P = A ^ B; // propagate
    assign G = A & B; // generate
    assign S = P ^ C; // sum = A xor B xor C = P xor C
endmodule