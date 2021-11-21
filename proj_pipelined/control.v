module control(
    input wire [4:0] opcode,
    input wire [1:0] op_ext,

    output wire instr_rformat,
    output wire writeto_rs,
    output wire readfrom_rd,
    output wire link,

    output wire err
);

    assign err = 1'b0;
endmodule
