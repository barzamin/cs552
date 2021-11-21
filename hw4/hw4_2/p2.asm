/// ---------------- 1 ----------------
lbi r0, 64
lbi r1, 2
lbi r2, 0

.loop1:
    add r2, r2, r1
    subi r0, r0, 1
    bnez .loop1


nop
nop


/// ---------------- 2 ----------------
lbi r0, 64
lbi r1, 2
lbi r2, 0

.loop2:
    beqz r0, .exit2
    add r2, r2, r1
    subi r0, r0, 1
    j .loop2

.exit2:
