/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module proc (/*AUTOARG*/
   // Outputs
   err, 
   // Inputs
   clk, rst
);

    input wire clk;
    input wire rst;

    output wire err;

    // None of the above lines can be modified
    // but i did anyway. because karu wrote this in 2009 and apparently didn't think nettypes were important??

    // compute an error signal for debugging bad states
    assign err = |{1'b0}; // TODO


    // IF -> ID -> EX -> MEM -> WB

    // ==== notes: ====
    // 
    // branches are predicted in IF, and resolved in EX;
    // this means we will need to squash two instructions each time we mispredict a branch.

    // -- INSTRUCTION FETCH
    fetch fetch ();

    // -- BOUNDARY: IF/ID
    flop_if2id fl_if2id ();

    // -- INSTRUCTION DECODE
    decode decode ();

    // -- BOUNDARY: ID/EX
    flop_id2ex fl_id2ex (); 

    // -- EXECUTE
    execute execute ();

    // -- BOUNDARY: EX/MEM
    flop_ex2mem fl_ex2mem (); 

    // -- MEMORY
    memory memory ();

    // -- BOUNDARY: MEM/WB
    flop_mem2wb fl_mem2wb (); 

    // -- WRITEBACK
    writeback writeback ();

endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
