AbleToPlaySlotsCheck:
	ld a, [wSpritePlayerStateData1ImageIndex]
	and $8
	jr z, AbleToPlaySlotsCheck.done ; not able
	ld b, COIN_CASE
	predef GetQuantityOfItemInBag
	ld a, b
	and a
	ld b, (GameCornerCoinCaseText_id - TextPredefs) / 2 + 1
	jr z, AbleToPlaySlotsCheck.printCoinCaseRequired
	ld hl, wPlayerCoins
	ld a, [hli]
	or [hl]
	jr nz, AbleToPlaySlotsCheck.done ; able to play
	ld b, (GameCornerNoCoinsText_id - TextPredefs) / 2 + 1
AbleToPlaySlotsCheck.printCoinCaseRequired
	call EnableAutoTextBoxDrawing
	ld a, b
	call PrintPredefTextID
	xor a
AbleToPlaySlotsCheck.done
	ld [wCanPlaySlots], a
	ret

GameCornerCoinCaseText:
	text_far WLA_GLOBAL_GameCornerCoinCaseText
	text_end

GameCornerNoCoinsText:
	text_far WLA_GLOBAL_GameCornerNoCoinsText
	text_end
