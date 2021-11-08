`default_nettype none
module writeback (
    output wire err,

    input wire [1:0] wb_op,
    input wire [15:0] alu_out,
    input wire [15:0] mem_out,
    input wire [15:0] next_pc_basic,
    input wire flag,

    output reg [15:0] wb_data
);
    `include "ops.vh"

    always @* case (wb_op)
        default : wb_data = alu_out; // WB_ALU
        WB_MEM  : wb_data = mem_out;
        WB_FLAG : wb_data = {15'b0, flag};
        WB_LINK : wb_data = next_pc_basic;
    endcase

    assign err = 1'b0;
endmodule