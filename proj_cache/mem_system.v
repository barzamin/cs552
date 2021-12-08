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

   output wire [15:0] DataOut,
   output wire Done,
   output wire Stall,
   output wire CacheHit,
   output wire err
);
   /* data_mem = 1, inst_mem = 0 *
    * needed for cache parameter */
   parameter memtype = 0;
   wire cache_err;
   wire cache_en;
   wire [15:0] cache_din;
   wire [2:0]  cache_offset;
   cache #(0 + memtype) c0(// Outputs
                          .tag_out              (),
                          .data_out             (),
                          .hit                  (),
                          .dirty                (),
                          .valid                (),
                          .err                  (cache_err),
                          // Inputs
                          .enable               (cache_en),
                          .clk                  (clk),
                          .rst                  (rst),
                          .createdump           (createdump),
                          .tag_in               (),
                          .index                (),
                          .offset               (cache_offset),
                          .data_in              (cache_din),
                          .comp                 (),
                          .write                (),
                          .valid_in             ());

   wire [15:0] mem_dout;
   wire mem_stall;
   wire [3:0] mem_busy;
   wire mem_err;
   wire [15:0] mem_addr;
   wire [15:0] mem_din;
   wire mem_wr, mem_rd;

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

   
   // your code here

   
endmodule // mem_system

// DUMMY LINE FOR REV CONTROL :9:
