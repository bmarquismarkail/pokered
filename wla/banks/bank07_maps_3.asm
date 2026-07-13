; Native WLA-DX form of RGBDS section "Maps 3".
CinnabarIsland_h:
	.DB $00, $09, $0a
	.DW CinnabarIsland_Blocks, $4a81, $4a19
	.DB $09 ; north and east connections
	.DB $20
	.DW $5211, $c6eb
	.DB $0a, $0a, $59, $00
	.DW $c9b9
	.DB $1f
	.DW $417d, $c725
	.DB $09, $32, $00, $00
	.DW $c721
	.DW CinnabarIsland_Object

CinnabarIsland_Object:
	.DB $43, $05
	.DB $03, $06, $01, $a5
	.DB $03, $12, $00, $a6
	.DB $09, $06, $00, $a7
	.DB $0b, $0b, $00, $ab
	.DB $0b, $0f, $00, $ac
	.DB $05
	.DB $05, $09, $03
	.DB $0b, $10, $04
	.DB $0b, $0c, $05
	.DB $0b, $09, $06
	.DB $03, $0d, $07
	.DB $02
	.DB $0d, $09, $10, $fe, $02, $01
	.DB $0b, $0a, $12, $ff, $ff, $02
	.DW $c70c
	.DB $03, $06
	.DW $c712
	.DB $03, $12
	.DW $c73c
	.DB $09, $06
	.DW $c74e
	.DB $0b, $0b
	.DW $c750
	.DB $0b, $0f

CinnabarIsland_Blocks:
	.INCBIN "maps/CinnabarIsland.blk"

Route1_h:
	.DB $00, $12, $0a
	.DW Route1_Blocks, $4ab2, $4aaf
	.DB $0c ; north and south connections
	.DB $01
	.DW $451a, $c6e8
	.DB $10, $14, $23, $0a
	.DW $c8bd
	.DB $00
	.DW $42fd, $c83b
	.DB $0a, $0a, $00, $00
	.DW $c6f9
	.DW Route1_Object

Route1_Object:
	.DB $0b, $00, $01
	.DB $1b, $09, $03
	.DB $02
	.DB $04, $1c, $09, $fe, $01, $01
	.DB $04, $11, $13, $fe, $02, $02
	.DW $c712
	.DB $07, $02

Route1_Blocks:
	.INCBIN "maps/Route1.blk"
UndergroundPathRoute8_Blocks:
	.INCBIN "maps/UndergroundPathRoute8.blk"
OaksLab_Blocks:
	.INCBIN "maps/OaksLab.blk"
MrPsychicsHouse_Blocks:
NameRatersHouse_Blocks:
MrFujisHouse_Blocks:
Route16FlyHouse_Blocks:
Route2TradeHouse_Blocks:
SaffronPidgeyHouse_Blocks:
VermilionPidgeyHouse_Blocks:
LavenderCuboneHouse_Blocks:
CeruleanTradeHouse_Blocks:
PewterNidoranHouse_Blocks:
PewterSpeechHouse_Blocks:
ViridianNicknameHouse_Blocks:
	.INCBIN "maps/ViridianNicknameHouse.blk"
CeladonMansionRoofHouse_Blocks:
ViridianSchoolHouse_Blocks:
	.INCBIN "maps/ViridianSchoolHouse.blk"
CeruleanTrashedHouse_Blocks:
	.INCBIN "maps/CeruleanTrashedHouse.blk"
DiglettsCaveRoute11_Blocks:
DiglettsCaveRoute2_Blocks:
	.INCBIN "maps/DiglettsCaveRoute2.blk"
Maps3End:
