; Structured replacement for engine/battle/link_battle_versus_text.asm.
+; display "[player] VS [enemy]" text box with pokeballs representing their parties next to the names
DisplayLinkBattleVersusTextBox:
	call LoadTextBoxTilePatterns
	ld hl, wTileMap + (4 * 20) + 3
	ld b, 7
	ld c, 12
	call TextBoxBorder
	ld hl, wTileMap + (5 * 20) + 4
	ld de, wPlayerName
	call PlaceString
	ld hl, wTileMap + (10 * 20) + 4
	ld de, wLinkEnemyTrainerName
	call PlaceString
; place bold "VS" tiles between the names
	ld hl, wTileMap + (8 * 20) + 9
	ld a, $69
	ld (HL+), a
	.DB $36, $6a
	xor a
	ld (wUpdateSpritesEnabled), a
	ld hl, $6948
	ld b, $0e
	call Bankswitch
	ld c, 150
	jp DelayFrames
LinkVersusEnd:
