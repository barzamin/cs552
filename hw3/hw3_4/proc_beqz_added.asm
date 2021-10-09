addi r1, r0, 8
beqz r1, -1  // doesn't exec
xor r1, r1, r1 // zero
beqz r1, .lbl
halt
.lbl:
addi r2, r0, 5
halt
