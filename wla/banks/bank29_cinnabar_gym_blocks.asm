; Authoritative Cinnabar Gym block map.
CinnabarGym_Blocks:
.INCBIN "maps/CinnabarGym.blk"
CinnabarGymBlocksEnd:
.ASSERT CinnabarGymBlocksEnd - CinnabarGym_Blocks == 90
