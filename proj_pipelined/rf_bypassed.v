module rf_bypassed(
    input wire clk,
    input wire rst,

    // read port 1
    input  wire [2:0]  read1_reg,
    output wire [15:0] read1_data,

    // read port 2
    input  wire [2:0]  read2_reg,
    output wire [15:0] read2_data,

    // write port
    input wire [2:0]  write_reg,
    input wire [15:0] write_data,
    input wire        write_en
);
    wire [15:0] read1_data_raw, read2_data_raw;
    rf rfile (
        .clk       (clk),
        .rst       (rst),

        .write_en  (write_en),
        .write_reg (write_reg),
        .write_data(write_data),

        .read1_reg (read1_reg),
        .read1_data(read1_data_raw),

        .read2_reg (read2_reg),
        .read2_data(read2_data_raw)
    );

    // -- register file bypassing:
    //    forward data being written to rf to output,
    //    if we're reading the written reg and a write is occuring
    wire bypass_1, bypass_2;
    assign bypass_1 = (write_en && (write_reg == read1_reg));
    assign bypass_2 = (write_en && (write_reg == read2_reg));
    assign read1_data = bypass_1 ? write_data : read1_data_raw;
    assign read2_data = bypass_2 ? write_data : read2_data_raw;
endmodule
