; Authoritative Viridian Gym block map.
ViridianGym_Blocks:
.INCBIN "maps/ViridianGym.blk"
ViridianGymBlocksEnd:
.ASSERT ViridianGymBlocksEnd - ViridianGym_Blocks == 90
