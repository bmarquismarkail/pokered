DoorTileIDPointers:
	dbw OVERWORLD,   DoorTileIDPointers.OverworldDoorTileIDs
	dbw FOREST,      DoorTileIDPointers.ForestDoorTileIDs
	dbw MART,        DoorTileIDPointers.MartDoorTileIDs
	dbw HOUSE,       DoorTileIDPointers.HouseDoorTileIDs
	dbw FOREST_GATE, DoorTileIDPointers.TilesetMuseumDoorTileIDs
	dbw MUSEUM,      DoorTileIDPointers.TilesetMuseumDoorTileIDs
	dbw GATE,        DoorTileIDPointers.TilesetMuseumDoorTileIDs
	dbw SHIP,        DoorTileIDPointers.ShipDoorTileIDs
	dbw LOBBY,       DoorTileIDPointers.LobbyDoorTileIDs
	dbw MANSION,     DoorTileIDPointers.MansionDoorTileIDs
	dbw LAB,         DoorTileIDPointers.LabDoorTileIDs
	dbw FACILITY,    DoorTileIDPointers.FacilityDoorTileIDs
	dbw PLATEAU,     DoorTileIDPointers.PlateauDoorTileIDs
	.DB -1 ; end

.MACRO door_tiles
	.REPT NARGS
		.DB \1 ; all args
		.SHIFT
	.ENDR
	.DB 0 ; end
.ENDM

DoorTileIDPointers.OverworldDoorTileIDs:
	door_tiles $1B, $58

DoorTileIDPointers.ForestDoorTileIDs:
	door_tiles $3a

DoorTileIDPointers.MartDoorTileIDs:
	door_tiles $5e

DoorTileIDPointers.HouseDoorTileIDs:
	door_tiles $54

DoorTileIDPointers.TilesetMuseumDoorTileIDs:
	door_tiles $3b

DoorTileIDPointers.ShipDoorTileIDs:
	door_tiles $1e

DoorTileIDPointers.LobbyDoorTileIDs:
	door_tiles $1c, $38, $1a

DoorTileIDPointers.MansionDoorTileIDs:
	door_tiles $1a, $1c, $53

DoorTileIDPointers.LabDoorTileIDs:
	door_tiles $34

DoorTileIDPointers.FacilityDoorTileIDs:
	door_tiles $43, $58, $1b

DoorTileIDPointers.PlateauDoorTileIDs:
	door_tiles $3b, $1b
