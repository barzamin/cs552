module alu(
    input  wire [15:0] A,
    input  wire [15:0] B,
    input  wire Cin,
    input  wire [2:0] Op,
    input  wire invA,
    input  wire invB,
    input  wire sign,
    output reg [15:0] Out,
    output wire Ofl,
    output wire Z
);
    // ALU ops
    localparam ALU_ADD = 3'b000;
    localparam ALU_OR  = 3'b001;
    localparam ALU_XOR = 3'b010;
    localparam ALU_AND = 3'b011;
    localparam ALU_SRA = 3'b100;
    localparam ALU_SRL = 3'b101;
    localparam ALU_RLL = 3'b110;
    localparam ALU_SLL = 3'b111;

    wire [15:0] A_txf;
    wire [15:0] B_txf;

    assign A_txf = A ^ {16{invA}};
    assign B_txf = B ^ {16{invB}};

    // -- shifter setup.
    //    operates on A, uses B[3:0] for shift amt
    //    turns out the lower two bits of the ALU op correspond to shifter ops.
    //    so all we need to do is select the shifter output if Op[2] is set.
    wire [15:0] shifter_out;
    shifter shifter (
        .In (A_txf),
        .Cnt(B_txf[3:0]),
        .Out(shifter_out),
        .Op (Op[1:0])
    );

    // -- adder setup
    wire [15:0] adder_out;
    wire adder_Cout;
    adder16 adder (
        .A   (A_txf),
        .B   (B_txf),
        .Cin (Cin),
        .S   (adder_out),
        .Cout(adder_Cout)
    );

    // -- zero and overflow flag computation
    assign Z = ~|adder_out;
    assign Ofl = sign ? // for signed math, compute sign concordance
                      (A_txf[15] & B_txf[15] & ~adder_out[15])
                        | (~A_txf[15] & ~B_txf[15] & adder_out[15]) 
                      : adder_Cout; // for unsigned, overflow if carried out

    // -- arithmetic muxing and bitwise ops
    always @* casex (Op)
        ALU_ADD : Out = adder_out;     // ADD
        ALU_OR  : Out = A_txf | B_txf; // OR
        ALU_XOR : Out = A_txf ^ B_txf; // XOR
        ALU_AND : Out = A_txf & B_txf; // AND
        3'b1??  : Out = shifter_out;   // all shifts happen when Op[2] is high and look directly at Op[1:0].
        default : Out = 0; // we cover completely, but still safeguarding against latches
    endcase
endmodule
