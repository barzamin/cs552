lbi r7, 69 // val
lbi r1, 4  // addr
st r7, r1, 0
lbi r2, 11
nop
nop
nop
nop
nop
ld r0, r1, 0 // r0 <- M[r1 + 0] = M[4] = 69
xor r3, r2, r0
halt
