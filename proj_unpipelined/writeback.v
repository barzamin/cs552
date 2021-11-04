module writeback (
    output wire err,

    input wire [1:0] wb_op,
    input wire [15:0] alu_out,
    input wire [15:0] mem_out,
    input wire flag,

    output reg [15:0] wb_data
);
    always @* casex (wb_op)
        2'b00 : wb_data = alu_out;
        2'b01 : wb_data = mem_out;
        2'b1x : wb_data = {15'b0, flag};
    endcase

    assign err = 1'b0;
endmodule