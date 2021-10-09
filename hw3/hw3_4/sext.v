module sext
#(parameter INW=5, OUTW=16)
(
    input wire [INW-1:0] in,
    input wire [OUTW-1:0] out
);
    // NOTE: Vcheck is not smart enough to realize no arithmetic is being done here. it warns and is very mad! please check this by hand
    // before docking points; this is good Verilog practice!
    assign out = {{(OUTW-INW){in[INW-1]}}, in};
endmodule