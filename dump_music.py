import struct

with open("baserom.gb", "rb") as f:
    rom = f.read()

# TODO Put this crap in a module or so?
def read_byte(address):
    return rom[address + 2*0x4000]

def read_word(address):
    off = address + 2*0x4000

    return struct.unpack("<H", rom[off: off + 2])[0]

music_data = {}
channel_pointers = [set(), set(), set(), set()]
song_pointers = set()
segment_pointers = set()
segment_channels = {}

def dump_music():
    # FIRST PASS
    # Collect all the pointers. Non-repeating songs stop as soon as one channel
    # reaches a 0x0000 segment. Because of this, not all segments have an end
    # byte, and not all channels are marked as either repeating or stopping.
    # This makes it hard to determine their length. So instead, we do a first
    # pass collecting all possible pointers (with some guaranteed overlap), and
    # dump everything in a second pass.

    song_pointers.update([read_word(0x663C + i*2) for i in range(19)])

    for song_pointer in song_pointers:
        ch_ptr = [0] * 4

        for i in range(4):
            ch_ptr[i] = read_word(song_pointer + 3 + 2*i)
            if ch_ptr[i] != 0x0000: # Unused
                channel_pointers[i].add(ch_ptr[i])

        # Find the length of the song in segments. Necessary to dump the other
        # channels, which aren't marked with a stop if they don't repeat.
        # Assumes that the marked channel is the longest in segments, which is
        # not necessarily true, but works for this ROM
        sentinel = -1
        song_length = 0
        while True:
            sentinel = read_word(ch_ptr[0] + song_length * 2)
            if sentinel == 0x0000: # End of song
                break
            if sentinel == 0xFFFF: # Repeat channel
                song_length = -1
                break

            song_length += 1

        # Follow channel pointers to enumerate segment pointers
        for i in range(4):
            if ch_ptr[i] == 0x0000: # Unused
                continue

            segments = 0
            while song_length == -1 or segments < song_length:
                segment_pointer = read_word(ch_ptr[i] + 2*segments)
                assert segment_pointer != 0x0000
                if segment_pointer == 0xFFFF:
                    break
                segment_pointers.add(segment_pointer)
                segment_channels[segment_pointer] = i
                segments += 1

    all_pointers = song_pointers | channel_pointers[0] | channel_pointers[1] | channel_pointers[2] | channel_pointers[3] | segment_pointers

    # End of music data
    all_pointers.add(0x7F08)

    all_pointers = sorted(all_pointers)

    # SECOND PASS
    # Dump everything, use the next pointer to know how long each section is
    for (ptr, next_ptr) in zip(all_pointers[:-1], all_pointers[1:]):
        if ptr in song_pointers:
            dump_song(ptr)
        elif ptr in channel_pointers[0]:
            dump_channel(1, ptr, next_ptr)
        elif ptr in channel_pointers[1]:
            dump_channel(2, ptr, next_ptr)
        elif ptr in channel_pointers[2]:
            dump_channel(3, ptr, next_ptr)
        elif ptr in channel_pointers[3]:
            dump_channel(4, ptr, next_ptr)
        elif ptr in segment_pointers:
            dump_segment(ptr, next_ptr)
        else:
            raise


    with open("music.asm", "w") as f:
        f.write('INCLUDE "music_macros.asm"\n')
        f.write('\n')
        f.write('SECTION "Music", ROMX[$6F98], BANK[3]\n\n')
        for key in sorted(music_data.keys()):
            f.write(music_data[key] + "\n")

def dump_song(song_pointer):
    song = "Song_%04X::\n" % song_pointer
    song += "\tdb $%02X\n" % read_byte(song_pointer)
    song += "\tdw $%04X\n" % read_word(song_pointer + 1)
    for i in range(4):
        ch = read_word(song_pointer + 3 + 2*i)
        if ch != 0x0000:
            song += "\tdw Channel%d_%04X\n" % (i+1, ch)
        else:
            song += "\tdw $0000\n"

    music_data[song_pointer] = song

def dump_channel(number, channel_pointer, next_ptr):
    data = "Channel%d_%0X::\n" % (number, channel_pointer)
    data += "\tdw "

    ptr = channel_pointer

    while ptr < next_ptr:
        segment_pointer = read_word(ptr)
        ptr += 2
        if segment_pointer == 0xFFFF:
            repeat_pointer = read_word(ptr)
            data += "$FFFF, $%04X\n" % repeat_pointer # TODO
            music_data[channel_pointer] = data
            return
        elif segment_pointer == 0x0000:
            data += "$0000\n"
            music_data[channel_pointer] = data
            return
        else:
            data += "Segment_%04X, " % segment_pointer

    data = data[:-2] # Remove ", " from the end
    data += "\n"
    music_data[channel_pointer] = data

NOTES = [None, "C_", "C_#", "D_", "D_#", "E_", "F_", "F_#", "G_", "G_#", "A_", "A_#", "B_"]

def dump_segment(segment_pointer, next_ptr):
    if segment_pointer in music_data.keys(): # Segments are reused
        return

    channel = segment_channels[segment_pointer]

    index = 0
    byte = -1

    data = "Segment_%04X::\n" % segment_pointer

    printing_notes = False

    while segment_pointer + index < next_ptr:
        byte = read_byte(segment_pointer + index)
        index += 1

        if byte != 0x00 and byte != 0x9D and byte & 0xF0 != 0xA0:
            assert byte < 0x92

            octave = (byte - 1) // 12 + 2
            note = byte - (octave - 2) * 12
            print(byte, octave,note)
            if not printing_notes:
                printing_notes = True
                if channel == 4 - 1:
                    assert byte in (1,6,11,16)
                    data += "\tNoise %d" % ((byte - 1) // 5)
                else:
                    data += "\tdb $%02X" % byte
                    #data += "\tNotes %s, %d" % (NOTES[note], octave)
            else:
                if channel == 4 - 1:
                    data += ", %d" % ((byte - 1) // 5)
                else:
                    data += ", $%02X" % byte
                    #data += ", %s, %d" % (NOTES[note], octave)

        else:
            if printing_notes:
                data += "\n"
                printing_notes = False

            if byte == 0x9D:
                b1 = read_byte(segment_pointer + index)
                index += 1
                b2 = read_byte(segment_pointer + index)
                index += 1
                b3 = read_byte(segment_pointer + index)
                index += 1

                data += "\tdb $9D, $%02X, $%02X, $%02X\n" % (b1, b2, b3)
            elif byte & 0xF0 == 0xA0:
                data += "\tdb $%02X\n" % byte
            elif byte == 0x00:
                data += "\tdb $00\n"

    music_data[segment_pointer] = data

if __name__ == "__main__":
    dump_music()
