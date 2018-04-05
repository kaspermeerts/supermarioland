#!/usr/bin/python
import os

BANKS = 4
BANK_SIZE = 1 << 16 >> 2
ROM_SIZE = BANK_SIZE * BANKS

# Funny how the Game Boy had to make do with 8 kB of RAM, and I can now use a 
# array many times that size without thinking about it. It's not even worth it
# at all to use a more efficient approach
coverage_map = [1] * ROM_SIZE

# Subtract what is included from the binary file
coverage = [BANK_SIZE] * BANKS

def tally_file(filepath):
    with open(filepath) as f:
        lines = f.readlines()

    for line in lines:
        s = line.rstrip("\n").split(", ")
        if not s[0].startswith('INCBIN') or not s[0].endswith('baserom.gb"'):
            continue

        assert len(s) == 3

        start = int(s[1][1:], 16)

        l = s[2].split(' - ')
        if len(l) == 1:
            length = int(l[0][1:], 16)
        elif len(l) == 2:
            length = int(l[0][1:], 16) - int(l[1][1:], 16)
        else:
            raise

        for i in range(length):
            coverage_map[start + i] = 0

        bank = start // BANK_SIZE
        coverage[bank] -= length

for root, dirs, files in os.walk("."):
    for file in files:
        if file.endswith(".asm"):
            tally_file(os.path.join(root, file))


for bank in range(BANKS):
    print("Bank {}: {:5} bytes: {:.3g}%".format(bank, coverage[bank], 100 * coverage[bank] / BANK_SIZE))

total_coverage = sum([c for c in coverage])
print("Total : {:5} bytes: {:.3g}%".format(total_coverage, 100 * total_coverage / (BANKS * BANK_SIZE)))

from PIL import Image

WIDTH = 64
HEIGHT = 64
KB_HEIGHT = 0x1000 // (WIDTH * 16)
BANK_HEIGHT = BANK_SIZE // (WIDTH * 16)
KB_MARGIN = 1
BANK_MARGIN = 2
assert WIDTH * HEIGHT * 16 == ROM_SIZE # 16 bytes per tile
SCALE = 4

PX_WIDTH = WIDTH * 8
PX_HEIGHT = HEIGHT * 8 + BANK_MARGIN * (BANKS - 1) + KB_MARGIN * (ROM_SIZE // 0x1000 - 1)

PALETTE1 = [(255,255,255), (160,160,160), (85,85,85), (0,0,0)]
PALETTE2 = [(155,188,15), (139,172,15), (48,98,48), (15,56,16)]

img = Image.new("P", (PX_WIDTH, PX_HEIGHT), 8)
#img.putpalette([
#    255,255,255, 180,180,180, 105,105,105, 0,0,0,      # Monochrome
#    0xE0,0xF8,0xD0, 0x88,0xC0,0x70, 0x34,0x68,0x56, 0x08,0x18,0x20,     # Game Boy palette
#    255,255,200
#])
img.putpalette([
    255,255,255, 160,160,160, 85,85,85, 0,0,0,      # Monochrome
    155,188,15, 139,172,15, 48,98,48, 15,56,16,     # Game Boy palette
    255,255,200
])

with open("baserom.gb", "rb") as f:
    rom = f.read()

def copy_tile(ix, iy, covered, bank, kb):
    tile = rom[(iy*WIDTH + ix) * 16:(iy*WIDTH + ix) * 16 + 16]

    for row in range(8):
        hi_byte = tile[row * 2 + 1]
        lo_byte = tile[row * 2]

        y = iy * 8 + row + bank * BANK_MARGIN + kb * KB_MARGIN

        x = ix * 8 + 0
        index = ((hi_byte & 0b10000000) >> 6) + ((lo_byte & 0b10000000) >> 7)
        img.putpixel((x,y), covered + index)
        x = ix * 8 + 1
        index = ((hi_byte & 0b01000000) >> 5) + ((lo_byte & 0b01000000) >> 6)
        img.putpixel((x,y), covered + index)
        x = ix * 8 + 2
        index = ((hi_byte & 0b00100000) >> 4) + ((lo_byte & 0b00100000) >> 5)
        img.putpixel((x,y), covered + index)
        x = ix * 8 + 3
        index = ((hi_byte & 0b00010000) >> 3) + ((lo_byte & 0b00010000) >> 4)
        img.putpixel((x,y), covered + index)
        x = ix * 8 + 4
        index = ((hi_byte & 0b00001000) >> 2) + ((lo_byte & 0b00001000) >> 3)
        img.putpixel((x,y), covered + index)
        x = ix * 8 + 5
        index = ((hi_byte & 0b00000100) >> 1) + ((lo_byte & 0b00000100) >> 2)
        img.putpixel((x,y), covered + index)
        x = ix * 8 + 6
        index = ((hi_byte & 0b00000010) >> 0) + ((lo_byte & 0b00000010) >> 1)
        img.putpixel((x,y), covered + index)
        x = ix * 8 + 7
        index = ((hi_byte & 0b00000001) << 1) + ((lo_byte & 0b00000001) >> 0)
        img.putpixel((x,y), covered + index)


for ix in range(WIDTH):
    for iy in range(HEIGHT):
        covered = all(coverage_map[(iy * WIDTH + ix)*16: (iy * WIDTH + ix)*16 + 16]) # any or all?
        copy_tile(ix, iy, 4 if covered else 0, iy // BANK_HEIGHT, iy // KB_HEIGHT)

img.save("coverage_map.png")
