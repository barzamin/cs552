module fcu( // Flag Computation Unit
    input wire [15:0] alu_out,
    input wire alu_carry,
    input wire [2:0] op,

    output reg flag
);
    // zero bit computation
    wire zero;
    assign zero = ~|alu_out;

    // sign extraction
    wire sgn;
    assign sgn = alu_out[15];


    `include "ops.vh"
    // op        function
    // ----------------------
    // 000       A==B
    // 001       A!=B
    // 010       A<B
    // 011       A>B
    // 100       A<=B
    // 101       A>=B
    // 11x       carries out?

    // everything except FLU_CRY assumes aluop = ALU_SUB
    always @* casex (op)
        default : flag = zero; // FCU_EQ: -A + B = 0
        FCU_NEQ : flag = !zero;
        FCU_LT  : flag = !zero && !sgn; // not zero and -A + B positive => A < B
        FCU_GT  : flag = sgn; // -A + B negative, nonzero => A > B
        FCU_LE  : flag = !sgn; // -A + B positive or zero => A <= B
        FCU_GE  : flag = sgn | zero; // -A + B negative or zero => A >= B
        FCU_CRY : flag = alu_carry; // flag is set if we carry out
    endcase
endmodule