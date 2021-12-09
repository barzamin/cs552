module register(clk, rst, write_data, write_en, read_data);
    parameter WIDTH = 16;
    input  wire clk;
    input  wire rst;
    input  wire [WIDTH-1:0] write_data;
    input  wire write_en;
    output wire [WIDTH-1:0] read_data;

    wire [WIDTH-1:0] d;
    assign d = write_en ? write_data : read_data; // loopback q -> d unless we're writing

    dff reg_flops [WIDTH-1:0] (
        .clk(clk),
        .rst(rst),
        .q(read_data),
        .d(d)
    );
endmodule
