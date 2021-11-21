module mux2_1(
    input  wire in0,
    input  wire in1,
    input  wire s,
    output wire out
);
    assign out = (~s & in0) | (s & in1);
endmodule