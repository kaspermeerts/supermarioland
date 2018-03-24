# Super Mario Land Disassembly

Disassembly of the first Game Boy game I ever played

This repository builds Super Mario Land (World) (Rev A) with SHA1 checksum `418203621b887caa090215d97e3f509b79affd3e`

As of now it requires a copy of the original ROM named "baserom.gb" to be placed in the repository, to fill in sections which have not been disassembled yet. The goal is to make this step obsolete.

## Requirements

* RGBDS 0.3.5
* pypng

## Coverage

A quick and dirty Python script `coverage.py` is provided to estimate how much of the ROM has been disassembled

* Bank 0: three quarters
* Bank 1: a quarter
* Bank 2: half
* Bank 3: an eighth
* High RAM: 35 out of 127 bytes identified

