module alu(
    input wire [15:0] A,
    input wire [15:0] B,
    input wire [3:0] op,
    output reg [15:0] out,
    output wire carryout
);
    // so i drew out this very careful design and everything (except for screwing up bit-reversing: you need two reversers).
    // and i'm going to nearly throw it away in favor of heavily using case. this is because any reasonable synthesis tool
    // will produce a fast, small, but impenetrable cloud of reduced boolean logic rather than my explicit,
    // readable but slower muxing and gating.

    assign A_shl8 = {A[7:0], 8'b0}; // A << 8. for SLBI

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
        .in(A),
        .reverse(prereverse),
        .out(prereversed)
    );

    shifter shifter(
        .in    (prereversed),
        .shamt (shamt),
        .rotate(rotate),
        .out   (shifter_out)
    );

    reverser postreverser(
        .in(A),
        .reverse(postreverse),
        .out(reverser_out)
    );

    // you have no idea how badly i want to be able to use always_comb :(
    always @* begin
        // defaults: don't infer latches!
        sub = 0;
        shamt = B[3:0];

        casex (op)
            4'b?000 : begin // XOR A ^ B
                out = A ^ B;
            end
            4'b?100 : begin // (A << 8) | B. literally just used for SLBI
                out = A_shl8 | B;
            end
            4'b??01 : begin // ANDN A & ~B
                out = A & ~B;
            end
            4'b?010 : begin // A + B
                out = sum;
                sub = 0;
            end
            4'b0110 : begin // -A + B
                out = sum;
                sub = 1;
            end
            4'b1110 : begin // BTR
                out = reverser_out;
                prereverse = 0;
                postreverse = 1;
                rotate = 0;
                shamt = 4'b0000;
            end
            4'b0011 : begin // SRL (shift right logical)
                out = reverser_out;
            end
            4'b1011 : begin // SLL (shift left logical)
                out = reverser_out;
            end
            4'b0111 : begin // ROR (rotate right)
                out = reverser_out;
            end
            4'b1111 : begin // ROL (rotate left)
                out = reverser_out;
            end
            // default : /* default */;
        endcase
    end
endmodule