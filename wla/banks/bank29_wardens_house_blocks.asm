; Authoritative Warden's House block map.
WardensHouse_Blocks:
.INCBIN "maps/WardensHouse.blk"
WardensHouseBlocksEnd:
.ASSERT WardensHouseBlocksEnd - WardensHouse_Blocks == 20
