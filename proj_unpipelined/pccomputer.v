module pccomputer(
    input wire [15:0] pc,      // current pc
    input wire [15:0] joffset, // jump offset

    output wire [15:0] next_pc_basic,
    output wire [15:0] next_pc_taken
);
    // next pc if we were in a basic block
    adder16 adder_basic (
        .A   (pc),
        .B   (16'h2),
        .S   (next_pc_basic),
        .Cin (1'b0),
        .Cout()
    );

    // next pc if the branch was taken PC-relative
    adder16 adder_taken (
        .A   (next_pc_basic),
        .B   (joffset),
        .S   (next_pc_taken),
        .Cin (1'b0),
        .Cout()
    );
endmodule