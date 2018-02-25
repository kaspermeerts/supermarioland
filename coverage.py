#!/usr/bin/python
import os

BANKS = 4
BANK_SIZE = 1 << 16 >> 2
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
