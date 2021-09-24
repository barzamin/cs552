module cla4(
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire Cin,
    output wire Cout,
    output blockP,
    output blockG,
    output wire [3:0] S
);
    wire [3:0] carries;
    wire [3:0] generates;
    wire [3:0] propagates;

    assign Cout = carries[3];

    cla_fulladder adders [3:0] (
        .A (A),
        .B (B),
        .S (S),
        .C ({carries[2:0], Cin}),
        .G (generates),
        .P (propagates)
    );

    assign carries[0] = generates[0] | (propagates[0] & Cin);
    assign carries[1] = generates[1] | (propagates[1] & generates[0]) | (propagates[1] & propagates[0] & Cin);
    assign carries[2] = generates[2] | (propagates[2] & generates[1]) | (propagates[2] & propagates[1] & generates[0]) | (propagates[2] & propagates[1] & propagates[0] & Cin);
    assign carries[3] = generates[3] | (propagates[3] & generates[2]) | (propagates[3] & propagates[2] & generates[1]) | (propagates[3] & propagates[2] & propagates[1] & generates[0]) | (propagates[3] & propagates[2] & propagates[1] & propagates[0] & Cin);

    assign blockP = &propagates; // reduction and: all bits propagate
    assign blockG = generates[3] | (generates[2] & propagates[3]) | (generates[1] & propagates[2] & propagates[3]) | (generates[0] & propagates[1] & propagates[2] & propagates[3]);
endmodule