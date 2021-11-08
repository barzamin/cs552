module alu(
    input wire [15:0] A,
    input wire [15:0] B,
    input wire [3:0] op,
    output reg [15:0] out,
    output wire zero,
    output wire carryout,
    output wire ovf
);
    `include "ops.vh"

    // so i drew out this very careful design and everything (except for screwing up bit-reversing: you need two reversers).
    // and i'm going to nearly throw it away in favor of heavily using case. this is because any reasonable synthesis tool
    // will produce a fast, small, but impenetrable cloud of reduced boolean logic rather than my explicit,
    // readable but slower muxing and gating.

    // ---------------- add/sub unit ----------------
    reg sub;
    wire [15:0] A_inp;
    wire [15:0] sum;
    assign A_inp = A ^ {16{sub}}; // negate if subtracting
    adder16 adder(
        .A   (A_inp),
        .B   (B),
        .S   (sum),
        .Cin (sub),
        .Cout(carryout)
    );

    // ---------------- shift/roll/reverse unit ----------------
    wire [15:0] prereversed, shifter_out, reverser_out;
    reg [3:0] shamt;
    reg rotate, prereverse, postreverse;

    reverser prereverser(
        .in     (A),
        .reverse(prereverse),
        .out    (prereversed)
    );

    shifter shifter(
        .in    (prereversed),
        .shamt (shamt),
        .rotate(rotate),
        .out   (shifter_out)
    );

    reverser postreverser(
        .in     (shifter_out),
        .reverse(postreverse),
        .out    (reverser_out)
    );

    // you have no idea how badly i want to be able to use always_comb :(
    always @* begin
        // defaults: don't infer latches!
        sub = 1'b0;
        shamt = B[3:0];
        rotate = 1'b0;
        prereverse = 1'b0;
        postreverse = 1'b0;

        casex (op)
            default : begin // ALU_PSA
                out = A;
            end
            ALU_PSB : begin
                out = B;
            end
            ALU_XOR : begin // XOR A ^ B
                out = A ^ B;
            end
            ALU_SLBI : begin // (A << 8) | B. literally just used for SLBI
                out = {A[7:0], B[7:0]};
            end
            ALU_ANDN : begin // ANDN A & ~B
                out = A & ~B;
            end
            ALU_ADD : begin // A + B
                out = sum;
                sub = 1'b0;
            end
            ALU_SUB : begin // -A + B
                out = sum;
                sub = 1'b1;
            end
            ALU_BTR : begin // BTR
                out = reverser_out;
                prereverse = 0;
                postreverse = 1;
                rotate = 0;
                shamt = 4'b0000;
            end
            ALU_SRL : begin // shift right logical
                out = reverser_out;
            end
            ALU_SLL : begin // shift left logical
                out = reverser_out;

                prereverse = 1'b1;
                postreverse = 1'b1;
            end
            ALU_ROR : begin // rotate right
                out = reverser_out;

                rotate = 1'b1;
            end
            ALU_ROL : begin // rotate left
                out = reverser_out;

                rotate = 1'b1;
                prereverse = 1'b1;
                postreverse = 1'b1;
            end
        endcase
    end

    // -- auxiliary bits

    // zero bit
    assign zero = ~|out;

    // (signed!) overflow bit
    assign ovf = ( A_inp[15] &  B[15] & ~out[15])
               | (~A_inp[15] & ~B[15] &  out[15]);
endmodule