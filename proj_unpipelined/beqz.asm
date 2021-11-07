lbi r1, 1
lbi r2, 0
beqz r1, .taken
lbi r2, 1
.taken:
beqz r2, .nottaken
xor r1, r1, r1
.nottaken:
xor r2, r2, r2
