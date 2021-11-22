module flop_ex2mem(
    input  wire clk,
    input  wire rst,

    input  wire i_halt,
    output wire o_halt,

    input  wire [15:0] i_alu_out,
    output wire [15:0] o_alu_out
);
    // TODO !!!
    wire write_en;
    assign write_en = 1'b1;

    register #(.WIDTH(1)) r_halt (
        .clk(clk), .rst(rst), .write_en(write_en),
        .write_data(i_halt), .read_data(o_halt)
    );

    register #(.WIDTH(16)) r_alu_out (
        .clk(clk), .rst(rst), .write_en(write_en),
        .write_data(i_alu_out), .read_data(o_alu_out)
    );
endmodule
