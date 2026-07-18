; Authoritative Cinnabar Lab 1F block map.
CinnabarLab_Blocks:
.INCBIN "maps/CinnabarLab.blk"
CinnabarLabBlocksEnd:
.ASSERT CinnabarLabBlocksEnd - CinnabarLab_Blocks == 36
