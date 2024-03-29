// `default_nettype none
/* $Author: karu $ */
/* $LastChangedDate: 2009-04-24 09:28:13 -0500 (Fri, 24 Apr 2009) $ */
/* $Rev: 77 $ */

module mem_system(/*AUTOARG*/
    input  wire [15:0] Addr,
    input  wire [15:0] DataIn,
    input  wire        Rd,
    input  wire        Wr,
    input  wire        createdump,
    input  wire        clk,
    input  wire        rst,

    output reg  [15:0] DataOut,
    output reg  Done,
    output reg  Stall,
    output reg  CacheHit,
    output wire err
);
    wire cache_err, mem_err;
    reg ctl_err;
    assign err = |{cache_err, mem_err, ctl_err};

    /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
    parameter memtype = 0;
    reg  cache_en;
    wire cache_hit;
    wire line_valid;
    wire line_dirty;
    reg  cache_comp;
    reg  [15:0] cache_din;
    wire [15:0] cache_dout;
    reg  [4:0]  cache_tag_in;
    wire [4:0]  cache_tag_out;
    reg  [7:0]  cache_index;
    reg  [2:0]  cache_offset;
    reg  cache_wr;
    reg  cache_valid_in;
    cache #(0 + memtype) c0(// Outputs
                          .tag_out              (cache_tag_out),
                          .data_out             (cache_dout),
                          .hit                  (cache_hit),
                          .dirty                (line_dirty),
                          .valid                (line_valid),
                          .err                  (cache_err),
                          // Inputs
                          .enable               (cache_en),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (cache_tag_in),
                          .index                (cache_index),
                          .offset               (cache_offset),
                          .data_in              (cache_din),
                          .comp                 (cache_comp),
                          .write                (cache_wr),
                          .valid_in             (cache_valid_in));

    wire [15:0] mem_dout;
    wire mem_stall;
    wire [3:0] mem_busy;
    reg  [15:0] mem_addr;
    reg  [15:0] mem_din;
    reg  mem_wr, mem_rd;

    four_bank_mem mem(// Outputs
                     .data_out          (mem_dout),
                     .stall             (mem_stall),
                     .busy              (mem_busy),
                     .err               (mem_err),
                     // Inputs
                     .clk               (clk),
                     .rst               (rst),
                     .createdump        (createdump),
                     .addr              (mem_addr),
                     .data_in           (mem_din),
                     .wr                (mem_wr),
                     .rd                (mem_rd));


    localparam WOFFS0 = 3'b000;
    localparam WOFFS1 = 3'b010;
    localparam WOFFS2 = 3'b100;
    localparam WOFFS3 = 3'b110;

    localparam STATE_IDLE     = 6'b000000;
    localparam STATE_RD_START = 6'b000001;

    localparam STATE_RD_EVICT_WORD0 = 6'b000011;
    localparam STATE_RD_EVICT_WORD1 = 6'b000100;
    localparam STATE_RD_EVICT_WORD2 = 6'b000101;
    localparam STATE_RD_EVICT_WORD3 = 6'b000110;

    localparam STATE_RD_LOAD_WORD0 = 6'b001011;
    localparam STATE_RD_LOAD_WORD1 = 6'b001100;
    localparam STATE_RD_LOAD_WORD2 = 6'b001101;
    localparam STATE_RD_LOAD_WORD3 = 6'b001110;
    localparam STATE_RD_LOAD_WAIT0 = 6'b001111;
    localparam STATE_RD_LOAD_DONE  = 6'b010000;
    localparam STATE_RD_FROM_CACHE = 6'b010001; // TODO could probably obviate need by knowing when to assert done as data is retned

    localparam STATE_WR_START = 6'b100000;

    localparam STATE_WR_EVICT_WORD0 = 6'b100011;
    localparam STATE_WR_EVICT_WORD1 = 6'b100100;
    localparam STATE_WR_EVICT_WORD2 = 6'b100101;
    localparam STATE_WR_EVICT_WORD3 = 6'b100110;

    localparam STATE_WR_LOAD_WORD0 = 6'b101011;
    localparam STATE_WR_LOAD_WORD1 = 6'b101100;
    localparam STATE_WR_LOAD_WORD2 = 6'b101101;
    localparam STATE_WR_LOAD_WORD3 = 6'b101110;
    localparam STATE_WR_LOAD_WAIT0 = 6'b101111;
    localparam STATE_WR_LOAD_DONE  = 6'b110000;
    localparam STATE_WR_TO_CACHE = 6'b110001;

    localparam STATE_INVALID = 6'b111111;


    reg  [5:0] next_state;
    wire [5:0] state;
    register #(.WIDTH(6)) r_state (
        .clk       (clk),
        .rst       (rst),
        .write_data(next_state),
        .read_data (state),
        .write_en  (1'b1)
    );

    always @* begin
        ctl_err = 1'b0;

        next_state = STATE_INVALID; // try to catch errs

        Stall    = 1'b1; // stall is 1 in all states but IDLE
        Done     = 1'b0;
        CacheHit = 1'b0;

        DataOut  = cache_dout; // always output data from cache

        cache_en     = 1'b0;
        cache_comp   = 1'b0;
        cache_wr     = 1'b0;
        cache_valid_in = 1'b1; // if we do a write it will always be writing in a valid line
        cache_offset = Addr[2:0];
        cache_index  = Addr[10:3];
        cache_tag_in = Addr[15:11]; // normally just from input addr; loopback when we evict

        mem_addr = 16'h0000;

        mem_wr     = 1'b0;
        mem_rd     = 1'b0;
        mem_din    = cache_dout;
        cache_din  = mem_dout;

        case (state)
            STATE_IDLE : begin
                Stall = 1'b0;
                next_state = Rd ? STATE_RD_START :
                             Wr ? STATE_WR_START :
                                  STATE_IDLE;
            end

            // -- read path
            STATE_RD_START : begin
                // turn on cache, compare tag, did we hit?
                cache_en = 1'b1;
                cache_comp = 1'b1;

                CacheHit = cache_hit & line_valid;
                Done = cache_hit & line_valid;

                // $display("STATE_RD_START: cache_hit=%b, line_valid=%b, line_dirty=%b", cache_hit, line_valid, line_dirty);

                // if we hit, everything's good; otherwise, we need to load or evict (iff dirty).
                next_state = (cache_hit & line_valid) ? STATE_IDLE :
                             line_dirty ? STATE_RD_EVICT_WORD0 : STATE_RD_LOAD_WORD0;
            end

            STATE_RD_EVICT_WORD0 : begin
                cache_en = 1'b1;
                cache_tag_in = cache_tag_out;
                cache_offset = WOFFS0;

                mem_addr = {cache_tag_out, cache_index, WOFFS0};
                mem_wr = 1'b1;

                next_state = STATE_RD_EVICT_WORD1;
            end

            STATE_RD_EVICT_WORD1 : begin
                cache_en = 1'b1;
                cache_tag_in = cache_tag_out;
                cache_offset = WOFFS1;

                mem_addr = {cache_tag_out, cache_index, WOFFS1};
                mem_wr = 1'b1;

                next_state = STATE_RD_EVICT_WORD2;
            end

            STATE_RD_EVICT_WORD2 : begin
                cache_en = 1'b1;
                cache_tag_in = cache_tag_out;
                cache_offset = WOFFS2;

                mem_addr = {cache_tag_out, cache_index, WOFFS2};
                mem_wr = 1'b1;

                next_state = STATE_RD_EVICT_WORD3;
            end

            STATE_RD_EVICT_WORD3 : begin
                cache_en = 1'b1;
                cache_tag_in = cache_tag_out;
                cache_offset = WOFFS3;

                mem_addr = {cache_tag_out, cache_index, WOFFS3};
                mem_wr = 1'b1;

                next_state = STATE_RD_LOAD_WORD0;
            end

            // can go directly to loads since we have
            // mem WR w0  \ * b0 stalled
            // mem WR w1  | *
            // mem WR w2  | *
            // mem WR w3  | * <- w0 write commits here
            // mem RD w0  /   <- so we can read it here

            STATE_RD_LOAD_WORD0 : begin
                mem_addr = {Addr[15:3], WOFFS0};
                mem_rd = 1'b1;

                next_state = STATE_RD_LOAD_WORD1;
            end

            STATE_RD_LOAD_WORD1 : begin
                mem_addr = {Addr[15:3], WOFFS1};
                mem_rd = 1'b1;

                next_state = STATE_RD_LOAD_WORD2;
            end

            STATE_RD_LOAD_WORD2 : begin
                mem_addr = {Addr[15:3], WOFFS2};
                mem_rd = 1'b1;

                cache_en = 1'b1;
                cache_wr = 1'b1;
                cache_offset = WOFFS0; // first request is returning 2 cycles later

                next_state = STATE_RD_LOAD_WORD3;
            end

            STATE_RD_LOAD_WORD3 : begin
                mem_addr = {Addr[15:3], WOFFS3};
                mem_rd = 1'b1;

                cache_en = 1'b1;
                cache_wr = 1'b1;
                cache_offset = WOFFS1;

                next_state = STATE_RD_LOAD_WAIT0;
            end

            STATE_RD_LOAD_WAIT0 : begin
                cache_en = 1'b1;
                cache_wr = 1'b1;
                cache_offset = WOFFS2;

                next_state = STATE_RD_LOAD_DONE;
            end

            STATE_RD_LOAD_DONE : begin
                cache_en = 1'b1;
                cache_wr = 1'b1;
                cache_offset = WOFFS3;

                next_state = STATE_RD_FROM_CACHE;
            end

            STATE_RD_FROM_CACHE : begin
                Done = 1'b1;

                cache_en = 1'b1;
                cache_comp = 1'b1;

                next_state = STATE_IDLE;
            end


            // -- write path
            STATE_WR_START : begin
                // try to checked write directly to cache
                cache_en = 1'b1;
                cache_wr = 1'b1;
                cache_comp = 1'b1;
                cache_din = DataIn;

                CacheHit = cache_hit & line_valid;
                Done = cache_hit & line_valid;

                // are we done (hit cache) or do we need to handle a miss?
                next_state = (cache_hit & line_valid) ? STATE_IDLE :
                             line_dirty ? STATE_WR_EVICT_WORD0 : STATE_WR_LOAD_WORD0;
            end

            STATE_WR_EVICT_WORD0 : begin
                cache_en = 1'b1;
                cache_tag_in = cache_tag_out;
                cache_offset = WOFFS0;

                mem_addr = {cache_tag_out, cache_index, WOFFS0};
                mem_wr = 1'b1;

                next_state = STATE_WR_EVICT_WORD1;
            end

            STATE_WR_EVICT_WORD1 : begin
                cache_en = 1'b1;
                cache_tag_in = cache_tag_out;
                cache_offset = WOFFS1;

                mem_addr = {cache_tag_out, cache_index, WOFFS1};
                mem_wr = 1'b1;

                next_state = STATE_WR_EVICT_WORD2;
            end

            STATE_WR_EVICT_WORD2 : begin
                cache_en = 1'b1;
                cache_tag_in = cache_tag_out;
                cache_offset = WOFFS2;

                mem_addr = {cache_tag_out, cache_index, WOFFS2};
                mem_wr = 1'b1;

                next_state = STATE_WR_EVICT_WORD3;
            end

            STATE_WR_EVICT_WORD3 : begin
                cache_en = 1'b1;
                cache_tag_in = cache_tag_out;
                cache_offset = WOFFS3;

                mem_addr = {cache_tag_out, cache_index, WOFFS3};
                mem_wr = 1'b1;

                next_state = STATE_WR_LOAD_WORD0;
            end

            // can go directly to loads since we have
            // mem WR w0  \ * b0 stalled
            // mem WR w1  | *
            // mem WR w2  | *
            // mem WR w3  | * <- w0 write commits here
            // mem RD w0  /   <- so we can read it here

            STATE_WR_LOAD_WORD0 : begin
                mem_addr = {Addr[15:3], WOFFS0};
                mem_rd = 1'b1;

                next_state = STATE_WR_LOAD_WORD1;
            end

            STATE_WR_LOAD_WORD1 : begin
                mem_addr = {Addr[15:3], WOFFS1};
                mem_rd = 1'b1;

                next_state = STATE_WR_LOAD_WORD2;
            end

            STATE_WR_LOAD_WORD2: begin
                mem_addr = {Addr[15:3], WOFFS2};
                mem_rd = 1'b1;

                cache_en = 1'b1;
                cache_wr = 1'b1;
                cache_offset = WOFFS0; // first request is returning 2 cycles later

                next_state = STATE_WR_LOAD_WORD3;
            end

            STATE_WR_LOAD_WORD3: begin
                mem_addr = {Addr[15:3], WOFFS3};
                mem_rd = 1'b1;

                cache_en = 1'b1;
                cache_wr = 1'b1;
                cache_offset = WOFFS1;

                next_state = STATE_WR_LOAD_WAIT0;
            end

            STATE_WR_LOAD_WAIT0 : begin
                cache_en = 1'b1;
                cache_wr = 1'b1;
                cache_offset = WOFFS2;

                next_state = STATE_WR_LOAD_DONE;
            end


            STATE_WR_LOAD_DONE : begin
                cache_en = 1'b1;
                cache_wr = 1'b1;
                cache_offset = WOFFS3;

                next_state = STATE_WR_TO_CACHE;
            end

           STATE_WR_TO_CACHE : begin
                Done = 1'b1;

                cache_din = DataIn;
                cache_en = 1'b1;
                cache_comp = 1'b1;
                cache_wr = 1'b1;

                next_state = STATE_IDLE;
            end


            default : begin
                ctl_err = 1'b1;
            end
        endcase
    end
endmodule // mem_system

// DUMMY LINE FOR REV CONTROL :9:
