.PHONY: all clean check
.SUFFIXES:
.SUFFIXES: .asm .o .gb

objects := bank0.o bank1.o bank2.o bank3.o

all: mario.gb check

clean:
	rm -f mario.gb $(objects)

# Quietly check the hash of the newly built ROM to make sure any disassembled
# code matches the original
check: mario.gb
	@sha1sum -c --quiet rom.sha1

# Export everything for the moment, to make debugging easier
%.o: %.asm
	@echo " ASM	$@"
	@rgbasm -E -h -o $@ $<

mario.gb: $(objects)
	@echo " LINK	$@"
	@rgblink -d -n $*.sym -m $*.map -o $@ $^
	@rgbfix -v $@
