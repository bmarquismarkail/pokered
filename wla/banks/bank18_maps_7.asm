; Native WLA-DX form of RGBDS section "Maps 7".
; These two neighboring Maps 8 symbols remain at fixed generated addresses until
; that section is structured.
.DEFINE Route7_Script $4152
.DEFINE Route7_TextPointers $4155

Route7_h:
	.DB $00, $09, $0a ; OVERWORLD, height, width
	.DW Route7_Blocks, Route7_TextPointers, Route7_Script
	.DB $03 ; west and east connections
	; West connection: Celadon City, offset -4.
	.DB $06
	.DW $410e, $c6e8
	.DB $0f, $19, $08, $31
	.DW $c720
	; East connection: Saffron City, offset -4.
	.DB $0a
	.DW $4aac, $c6f5
	.DB $0f, $14, $08, $00
	.DW $c703
	.DW Route7_Object

Route7_Object:
	.DB $0f ; border block
	.DB $05 ; warp count
	.DB $09, $12, $02, $4c ; (18, 9), ROUTE_7_GATE warp 3
	.DB $0a, $12, $03, $4c ; (18, 10), ROUTE_7_GATE warp 4
	.DB $09, $0b, $00, $4c ; (11, 9), ROUTE_7_GATE warp 1
	.DB $0a, $0b, $01, $4c ; (11, 10), ROUTE_7_GATE warp 2
	.DB $0d, $05, $00, $4d ; (5, 13), UNDERGROUND_PATH_ROUTE_7 warp 1
	.DB $01 ; background event count
	.DB $0d, $03, $01 ; underground-path sign at (3, 13)
	.DB $00 ; object event count
	.DW $c742
	.DB $09, $12
	.DW $c752
	.DB $0a, $12
	.DW $c73e
	.DB $09, $0b
	.DW $c74e
	.DB $0a, $0b
	.DW $c75b
	.DB $0d, $05

Route7_Blocks:
	.INCBIN "maps/Route7.blk"

CeladonPokecenter_Blocks:
RockTunnelPokecenter_Blocks:
MtMoonPokecenter_Blocks:
	.INCBIN "maps/MtMoonPokecenter.blk"

Route18Gate1F_Blocks:
Route15Gate1F_Blocks:
Route11Gate1F_Blocks:
	.INCBIN "maps/Route11Gate1F.blk"

Route18Gate2F_Blocks:
Route16Gate2F_Blocks:
Route15Gate2F_Blocks:
Route12Gate2F_Blocks:
Route11Gate2F_Blocks:
	.INCBIN "maps/Route11Gate2F.blk"
Maps7End:
