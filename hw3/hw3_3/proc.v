module proc(
    input  wire clk,
    input  wire rst,
    output wire err
);
    reg halt; // stops the processor simulation

    // register indices: dest, source, secondary source
    reg  [2:0] rd;
    wire [2:0] rs;
    wire [2:0] rt;
    // data loaded from source registers
    wire [15:0] rs_data, rt_data;
    reg reg_write_en; // are we writing back to rd?
    wire [15:0] writeback_data; // data we're writing back

    wire rf_err;
    rf register_file(
        .clk        (clk),
        .rst        (rst),
        .err        (rf_err),
        .read1regsel(rs),
        .read2regsel(rt),
        .read1data  (rs_data),
        .read2data  (rt_data),
        .writeregsel(rd),
        .write      (reg_write_en),
        .writedata  (writeback_data)
    );

    wire fetch_err;
    wire [15:0] instr;
    fetch fetch_unit(
        .clk  (clk),
        .rst  (rst),
        .err  (fetch_err),
        .instr(instr)
    );

    reg alu_op;
    reg [15:0] alu_B;
    alu alu (
        .A   (rs_data),
        .B   (alu_B),
        .out (writeback_data),
        .op  (alu_op)
    );

    // decoding
    assign rs = instr[10:8];
    assign rt = instr[7:5];

    wire [4:0] imm0;
    wire [15:0] imm0_sext;
    assign imm0 = instr[4:0];
    sext #(.INW(5), .OUTW(16)) imm0_sign_extender (
        .in(imm0),
        .out(imm0_sext)
    );

    reg decode_err;
    wire [4:0] opcode;
    assign opcode = instr[15:11];
    localparam OP_HALT = 5'b00000;
    localparam OP_ADDI = 5'b01000;
    localparam OP_XOR  = 5'b11011;
    localparam OP_BEQZ = 5'b01100;
    always @* begin
        halt = 0;
        decode_err = 0;
        alu_B = 16'h0;
        alu_op = 1;
        reg_write_en = 0;
        rd = 3'b000;
        case (opcode)
            OP_HALT : begin
                halt = 1;
            end
            OP_ADDI : begin
                alu_B = imm0_sext;
                alu_op = 0;

                reg_write_en = 1;
                rd = instr[7:5];
            end
            OP_XOR : begin
                alu_B = rt_data;
                alu_op = 1;

                reg_write_en = 1;
                rd = instr[4:2];
            end
            default : begin
                decode_err = 1;
            end
        endcase
    end

    assign err = rf_err | fetch_err | decode_err;
endmodule
