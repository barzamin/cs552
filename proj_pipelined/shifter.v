module shifter(   
    input  wire [15:0] in,
    input  wire [3:0]  shamt,
    input  wire        rotate,
    output wire [15:0] out
);
    wire pad;
    assign pad = 0;

    // nb: generated with `shifter.py` (in this directory)
    /* ---------------- 16-bit right barrel shifter and rotator ----------------*/
    //// shift layer 2^0 = 1 ////
    wire [15:0] shifted1;
    wire [0:0] s1_infill;
    // shift muxes
    mux2_1 s1_mux0  ( .s(shamt[0]), .in0(in[0]),  .in1(in[1]),  .out(shifted1[0])  );
    mux2_1 s1_mux1  ( .s(shamt[0]), .in0(in[1]),  .in1(in[2]),  .out(shifted1[1])  );
    mux2_1 s1_mux2  ( .s(shamt[0]), .in0(in[2]),  .in1(in[3]),  .out(shifted1[2])  );
    mux2_1 s1_mux3  ( .s(shamt[0]), .in0(in[3]),  .in1(in[4]),  .out(shifted1[3])  );
    mux2_1 s1_mux4  ( .s(shamt[0]), .in0(in[4]),  .in1(in[5]),  .out(shifted1[4])  );
    mux2_1 s1_mux5  ( .s(shamt[0]), .in0(in[5]),  .in1(in[6]),  .out(shifted1[5])  );
    mux2_1 s1_mux6  ( .s(shamt[0]), .in0(in[6]),  .in1(in[7]),  .out(shifted1[6])  );
    mux2_1 s1_mux7  ( .s(shamt[0]), .in0(in[7]),  .in1(in[8]),  .out(shifted1[7])  );
    mux2_1 s1_mux8  ( .s(shamt[0]), .in0(in[8]),  .in1(in[9]),  .out(shifted1[8])  );
    mux2_1 s1_mux9  ( .s(shamt[0]), .in0(in[9]),  .in1(in[10]), .out(shifted1[9])  );
    mux2_1 s1_mux10 ( .s(shamt[0]), .in0(in[10]), .in1(in[11]), .out(shifted1[10]) );
    mux2_1 s1_mux11 ( .s(shamt[0]), .in0(in[11]), .in1(in[12]), .out(shifted1[11]) );
    mux2_1 s1_mux12 ( .s(shamt[0]), .in0(in[12]), .in1(in[13]), .out(shifted1[12]) );
    mux2_1 s1_mux13 ( .s(shamt[0]), .in0(in[13]), .in1(in[14]), .out(shifted1[13]) );
    mux2_1 s1_mux14 ( .s(shamt[0]), .in0(in[14]), .in1(in[15]), .out(shifted1[14]) );
    mux2_1 s1_mux15 ( .s(shamt[0]), .in0(in[15]), .in1(s1_infill[0]), .out(shifted1[15]) );
    // infill muxes
    mux2_1 s1_fillmux0 ( .s(rotate), .in0(pad), .in1(in[0]), .out(s1_infill[0]) );

    //// shift layer 2^1 = 2 ////
    wire [15:0] shifted2;
    wire [1:0] s2_infill;
    // shift muxes
    mux2_1 s2_mux0  ( .s(shamt[1]), .in0(shifted1[0]),  .in1(shifted1[2]),  .out(shifted2[0])  );
    mux2_1 s2_mux1  ( .s(shamt[1]), .in0(shifted1[1]),  .in1(shifted1[3]),  .out(shifted2[1])  );
    mux2_1 s2_mux2  ( .s(shamt[1]), .in0(shifted1[2]),  .in1(shifted1[4]),  .out(shifted2[2])  );
    mux2_1 s2_mux3  ( .s(shamt[1]), .in0(shifted1[3]),  .in1(shifted1[5]),  .out(shifted2[3])  );
    mux2_1 s2_mux4  ( .s(shamt[1]), .in0(shifted1[4]),  .in1(shifted1[6]),  .out(shifted2[4])  );
    mux2_1 s2_mux5  ( .s(shamt[1]), .in0(shifted1[5]),  .in1(shifted1[7]),  .out(shifted2[5])  );
    mux2_1 s2_mux6  ( .s(shamt[1]), .in0(shifted1[6]),  .in1(shifted1[8]),  .out(shifted2[6])  );
    mux2_1 s2_mux7  ( .s(shamt[1]), .in0(shifted1[7]),  .in1(shifted1[9]),  .out(shifted2[7])  );
    mux2_1 s2_mux8  ( .s(shamt[1]), .in0(shifted1[8]),  .in1(shifted1[10]), .out(shifted2[8])  );
    mux2_1 s2_mux9  ( .s(shamt[1]), .in0(shifted1[9]),  .in1(shifted1[11]), .out(shifted2[9])  );
    mux2_1 s2_mux10 ( .s(shamt[1]), .in0(shifted1[10]), .in1(shifted1[12]), .out(shifted2[10]) );
    mux2_1 s2_mux11 ( .s(shamt[1]), .in0(shifted1[11]), .in1(shifted1[13]), .out(shifted2[11]) );
    mux2_1 s2_mux12 ( .s(shamt[1]), .in0(shifted1[12]), .in1(shifted1[14]), .out(shifted2[12]) );
    mux2_1 s2_mux13 ( .s(shamt[1]), .in0(shifted1[13]), .in1(shifted1[15]), .out(shifted2[13]) );
    mux2_1 s2_mux14 ( .s(shamt[1]), .in0(shifted1[14]), .in1(s2_infill[0]), .out(shifted2[14]) );
    mux2_1 s2_mux15 ( .s(shamt[1]), .in0(shifted1[15]), .in1(s2_infill[1]), .out(shifted2[15]) );
    // infill muxes
    mux2_1 s2_fillmux0 ( .s(rotate), .in0(pad), .in1(shifted1[0]), .out(s2_infill[0]) );
    mux2_1 s2_fillmux1 ( .s(rotate), .in0(pad), .in1(shifted1[1]), .out(s2_infill[1]) );

    //// shift layer 2^2 = 4 ////
    wire [15:0] shifted4;
    wire [3:0] s4_infill;
    // shift muxes
    mux2_1 s4_mux0  ( .s(shamt[2]), .in0(shifted2[0]),  .in1(shifted2[4]),  .out(shifted4[0])  );
    mux2_1 s4_mux1  ( .s(shamt[2]), .in0(shifted2[1]),  .in1(shifted2[5]),  .out(shifted4[1])  );
    mux2_1 s4_mux2  ( .s(shamt[2]), .in0(shifted2[2]),  .in1(shifted2[6]),  .out(shifted4[2])  );
    mux2_1 s4_mux3  ( .s(shamt[2]), .in0(shifted2[3]),  .in1(shifted2[7]),  .out(shifted4[3])  );
    mux2_1 s4_mux4  ( .s(shamt[2]), .in0(shifted2[4]),  .in1(shifted2[8]),  .out(shifted4[4])  );
    mux2_1 s4_mux5  ( .s(shamt[2]), .in0(shifted2[5]),  .in1(shifted2[9]),  .out(shifted4[5])  );
    mux2_1 s4_mux6  ( .s(shamt[2]), .in0(shifted2[6]),  .in1(shifted2[10]), .out(shifted4[6])  );
    mux2_1 s4_mux7  ( .s(shamt[2]), .in0(shifted2[7]),  .in1(shifted2[11]), .out(shifted4[7])  );
    mux2_1 s4_mux8  ( .s(shamt[2]), .in0(shifted2[8]),  .in1(shifted2[12]), .out(shifted4[8])  );
    mux2_1 s4_mux9  ( .s(shamt[2]), .in0(shifted2[9]),  .in1(shifted2[13]), .out(shifted4[9])  );
    mux2_1 s4_mux10 ( .s(shamt[2]), .in0(shifted2[10]), .in1(shifted2[14]), .out(shifted4[10]) );
    mux2_1 s4_mux11 ( .s(shamt[2]), .in0(shifted2[11]), .in1(shifted2[15]), .out(shifted4[11]) );
    mux2_1 s4_mux12 ( .s(shamt[2]), .in0(shifted2[12]), .in1(s4_infill[0]), .out(shifted4[12]) );
    mux2_1 s4_mux13 ( .s(shamt[2]), .in0(shifted2[13]), .in1(s4_infill[1]), .out(shifted4[13]) );
    mux2_1 s4_mux14 ( .s(shamt[2]), .in0(shifted2[14]), .in1(s4_infill[2]), .out(shifted4[14]) );
    mux2_1 s4_mux15 ( .s(shamt[2]), .in0(shifted2[15]), .in1(s4_infill[3]), .out(shifted4[15]) );
    // infill muxes
    mux2_1 s4_fillmux0 ( .s(rotate), .in0(pad), .in1(shifted2[0]), .out(s4_infill[0]) );
    mux2_1 s4_fillmux1 ( .s(rotate), .in0(pad), .in1(shifted2[1]), .out(s4_infill[1]) );
    mux2_1 s4_fillmux2 ( .s(rotate), .in0(pad), .in1(shifted2[2]), .out(s4_infill[2]) );
    mux2_1 s4_fillmux3 ( .s(rotate), .in0(pad), .in1(shifted2[3]), .out(s4_infill[3]) );

    //// shift layer 2^3 = 8 ////
    wire [15:0] shifted8;
    wire [7:0] s8_infill;
    // shift muxes
    mux2_1 s8_mux0  ( .s(shamt[3]), .in0(shifted4[0]),  .in1(shifted4[8]),  .out(shifted8[0])  );
    mux2_1 s8_mux1  ( .s(shamt[3]), .in0(shifted4[1]),  .in1(shifted4[9]),  .out(shifted8[1])  );
    mux2_1 s8_mux2  ( .s(shamt[3]), .in0(shifted4[2]),  .in1(shifted4[10]), .out(shifted8[2])  );
    mux2_1 s8_mux3  ( .s(shamt[3]), .in0(shifted4[3]),  .in1(shifted4[11]), .out(shifted8[3])  );
    mux2_1 s8_mux4  ( .s(shamt[3]), .in0(shifted4[4]),  .in1(shifted4[12]), .out(shifted8[4])  );
    mux2_1 s8_mux5  ( .s(shamt[3]), .in0(shifted4[5]),  .in1(shifted4[13]), .out(shifted8[5])  );
    mux2_1 s8_mux6  ( .s(shamt[3]), .in0(shifted4[6]),  .in1(shifted4[14]), .out(shifted8[6])  );
    mux2_1 s8_mux7  ( .s(shamt[3]), .in0(shifted4[7]),  .in1(shifted4[15]), .out(shifted8[7])  );
    mux2_1 s8_mux8  ( .s(shamt[3]), .in0(shifted4[8]),  .in1(s8_infill[0]), .out(shifted8[8])  );
    mux2_1 s8_mux9  ( .s(shamt[3]), .in0(shifted4[9]),  .in1(s8_infill[1]), .out(shifted8[9])  );
    mux2_1 s8_mux10 ( .s(shamt[3]), .in0(shifted4[10]), .in1(s8_infill[2]), .out(shifted8[10]) );
    mux2_1 s8_mux11 ( .s(shamt[3]), .in0(shifted4[11]), .in1(s8_infill[3]), .out(shifted8[11]) );
    mux2_1 s8_mux12 ( .s(shamt[3]), .in0(shifted4[12]), .in1(s8_infill[4]), .out(shifted8[12]) );
    mux2_1 s8_mux13 ( .s(shamt[3]), .in0(shifted4[13]), .in1(s8_infill[5]), .out(shifted8[13]) );
    mux2_1 s8_mux14 ( .s(shamt[3]), .in0(shifted4[14]), .in1(s8_infill[6]), .out(shifted8[14]) );
    mux2_1 s8_mux15 ( .s(shamt[3]), .in0(shifted4[15]), .in1(s8_infill[7]), .out(shifted8[15]) );
    // infill muxes
    mux2_1 s8_fillmux0 ( .s(rotate), .in0(pad), .in1(shifted4[0]), .out(s8_infill[0]) );
    mux2_1 s8_fillmux1 ( .s(rotate), .in0(pad), .in1(shifted4[1]), .out(s8_infill[1]) );
    mux2_1 s8_fillmux2 ( .s(rotate), .in0(pad), .in1(shifted4[2]), .out(s8_infill[2]) );
    mux2_1 s8_fillmux3 ( .s(rotate), .in0(pad), .in1(shifted4[3]), .out(s8_infill[3]) );
    mux2_1 s8_fillmux4 ( .s(rotate), .in0(pad), .in1(shifted4[4]), .out(s8_infill[4]) );
    mux2_1 s8_fillmux5 ( .s(rotate), .in0(pad), .in1(shifted4[5]), .out(s8_infill[5]) );
    mux2_1 s8_fillmux6 ( .s(rotate), .in0(pad), .in1(shifted4[6]), .out(s8_infill[6]) );
    mux2_1 s8_fillmux7 ( .s(rotate), .in0(pad), .in1(shifted4[7]), .out(s8_infill[7]) );

    assign out = shifted8;
endmodule
