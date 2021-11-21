// -------- 1 --------
xor r0, r2, r3 
xor r1, r1, r0 // EX->EX

nop
nop

// -------- 2 --------
xor r0, r2, r3 
nop
xor r4, r0, r1 // forwards MEM->EX

nop
nop

// -------- 3 --------
ld r1, r0, 2
xor r3, r3, r1 // forwards MEM->EX, but we still need to stall for one cycle for memory to be ready.


nop
nop

// -------- 4 --------
ld r0, r1, 0 // r0 <- M[r1 + 0]
sw r0, r2, 0 // need r0 to store back. forward MEM->MEM
