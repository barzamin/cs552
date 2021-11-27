`default_nettype none
module execute (
    output wire err,

    input  wire [3:0]  alu_op,
    input  wire        alu_b_imm,

    input  wire [2:0]  fcu_op,
    input  wire        writeflag,

    input  wire [1:0]  fwd_X,
    input  wire [1:0]  fwd_Y,
    input  wire [15:0] MEM_alu_out,
    input  wire [15:0] WB_wb_data,

    input  wire [15:0] vX,
    input  wire [15:0] vY,
    input  wire [15:0] imm16,

    output wire [15:0] EX_vY,

    output wire [15:0] alu_out,
    output wire        flag
);
    `include "ops.vh"
    // -- forwarding muxes
    reg [15:0] vX_fwd, vY_fwd;
    always @* case (fwd_X)
        default  : vX_fwd = vX; // FWDX_PASS
        FWDX_MEM : vX_fwd = MEM_alu_out;
        FWDX_WB  : vX_fwd = WB_wb_data;
    endcase
    always @* case (fwd_Y)
        default  : vY_fwd = vY; // FWDY_PASS
        FWDY_MEM : vY_fwd = MEM_alu_out;
        FWDY_WB  : vY_fwd = WB_wb_data;
    endcase

    assign EX_vY = vY_fwd;

    // -- alu input muxing
    wire [15:0] alu_A, alu_B;
    assign alu_A = vX_fwd;
    assign alu_B = alu_b_imm ? imm16 : vY_fwd;

    wire alu_zero, alu_ovf, alu_carry;
    wire [15:0] alu_out_direct;
    alu alu (
        .op      (alu_op),
        .A       (alu_A),
        .B       (alu_B),
        .out     (alu_out_direct),
        .zero    (alu_zero),
        .ovf     (alu_ovf),
        .carryout(alu_carry)
    );

    fcu fcu (
        .op  (fcu_op),

        .alu_out(alu_out),
        .zero   (alu_ovf),
        .carry  (alu_carry),
        .ovf    (alu_ovf),

        .flag (flag)
    );

    assign alu_out = writeflag ? {15'b0, flag} : alu_out_direct;

    assign err = 1'b0;
endmodule
