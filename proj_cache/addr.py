import sys

def splitaddr(addr: int) -> (int, int, int):
    index  = (addr & 0b1111111100000000) >> 8
    tag    = (addr & 0b0000000011111000) >> 3
    offset = (addr & 0b0000000000000111)

    return index, tag, offset

if __name__ == '__main__':
    addr = int(sys.argv[1])
    idx, tag, offs = splitaddr(addr)

    print(f'index={idx}, tag={tag}, offset={offs}')
