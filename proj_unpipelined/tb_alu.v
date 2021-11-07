// lovingly stolen from hw2, and molded to fit my needs
module tb_alu();
    `include "ops.vh"

    reg  [15:0] A;
    reg  [15:0] B;
    reg  [3:0]  op;
    wire [15:0] out;
    wire        carryout;

    reg         fail;

    reg        cerror;
    reg [31:0] gold_out;
    reg        gold_carryout;
    integer idx;

    // clockgen
    wire clk, rst;
    clkrst c0(
        // Outputs
        .clk(clk),
        .rst(rst),
        // Inputs
        .err(1'b0)
    );

    alu dut (
        .A(A),
        .B(B),
        .op(op),
        .out(out),
        .carryout(carryout)
    );

    initial begin
        A = 16'b0000;
        B = 16'b0000;
        op = ALU_PSA;
        fail = 0;

    #5000;
    if (fail)
        $display("TEST FAILED");
    else
        $display("TEST PASSED"); $finish;
    end

    // generate test vectors
    always @(posedge clk) begin
        A  = $random;
        B  = $random;
        op = $random;
    end

    // compare result to golden
    always @(negedge clk) begin
        cerror = 1'b0;
        gold_out = 32'h0000_0000;
        gold_carryout = 1'b0;

        case (op)
            default : begin // ALU_PSA
                gold_out = A;
                if (gold_out[15:0] !== out) cerror = 1'b1;
            end

            ALU_PSB : begin
                gold_out = B;
                if (gold_out[15:0] !== out) cerror = 1'b1;
            end

            ALU_XOR : begin
                gold_out = A ^ B;
                if (gold_out[15:0] !== out) cerror = 1'b1;
            end
            ALU_SLBI : begin
                gold_out = (A << 8) | B[7:0];
                if (gold_out[15:0] !== out) cerror = 1'b1;
            end
            ALU_ANDN : begin
                gold_out = A & ~B;
                if (gold_out[15:0] !== out) cerror = 1'b1;
            end

            ALU_ADD : begin
                gold_out = A + B;
                if (gold_out[16]) gold_carryout = 1'b1; // carried out :)

                if ((gold_out[15:0] !== out) || (gold_carryout !== carryout)) cerror = 1'b1;
            end
            ALU_SUB : begin
                gold_out = B - A;

                if (gold_out[15:0] !== out) cerror = 1'b1;
            end

            ALU_BTR : begin
                gold_out = {A[0], A[1], A[2], A[3], A[4], A[5], A[6], A[7], A[8], A[9], A[10], A[11], A[12], A[13], A[14], A[15]};
                if (gold_out[15:0] !== out) cerror = 1'b1;
            end

            ALU_SRL : begin
                gold_out = A >> B[3:0];
                if (gold_out[15:0] !== out) cerror = 1'b1;
            end
            ALU_SLL : begin
                gold_out = A << B[3:0];
                if (gold_out[15:0] !== out) cerror = 1'b1;
            end
            ALU_ROR : begin
                gold_out = A >> B[3:0] | A << (16-B[3:0]);
                if (gold_out[15:0] !== out) cerror = 1'b1;
            end
            ALU_ROL : begin
                gold_out = A << B[3:0] | A >> (16-B[3:0]);
                if (gold_out[15:0] !== out) cerror = 1'b1;
            end
        endcase

        if (cerror === 1'b1) begin
            $display("ERRORCHECK :: ALU :: Inputs :: op = %b , A = %x, B = %x :: Outputs :: out = %x, carryout = %x :: Expected :: out = %x, carryout = %x",
                op, A, B,
                out, carryout,
                gold_out[15:0], gold_carryout);
            fail = 1;
        end
    end
endmodule