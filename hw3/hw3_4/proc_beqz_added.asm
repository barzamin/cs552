addi r1, r0, 8
beqz r1, -1      // branch not taken
xor r1, r1, r1   // r1 <- 0
beqz r1, .lbl    // branch taken
halt             // skipped
.lbl:
addi r2, r0, 5   // next instruction executed after beqz
halt
