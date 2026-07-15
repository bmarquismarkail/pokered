; Authoritative Pewter Gym block map.
PewterGym_Blocks:
.INCBIN "maps/PewterGym.blk"
PewterGymBlocksEnd:
.ASSERT PewterGymBlocksEnd - PewterGym_Blocks == 35
