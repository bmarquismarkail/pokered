WarpTileIDPointers:
	table_width 2
	.DW WarpTileIDPointers.OverworldWarpTileIDs
	.DW WarpTileIDPointers.RedsHouse1WarpTileIDs
	.DW WarpTileIDPointers.MartWarpTileIDs
	.DW WarpTileIDPointers.ForestWarpTileIDs
	.DW WarpTileIDPointers.RedsHouse2WarpTileIDs
	.DW WarpTileIDPointers.DojoWarpTileIDs
	.DW WarpTileIDPointers.PokecenterWarpTileIDs
	.DW WarpTileIDPointers.GymWarpTileIDs
	.DW WarpTileIDPointers.HouseWarpTileIDs
	.DW WarpTileIDPointers.ForestGateWarpTileIDs
	.DW WarpTileIDPointers.MuseumWarpTileIDs
	.DW WarpTileIDPointers.UndergroundWarpTileIDs
	.DW WarpTileIDPointers.GateWarpTileIDs
	.DW WarpTileIDPointers.ShipWarpTileIDs
	.DW WarpTileIDPointers.ShipPortWarpTileIDs
	.DW WarpTileIDPointers.CemeteryWarpTileIDs
	.DW WarpTileIDPointers.InteriorWarpTileIDs
	.DW WarpTileIDPointers.CavernWarpTileIDs
	.DW WarpTileIDPointers.LobbyWarpTileIDs
	.DW WarpTileIDPointers.MansionWarpTileIDs
	.DW WarpTileIDPointers.LabWarpTileIDs
	.DW WarpTileIDPointers.ClubWarpTileIDs
	.DW WarpTileIDPointers.FacilityWarpTileIDs
	.DW WarpTileIDPointers.PlateauWarpTileIDs
	assert_table_length NUM_TILESETS

.MACRO warp_tiles
	.REPT NARGS
		.DB \1 ; all args
		.SHIFT
	.ENDR
	.DB -1 ; end
.ENDM

WarpTileIDPointers.OverworldWarpTileIDs:
	warp_tiles $1B, $58

WarpTileIDPointers.ForestGateWarpTileIDs:
WarpTileIDPointers.MuseumWarpTileIDs:
WarpTileIDPointers.GateWarpTileIDs:
	.DB $3B
	; fallthrough
WarpTileIDPointers.RedsHouse1WarpTileIDs:
WarpTileIDPointers.RedsHouse2WarpTileIDs:
	warp_tiles $1A, $1C

WarpTileIDPointers.MartWarpTileIDs:
WarpTileIDPointers.PokecenterWarpTileIDs:
	warp_tiles $5E

WarpTileIDPointers.ForestWarpTileIDs:
	warp_tiles $5A, $5C, $3A

WarpTileIDPointers.DojoWarpTileIDs:
WarpTileIDPointers.GymWarpTileIDs:
	warp_tiles $4A

WarpTileIDPointers.HouseWarpTileIDs:
	warp_tiles $54, $5C, $32

WarpTileIDPointers.ShipWarpTileIDs:
	warp_tiles $37, $39, $1E, $4A

WarpTileIDPointers.InteriorWarpTileIDs:
	warp_tiles $15, $55, $04

WarpTileIDPointers.CavernWarpTileIDs:
	warp_tiles $18, $1A, $22

WarpTileIDPointers.LobbyWarpTileIDs:
	warp_tiles $1A, $1C, $38

WarpTileIDPointers.MansionWarpTileIDs:
	warp_tiles $1A, $1C, $53

WarpTileIDPointers.LabWarpTileIDs:
	warp_tiles $34

WarpTileIDPointers.FacilityWarpTileIDs:
	.DB $43, $58, $20
	; fallthrough
WarpTileIDPointers.CemeteryWarpTileIDs:
	.DB $1B
	; fallthrough
WarpTileIDPointers.UndergroundWarpTileIDs:
	warp_tiles $13

WarpTileIDPointers.PlateauWarpTileIDs:
	.DB $1B, $3B
	; fallthrough
WarpTileIDPointers.ShipPortWarpTileIDs:
WarpTileIDPointers.ClubWarpTileIDs:
	warp_tiles ; end
