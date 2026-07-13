; Native WLA-DX form of the Trade Center and Colosseum maps.
.DEFINE SetSpriteFacingDirection $34ae
TradeCenter_h:
	.DB $15, $04, $05
	.DW TradeCenter_Blocks, TradeCenter_TextPointers, TradeCenter_Script
	.DB $00
	.DW TradeCenter_Object
TradeCenter_Script:
	CALL EnableAutoTextBoxDrawing
	LDH A, ($aa)
	CP $02
	LD A, $08
	JR Z, TradeCenterScriptNext
	LD A, $0c
TradeCenterScriptNext:
	LDH ($8d), A
	LD A, $01
	LDH ($8c), A
	CALL SetSpriteFacingDirection
	LD HL, wStatusFlags3
	BIT 0, (HL)
	SET 0, (HL)
	RET NZ
	LD HL, wSprite01StateData2MapY
	LD A, 8
	LD (HL+), A
	LD A, 10
	LD (HL), A
	LD A, $08
	LD (wSprite01StateData1FacingDirection), A
	LDH A, ($aa)
	CP $02
	RET Z
	LD A, 7
	LD (wSprite01StateData2MapX), A
	LD A, $0c
	LD (wSprite01StateData1FacingDirection), A
	RET
TradeCenter_TextPointers:
	.DW TradeCenterOpponentText
TradeCenterOpponentText:
	.DB $17
	.DW $4b01
	.DB $25, $50
TradeCenter_Object:
	.DB $0e, $00, $00, $01, $01, $06, $06, $ff, $00, $01
TradeCenter_Blocks:
	.INCBIN "maps/TradeCenter.blk"
Colosseum_h:
	.DB $15, $04, $05
	.DW Colosseum_Blocks, Colosseum_TextPointers, Colosseum_Script
	.DB $00
	.DW Colosseum_Object
Colosseum_Script:
	JP TradeCenter_Script
Colosseum_TextPointers:
	.DW ColosseumOpponentText
ColosseumOpponentText:
	.DB $17
	.DW $4b04
	.DB $25, $50
Colosseum_Object:
	.DB $0e, $00, $00, $01, $01, $06, $06, $ff, $00, $01
Colosseum_Blocks:
	.INCBIN "maps/Colosseum.blk"
Maps9End:
