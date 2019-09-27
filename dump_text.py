import struct

BANKS = 4
BANK_SIZE = 1 << 16 >> 2
ROM_SIZE = BANKS * BANK_SIZE

with open("baserom.gb", "rb") as f:
    rom = f.read()

assert len(rom) == ROM_SIZE

charmap = {
  0x00: "0",
  0x01: "1",
  0x02: "2",
  0x03: "3",
  0x04: "4",
  0x05: "5",
  0x06: "6",
  0x07: "7",
  0x08: "8",
  0x09: "9",
  0x0A: "a",
  0x0B: "b",
  0x0C: "c",
  0x0D: "d",
  0x0E: "e",
  0x0F: "f",
  0x10: "g",
  0x11: "h",
  0x12: "i",
  0x14: "k",
  0x15: "l",
  0x16: "m",
  0x17: "n",
  0x18: "o",
  0x19: "p",
  0x1a: "q",
  0x1b: "r",
  0x1c: "s",
  0x1d: "t",
  0x1e: "u",
  0x1f: "v",
  0x20: "w",
  0x22: "y",
  0x23: ".",
  0x25: ":",
  0x26: ",",
  0x27: "z",
  0x28: "!",
  0x29: "-",
  0x2A: "$",
  0x2B: "*",
  0x2C: " ",
  0x84: "♥"
}

text_ptr = 0x1557
byte = 0x00

while byte != 0xFF:
    byte = rom[text_ptr]
    text_ptr += 1
    if byte == 0xFF:
        break
    elif byte == 0xFE:
        print("\", $FE\ndb \"", end='')
    else:
        print(charmap[byte], end='')

