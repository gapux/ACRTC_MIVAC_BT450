V E R Y   S L O W   P R O G R E S S

This is an attempt to use the ACRTC (Hitachi HD63484) with my home built V40 machine (suspended.)


ACRTCGLUE_20230909.PLD　:　WinCUPL source code for ATF22V10C. It handles CS#, RD#, WR#, DTACK#, DACK#, reset. It will trigger the 8-bit data bus mode on reset, will give wait signal to the processor according to the DTACK# signal. 

hd63484small_450 - Schematic.pdf : Color (16 out of 4096) Video board ACRTC, MIVAC, BT450, etc. Not fully meet VGA video timings.

hd63484small_modular - Schematic.pdf : Multi-purpose version schematic without address decoder, pld, color palette

acrtctest.asm : Test code for the NEC V40 (written in Intel 8086 instructions, no V30 specific instructions included)
