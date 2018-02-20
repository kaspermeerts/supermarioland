.PHONY: all clean check
.SUFFIXES:
.SUFFIXES: .asm .o .gb

objects := mario.o

all: mario.gb check

clean:
	rm -f mario.gb $(objects)

# Quietly check the hash of the newly built ROM to make sure any disassembled
# code matches the original
check: mario.gb
	@sha1sum -c --quiet rom.sha1

%.o: %.asm
	rgbasm -o $@ $<

mario.gb: $(objects)
	rgblink -d -n $*.sym -m $*.map -o $@ $^
	rgbfix -v $@
