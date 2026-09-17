AerodactylFossil:
	ld a, FOSSIL_AERODACTYL
	ld [wCurPartySpecies], a
	call DisplayMonFrontSpriteInBox
	call EnableAutoTextBoxDrawing
	tx_pre AerodactylFossilText
	ret

AerodactylFossilText:
	text_far WLA_GLOBAL_AerodactylFossilText
	text_end

KabutopsFossil:
	ld a, FOSSIL_KABUTOPS
	ld [wCurPartySpecies], a
	call DisplayMonFrontSpriteInBox
	call EnableAutoTextBoxDrawing
	tx_pre KabutopsFossilText
	ret

KabutopsFossilText:
	text_far WLA_GLOBAL_KabutopsFossilText
	text_end

DisplayMonFrontSpriteInBox:
; Displays a pokemon's front sprite in a pop-up window.
	ld a, 1
	ldh [lobyte(hAutoBGTransferEnabled)], a
	call Delay3
	xor a
	ldh [lobyte(hWY)], a
	call SaveScreenTilesToBuffer1
	ld a, MON_SPRITE_POPUP
	ld [wTextBoxID], a
	call DisplayTextBoxID
	call UpdateSprites
	ld a, [wCurPartySpecies]
	ld [wCurSpecies], a
	call GetMonHeader
	ld de, vChars1 + TILE_SIZE * $31
	call LoadMonFrontSprite
	ld a, $80
	ldh [lobyte(hStartTileID)], a
	hlcoord 10, 11
	predef AnimateSendingOutMon
	call WaitForTextScrollButtonPress
	call LoadScreenTilesFromBuffer1
	call Delay3
	ld a, $90
	ldh [lobyte(hWY)], a
	ret
