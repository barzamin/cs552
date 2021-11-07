lbi r1, 0
lbi r2, 2
seq r3, r1, r2  // r3 <- (r1 == r2) = 0
seq r4, r3, r1  // r4 <- (r3 == r1) = (0 == 0) = 1