; Native WLA-DX form of RGBDS section "Maps 15".
SaffronMart_Blocks:
LavenderMart_Blocks:
CeruleanMart_Blocks:
VermilionMart_Blocks:
	.INCBIN "maps/VermilionMart.blk"

CopycatsHouse2F_Blocks:
RedsHouse2F_Blocks:
	.INCBIN "maps/RedsHouse2F.blk"

Museum1F_Blocks:
	.INCBIN "maps/Museum1F.blk"

Museum2F_Blocks:
	.INCBIN "maps/Museum2F.blk"

SaffronPokecenter_Blocks:
VermilionPokecenter_Blocks:
LavenderPokecenter_Blocks:
PewterPokecenter_Blocks:
	.INCBIN "maps/PewterPokecenter.blk"

UndergroundPathRoute7_Blocks:
UndergroundPathRoute7Copy_Blocks:
UndergroundPathRoute6_Blocks:
UndergroundPathRoute5_Blocks:
	.INCBIN "maps/UndergroundPathRoute5.blk"

Route2Gate_Blocks:
ViridianForestSouthGate_Blocks:
ViridianForestNorthGate_Blocks:
	.INCBIN "maps/ViridianForestNorthGate.blk"

RedsHouse2F_h:
	.DB $04, $04, $04 ; REDS_HOUSE_2, height, width
	.DW RedsHouse2F_Blocks, RedsHouse2F_TextPointers, RedsHouse2F_Script
	.DB $00 ; no connections
	.DW RedsHouse2F_Object

RedsHouse2F_Script:
	CALL EnableAutoTextBoxDrawing
	LD HL, RedsHouse2F_ScriptPointers
	LD A, (wRedsHouse2FCurScript)
	JP CallFunctionInTable

RedsHouse2F_ScriptPointers:
	.DW RedsHouse2FDefaultScript
	.DW RedsHouse2FNoopScript

RedsHouse2FDefaultScript:
	XOR A
	LDH ($b4), A ; hJoyHeld
	LD A, $08 ; PLAYER_DIR_UP
	LD (wPlayerMovingDirection), A
	LD A, $01 ; SCRIPT_REDSHOUSE2F_NOOP
	LD (wRedsHouse2FCurScript), A
	RET

RedsHouse2FNoopScript:
	RET

RedsHouse2F_TextPointers:
	.DB $50 ; text_end (unused)

RedsHouse2F_Object:
	.DB $0a ; border block
	.DB $01 ; warp count
	.DB $01, $07, $02, $25 ; (7, 1), REDS_HOUSE_1F warp 3
	.DB $00 ; background event count
	.DB $00 ; object event count
	.DB $f6, $c6, $01, $07 ; warps-to entry
Maps15End:
