module adder16 (
    input  wire [15:0] A,   
    input  wire [15:0] B,
    input  wire Cin,
    output wire [15:0] S,
    output wire Cout
);
    wire [3:0] carries;
    wire [3:0] blockG;
    wire [3:0] blockP;
    cla4 blocks [3:0] (
        .A (A),
        .B (B),
        .S (S),
        .Cin(carries),
        .blockP(blockP),
        .blockG(blockG),
        .Cout() // ignore carry outs
    );

    assign carries[0] = Cin;
    assign carries[1] = blockG[0] | (blockP[0] & Cin);
    assign carries[2] = blockG[1] | (blockP[1] & blockG[0]) | (blockP[1] & blockP[0] & Cin);
    assign carries[3] = blockG[2] | (blockP[2] & blockG[1]) | (blockP[2] & blockP[1] & blockG[0]) | (blockP[2] & blockP[1] & blockP[0] & Cin);
    assign Cout = blockG[3] | (blockP[3] & blockG[2]) | (blockP[3] & blockP[2] & blockG[1]) | (blockP[3] & blockP[2] & blockP[1] & blockG[0]) | (blockP[3] & blockP[2] & blockP[1] & blockP[0] & Cin);
endmodule
