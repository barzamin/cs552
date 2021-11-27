module fcu( // Flag Computation Unit
    input wire sgn,
    input wire carry,
    input wire ovf,
    input wire zero,
    input wire [2:0] op,

    output reg flag
);
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
        FCU_NEQ : flag = ~zero;
        FCU_LT  : flag = ~(sgn ^ ovf) & ~zero;
        FCU_GT  : flag =  (sgn ^ ovf);
        FCU_LE  : flag = ~(sgn ^ ovf);
        FCU_GE  : flag =  (sgn ^ ovf) | zero;
        FCU_CRY : flag = carry; // flag is set if we carry out
    endcase
endmodule
