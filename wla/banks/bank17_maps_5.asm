; Native WLA-DX form of RGBDS section "Maps 5".
LavenderTown_h:
	.DB $00, $09, $0a ; OVERWORLD, height, width
	.DW LavenderTown_Blocks, LavenderTown_TextPointers, LavenderTown_Script
	.DB $0e ; north, south, and west connections
	; North connection: Route 10, offset 0.
	.DB $15
	.DW $44a0, $c6eb
	.DB $0a, $0a, $47, $00
	.DW $c929
	; South connection: Route 12, offset 0.
	.DB $17
	.DW $4710, $c7ab
	.DB $0a, $0a, $00, $00
	.DW $c6f9
	; West connection: Route 8, offset 0.
	.DB $13
	.DW $41e1, $c718
	.DB $09, $1e, $00, $3b
	.DW $c72a
	.DW LavenderTown_Object

LavenderTown_Object:
	.DB $2c ; border block
	.DB $06 ; warp count
	.DB $05, $03, $00, $8d ; Lavender Pokecenter
	.DB $05, $0e, $00, $8e ; Pokemon Tower 1F
	.DB $09, $07, $00, $95 ; Mr. Fuji's house
	.DB $0d, $0f, $00, $96 ; Lavender Mart
	.DB $0d, $03, $00, $97 ; Lavender Cubone house
	.DB $0d, $07, $00, $e5 ; Name Rater's house
	.DB $06 ; background event count
	.DB $09, $0b, $04
	.DB $03, $09, $05
	.DB $0d, $10, $06
	.DB $05, $04, $07
	.DB $09, $05, $08
	.DB $07, $11, $09
	.DB $03 ; object event count
	.DB $08, $0d, $13, $fe, $00, $01
	.DB $07, $0e, $0d, $ff, $ff, $02
	.DB $0c, $0b, $0c, $fe, $02, $03
	.DW $c71a
	.DB $05, $03
	.DW $c720
	.DB $05, $0e
	.DW $c73c
	.DB $09, $07
	.DW $c760
	.DB $0d, $0f
	.DW $c75a
	.DB $0d, $03
	.DW $c75c
	.DB $0d, $07

LavenderTown_Blocks:
	.INCBIN "maps/LavenderTown.blk"

ViridianPokecenter_Blocks:
	.INCBIN "maps/ViridianPokecenter.blk"

SafariZoneCenterRestHouse_Blocks:
SafariZoneWestRestHouse_Blocks:
SafariZoneEastRestHouse_Blocks:
SafariZoneNorthRestHouse_Blocks:
	.INCBIN "maps/SafariZoneCenterRestHouse.blk"

LavenderTown_Script:
	JP EnableAutoTextBoxDrawing

LavenderTown_TextPointers:
	.DW LavenderTownLittleGirlText
	.DW LavenderTownCooltrainerMText
	.DW LavenderTownSuperNerdText
	.DW LavenderTownSignText
	.DW LavenderTownSilphScopeSignText
	.DW $24ea ; MartSignText
	.DW $24ef ; PokeCenterSignText
	.DW LavenderTownPokemonHouseSignText
	.DW LavenderTownPokemonTowerSignText

LavenderTownLittleGirlText:
	.DB $08 ; text_asm
	LD HL, LavenderTownLittleGirlText.DoYouBelieveInGhostsText
	CALL PrintText
	CALL $35ec ; YesNoChoice
	LD A, (wCurrentMenuItem)
	AND A
	LD HL, LavenderTownLittleGirlText.HaHaGuessNotText
	JR NZ, LavenderTownLittleGirlText.got_text
	LD HL, LavenderTownLittleGirlText.SoThereAreBelieversText
LavenderTownLittleGirlText.got_text:
	CALL PrintText
	JP $24d7 ; TextScriptEnd

LavenderTownLittleGirlText.DoYouBelieveInGhostsText:
	.DB $17
	.DW $5482
	.DB $29, $50
LavenderTownLittleGirlText.SoThereAreBelieversText:
	.DB $17
	.DW $549d
	.DB $29, $50
LavenderTownLittleGirlText.HaHaGuessNotText:
	.DB $17
	.DW $54c0
	.DB $29, $50

LavenderTownCooltrainerMText:
	.DB $17
	.DW $5506
	.DB $29, $50
LavenderTownSuperNerdText:
	.DB $17
	.DW $555f
	.DB $29, $50
LavenderTownSignText:
	.DB $17
	.DW $55bb
	.DB $29, $50
LavenderTownSilphScopeSignText:
	.DB $17
	.DW $55e0
	.DB $29, $50
LavenderTownPokemonHouseSignText:
	.DB $17
	.DW $561d
	.DB $29, $50
LavenderTownPokemonTowerSignText:
	.DB $17
	.DW $563c
	.DB $29, $50
Maps5End:
