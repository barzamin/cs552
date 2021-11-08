/* $Author: karu $ */
module dff (q, d, clk, rst);
    output wire q;
    input  wire d;
    input  wire clk;
    input  wire rst;

    reg state;

    assign #(1) q = state;

    always @(posedge clk) begin
        state = rst? 0 : d;
    end
endmodule
