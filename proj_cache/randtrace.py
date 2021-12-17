import random

random.seed(0x1337)

for _ in range(100):
    op = random.choice(['rd', 'wr'])
    addr = random.randint(0x0000, 0x00ff)
    addr = addr & 0xfffe # word-aligned
    val = random.randint(0x0000, 0xffff)

    # print(f'{op} {addr:04x}')
    Rd = 1 if op == 'rd' else 0
    Wr = 1 if op == 'wr' else 0
    Value = val if Rd else 0
    print(f'{Rd} {Wr} {addr} {Value}')
