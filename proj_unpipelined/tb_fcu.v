module tb_fcu();
    `include "ops.vh"

    reg  [15:0] A;
    reg  [15:0] B;
    reg  [2:0]  op;
    wire flag;
    wire        carryout;

    reg         fail;

    reg        cerror;
    reg        gold_flag;

    // clockgen
    wire clk, rst;
    clkrst c0(
        // Outputs
        .clk(clk),
        .rst(rst),
        // Inputs
        .err(1'b0)
    );

    wire [15:0] alu_out;
    alu alu (
        .A(A),
        .B(B),
        .op(ALU_SUB),
        .out(alu_out),
        .carryout(carryout)
    );

    fcu dut (
        .A        (A),
        .B        (B),
        .op       (op),
        .alu_out  (alu_out),
        .alu_carry(carryout),
        .flag     (flag)
    );

    initial begin
        A = 16'b0000;
        B = 16'b0000;
        fail = 0;

    #5000;
    if (fail)
        $display("TEST FAILED");
    else
        $display("TEST PASSED"); $finish;
    end

    // generate test vectors
    always @(posedge clk) begin
        A      = $random;
        B      = $random;
        op = $random;
    end

    wire [15:0] Abar;
    assign Abar = ~A;

    reg [31:0] tmp;

    // compare result to golden
    always @(negedge clk) begin
        cerror = 1'b0;
        gold_flag = 1'b0;
        tmp = 32'h0000_0000;

        case (op)
            default : begin // FCU_EQ
                gold_flag = (A == B);
                if (gold_flag !== flag) cerror = 1'b1;
            end

            FCU_NEQ : begin
                gold_flag = (A != B);
                if (gold_flag !== flag) cerror = 1'b1;
            end

            FCU_LT : begin
                gold_flag = ($signed(A) < $signed(B));
                if (gold_flag !== flag) cerror = 1'b1;
            end
            FCU_GT : begin
                gold_flag = ($signed(A) > $signed(B));
                if (gold_flag !== flag) cerror = 1'b1;
            end

            FCU_LE : begin
                gold_flag = ($signed(A) <= $signed(B));
                if (gold_flag !== flag) cerror = 1'b1;
            end
            FCU_GE : begin
                gold_flag = ($signed(A) >= $signed(B));
                if (gold_flag !== flag) cerror = 1'b1;
            end

            FCU_CRY : begin
                tmp = Abar + 1 + B;
                gold_flag = tmp[16];
                if (gold_flag !== flag) cerror = 1'b1;
            end
        endcase

        if (cerror === 1'b1) begin
            $display("ERRORCHECK :: FCU :: Inputs :: op = %b, A = %x, B = %x :: Outputs :: flag = %x :: Expected :: flag = %x",
                op, A, B,
                flag, gold_flag);
            fail = 1;
        end
    end
endmodule