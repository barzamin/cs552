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
    	3'b000 : flag = zero; // -A + B = 0
    	3'b001 : flag = !zero;
    	3'b010 : flag = !zero && !sgn; // not zero and -A + B positive => A < B
    	3'b011 : flag = sgn; // -A + B negative, nonzero => A > B
    	3'b100 : flag = !sgn; // -A + B positive or zero => A <= B
    	3'b101 : flag = sgn | zero; // -A + B negative or zero => A >= B
    	3'b11? : flag = alu_carry; // flag is set if we carry out
	endcase
endmodule