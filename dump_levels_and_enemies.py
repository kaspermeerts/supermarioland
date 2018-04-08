import struct

enemy_names = []
with open("enemies.asm", "r") as f:
    for line in f:
        enemy_names.append(line.split(" ")[0])

with open("baserom.gb", "rb") as f:
    rom = f.read()

BANKS = 4
BANK_SIZE = 1 << 16 >> 2
ROM_SIZE = BANKS * BANK_SIZE

assert len(rom) == ROM_SIZE

# World "5" is the start menu and the hangar after a boss level
world_banks = [2, 1, 3, 1, 2]

def rom_offset(bank, address):
    assert address >= 0x4000
    return (bank - 1) * 0x4000 + address

def read_byte(bank, address):
    return rom[rom_offset(bank, address)]

def read_word(bank, address):
    offset = rom_offset(bank, address)
    return struct.unpack("<H", rom[offset: offset + 2])[0]

def dump_block(bank, block_pointer):
    column_pointer = block_pointer
    columns = 0
    byte = 0

    while columns < 20:
        byte = read_byte(bank, column_pointer)
        column_pointer += 1
        if byte == 0xFE:
            columns += 1

    print("%04x - %04x" % (block_pointer, column_pointer))

    filename = "levels/block-%d:%4x.bin" % (bank, block_pointer)
    with open(filename, "wb") as f:
        f.write(rom[block_pointer: column_pointer])

    blocks_dumped[block_pointer] = column_pointer

def level_index_to_world_level(index):
    world = (index // 3)
    level = index - world*3

    return "%d-%d" % (world+1,level+1)

def dump_level(levelname, bank, level_pointer):

    f.write('SECTION "level %s", ROMX[$%x], BANK[%d]\n\n' % (levelname, level_pointer, bank))
    f.write("level_%s:\n" % levelname)
    block = 0
    while True:
        sentinel = read_byte(bank, level_pointer + block * 2)
        if sentinel == 0xFF:
            break

        block_pointer = read_word(bank, level_pointer + block * 2)

        if block_pointer not in blocks_dumped:
            print("%02d: " % (block), end='')
            dump_block(bank, block_pointer)
        else:
            print("%02d: " % (block))

        f.write("\tdw block_%4x\n" % block_pointer)

        block += 1
    f.write("\tdb $ff\n\n")

def dump_enemy_locations(levelname, bank, enemy_pointer):
    g.write('SECTION "level %s enemies", ROMX[$%X], BANK[%d]\n\n' % (levelname, enemy_pointer, bank))
    g.write("level_%s_enemies:\n" % levelname)

    pointer = enemy_pointer

    while True:
        progress = read_byte(bank, pointer)
        pointer += 1
        position = read_byte(bank, pointer)
        pointer += 1
        enemy_id = read_byte(bank, pointer)
        pointer += 1
        if progress == 0xFF:
            g.write("\tdb $FF ; end of list\n")
            if position == 0xFF:
                g.write("\tdb $FF ; end of list (again, sigh)\n")
            break

        g.write("\tdb $%02X, $%02X, %s" % (progress, position, enemy_names[enemy_id & 0x7F]))
        if enemy_id & 0x80 == 0x80:
            g.write(" | $80")
        g.write("\n")

    g.write("\n")


f = open("levels/levels.asm", "w")
g = open("levels/enemy_locations.asm", "w")
g.write('INCLUDE "enemies.asm"\n\n')

blocks_dumped = {}

for level in range(12):

    levelname = "%d_%d" % (level // 3 + 1, level % 3 + 1)

    bank = world_banks[level // 3]
    level_pointer = read_word(bank, 0x4000 + 2 * level)
    dump_level(levelname, bank, level_pointer)

    enemy_pointer = read_word(bank, 0x401A + 2 * level)
    dump_enemy_locations(levelname, bank, enemy_pointer)


f.write('SECTION "level %s blocks", ROMX[$%x], BANK[%d]\n\n' % (levelname, min(blocks_dumped.keys()), bank))
for ptr in sorted(blocks_dumped.keys()):
    f.write('block_%4x:\n' % ptr)
    f.write('INCBIN "block%4x.bin"\n' % ptr)


f.close()
g.close()
