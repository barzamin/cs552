module rf(
    input wire clk,
    input wire rst,

    // read port 1
    input wire [2:0] read1_reg,
    output reg [15:0] read1_data,

    // read port 2
    input wire [2:0] read2_reg,
    output reg [15:0] read2_data,

    // write port
    input wire [2:0]  write_reg,
    input wire [15:0] write_data,
    input wire        write_en
);

    wire [7:0] write_enables;
    // because ModelSim didn't like a net array of the form
    //   wire [15:0] reg_data [7:0];
    wire [15:0] reg_data_0, reg_data_1, reg_data_2, reg_data_3, reg_data_4, reg_data_5, reg_data_6, reg_data_7;
    register registers [7:0] (
        .clk       (clk),
        .rst       (rst),
        .write_data(write_data),
        .write_en  (write_enables),
        .read_data ({reg_data_7, reg_data_6, reg_data_5, reg_data_4, reg_data_3, reg_data_2, reg_data_1, reg_data_0})
    );

    // mux logic to select registers to read
    // assign read1_data = reg_data[read1_reg];
    // assign read2_data = reg_data[read2_reg];
    always @* case (read1_reg)
        3'h0 : read1_data = reg_data_0;
        3'h1 : read1_data = reg_data_1;
        3'h2 : read1_data = reg_data_2;
        3'h3 : read1_data = reg_data_3;
        3'h4 : read1_data = reg_data_4;
        3'h5 : read1_data = reg_data_5;
        3'h6 : read1_data = reg_data_6;
        3'h7 : read1_data = reg_data_7;
    endcase
    always @* case (read2_reg)
        3'h0 : read2_data = reg_data_0;
        3'h1 : read2_data = reg_data_1;
        3'h2 : read2_data = reg_data_2;
        3'h3 : read2_data = reg_data_3;
        3'h4 : read2_data = reg_data_4;
        3'h5 : read2_data = reg_data_5;
        3'h6 : read2_data = reg_data_6;
        3'h7 : read2_data = reg_data_7;
    endcase

    // demux logic to identify write outputs.
    assign write_enables[0] = (write_reg == 3'h0) && write_en;
    assign write_enables[1] = (write_reg == 3'h1) && write_en;
    assign write_enables[2] = (write_reg == 3'h2) && write_en;
    assign write_enables[3] = (write_reg == 3'h3) && write_en;
    assign write_enables[4] = (write_reg == 3'h4) && write_en;
    assign write_enables[5] = (write_reg == 3'h5) && write_en;
    assign write_enables[6] = (write_reg == 3'h6) && write_en;
    assign write_enables[7] = (write_reg == 3'h7) && write_en;
endmodule