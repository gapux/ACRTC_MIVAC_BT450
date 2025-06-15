V E R Y   S L O W   P R O G R E S S

This is an attempt to use ACRTC (HD63484) with my home built V40 machine (suspended.)


ACRTCGLUE_20230909.PLD　:　WinCUPL source code for ATF22V10C. It handles CS#, RD#, WR#, DTACK#, DACK#, reset. It will trigger the 8-bit data bus mode on reset, will give wait signal to the processor according to the DTACK# signal. 

hd63484small_modular - Schematic.pdf : Board schematic

acrtctest.asm : Test code for the NEC V40 (8086 instructions)
