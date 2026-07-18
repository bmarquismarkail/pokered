; Authoritative Fuchsia Gym block map.
FuchsiaGym_Blocks:
.INCBIN "maps/FuchsiaGym.blk"
FuchsiaGymBlocksEnd:
.ASSERT FuchsiaGymBlocksEnd - FuchsiaGym_Blocks == 45
