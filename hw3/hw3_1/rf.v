module rf (
   // Inputs
   input  wire clk,
   input  wire rst,
   input  wire [2:0] read1regsel,
   input  wire [2:0] read2regsel,
   input  wire [2:0] writeregsel,
   input  wire [15:0] writedata,
   input  wire write,
   // Outputs
   output reg [15:0] read1data,
   output reg [15:0] read2data,
   output wire err
);
   wire [7:0] write_lines;
   wire [15:0] reg_out_0, reg_out_1, reg_out_2, reg_out_3, reg_out_4, reg_out_5, reg_out_6, reg_out_7;
   register registers [7:0] (
      .clk(clk),
      .rst(rst),
      .write_data(writedata),
      .write_en(write_lines),
      .read_data({reg_out_0, reg_out_1, reg_out_2, reg_out_3, reg_out_4, reg_out_5, reg_out_6, reg_out_7})
   );

   always @* case (read1regsel)
      3'h0 : read1data = reg_out_0;
      3'h1 : read1data = reg_out_1;
      3'h2 : read1data = reg_out_2;
      3'h3 : read1data = reg_out_3;
      3'h4 : read1data = reg_out_4;
      3'h5 : read1data = reg_out_5;
      3'h6 : read1data = reg_out_6;
      3'h7 : read1data = reg_out_7;
   endcase
   always @* case (read2regsel)
      3'h0 : read2data = reg_out_0;
      3'h1 : read2data = reg_out_1;
      3'h2 : read2data = reg_out_2;
      3'h3 : read2data = reg_out_3;
      3'h4 : read2data = reg_out_4;
      3'h5 : read2data = reg_out_5;
      3'h6 : read2data = reg_out_6;
      3'h7 : read2data = reg_out_7;
   endcase

   assign write_lines[7] = (writeregsel == 0) && write;
   assign write_lines[6] = (writeregsel == 1) && write;
   assign write_lines[5] = (writeregsel == 2) && write;
   assign write_lines[4] = (writeregsel == 3) && write;
   assign write_lines[3] = (writeregsel == 4) && write;
   assign write_lines[2] = (writeregsel == 5) && write;
   assign write_lines[1] = (writeregsel == 6) && write;
   assign write_lines[0] = (writeregsel == 7) && write;
endmodule
