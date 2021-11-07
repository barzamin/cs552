module execute(
    input wire [3:0] alu_op,
    input wire [2:0] fcu_op,
    input wire [1:0] flow_ty,
    input wire [15:0] next_pc_basic,
    input wire [15:0] next_pc_taken,

    output wire [15:0] alu_out,
    output reg [15:0] next_pc,
    output wire flag,
    output wire err
);
    wire [15:0] alu_A, alu_B; // alu inputs
    wire alu_carry; // wire from ALU to FCU
    alu alu(
        .op      (alu_op),
        .A       (alu_A),
        .B       (alu_B),
        .out     (alu_out),
        .carryout(alu_carry)
    );

    fcu fcu(
        .op       (fcu_op),
        .alu_out  (alu_out),
        .alu_carry(alu_carry),
        .flag     (flag)
    );

    always @* casex (flow_ty)
        2'b0? : next_pc = next_pc_basic;
        2'b10 : next_pc = next_pc_taken;
        2'b11 : next_pc = flag ? next_pc_taken : next_pc_basic;
    endcase

    assign err = 1'b0;
endmodule