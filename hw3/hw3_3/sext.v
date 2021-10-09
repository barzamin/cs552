module sext
#(parameter INW=5, OUTW=16)
(
    input wire [INW-1:0] in,
    input wire [OUTW-1:0] out
);
    assign out = {{(OUTW-INW){in[INW-1]}}, in};
endmodule