import png

def rom_offset(bank, address):
    return address + (bank - 1) * 0x4000

def copy_tile(tile_2bpp, pxmap, x, y):
    pixels = tile_to_pixels(tile_2bpp)

    for py in range(8):
        for px in range(8):
            pxmap[y+py][x+px] = pixels[py*8 + px]


# Decode a 2bpp encoded tile to a list of 8*8 pixels
def tile_to_pixels(tile):
    assert len(tile) == 16

    pixels = []

    for row in range(8):
        hi = tile[row*2 + 1]
        lo = tile[row*2]

        for col in reversed(range(8)):
            pixels += [3 - (((hi*2) >> col & 0b10) + (lo >> col & 0b01))]

    return pixels

def convert_2bpp_to_png(name, image, tile_width):
    assert len(image) % 16 == 0

    tile_count = len(image) // 16
    # Round up
    tile_height = (tile_count + tile_width - 1) // tile_width

    width = tile_width * 8
    height = tile_height * 8

    pixelmap = [[0 for _ in range(width)] for _ in range(height)]

    for i in range(tile_count):
        x = (i % tile_width) * 8
        y = (i // tile_width) * 8
        copy_tile(image[i*16: i*16 + 16], pixelmap, x, y)


    f = open("gfx/%s.png" % name, "wb")
    w = png.Writer(tile_width * 8, tile_height * 8, greyscale=True, bitdepth=2)
    w.write(f, pixelmap)



def dump_tiles(name, address, bank, num_tiles):
    off = rom_offset(bank, address)

    convert_2bpp_to_png(name, rom[off:off + num_tiles*16], 16)

if __name__ == "__main__":
    with open("baserom.gb", "rb") as f:
        rom = f.read()

    # These addresses come from Call_5E7, GameState_08.enemyTileOffset,
    # .backdropTileOffset and GameState_OE
    dump_tiles("commonTiles1",     0x4032, 2, 160)
    dump_tiles("enemiesWorld1",    0x4A32, 2, 61)
    dump_tiles("commonTiles2",     0x4E02, 2, 84)
    dump_tiles("backgroundWorld1", 0x5342, 2, 63)
    dump_tiles("commonTiles3",     0x5732, 2, 16)
    dump_tiles("menuTiles1",       0x791A, 2, 80)
    dump_tiles("menuTiles2",       0x7E1A, 2, 23)

    dump_tiles("enemiesWorld2",    0x4032, 1, 61)
    dump_tiles("backgroundWorld2", 0x4402, 1, 63)
    dump_tiles("enemiesWorld4",    0x47F2, 1, 61)
    dump_tiles("backgroundWorld4", 0x4BC2, 1, 63)

    dump_tiles("enemiesWorld3",    0x4032, 3, 61)
    dump_tiles("backgroundWorld3", 0x4402, 3, 63)
