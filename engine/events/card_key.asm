PrintCardKeyText:
	ld hl, SilphCoMapList
	ld a, [wCurMap]
	ld b, a
PrintCardKeyText.silphCoMapListLoop
	ld a, [hli]
	cp -1
	ret z
	cp b
	jr nz, PrintCardKeyText.silphCoMapListLoop
	predef GetTileAndCoordsInFrontOfPlayer
	ld a, [wTileInFrontOfPlayer]
	cp $18
	jr z, PrintCardKeyText.cardKeyDoorInFrontOfPlayer
	cp $24
	jr z, PrintCardKeyText.cardKeyDoorInFrontOfPlayer
	ld b, a
	ld a, [wCurMap]
	cp SILPH_CO_11F
	ret nz
	ld a, b
	cp $5e
	ret nz
PrintCardKeyText.cardKeyDoorInFrontOfPlayer
	ld b, CARD_KEY
	call IsItemInBag
	jr z, PrintCardKeyText.noCardKey
	call GetCoordsInFrontOfPlayer
	push de
	tx_pre_id CardKeySuccessText
	ldh [lobyte(hTextID)], a
	call PrintPredefTextID
	pop de
	srl d
	ld a, d
	ld b, a
	ld [wCardKeyDoorY], a
	srl e
	ld a, e
	ld c, a
	ld [wCardKeyDoorX], a
	ld a, [wCurMap]
	cp SILPH_CO_11F
	jr nz, PrintCardKeyText.notSilphCo11F
	ld a, $3
	jr PrintCardKeyText.replaceCardKeyDoorTileBlock
PrintCardKeyText.notSilphCo11F
	ld a, $e
PrintCardKeyText.replaceCardKeyDoorTileBlock
	ld [wNewTileBlockID], a
	predef ReplaceTileBlock
	ld hl, wCurrentMapScriptFlags
	set BIT_CUR_MAP_LOADED_1, [hl]
	ld a, SFX_GO_INSIDE
	jp PlaySound
PrintCardKeyText.noCardKey
	tx_pre_id CardKeyFailText
	ldh [lobyte(hTextID)], a
	jp PrintPredefTextID

.INCLUDE "data/events/card_key_maps.asm"

CardKeySuccessText:
	text_far WLA_GLOBAL_CardKeySuccessText1
	sound_get_item_1
	text_far WLA_GLOBAL_CardKeySuccessText2
	text_end

CardKeyFailText:
	text_far WLA_GLOBAL_CardKeyFailText
	text_end

; d = Y
; e = X
GetCoordsInFrontOfPlayer:
	ld a, [wYCoord]
	ld d, a
	ld a, [wXCoord]
	ld e, a
	ld a, [wSpritePlayerStateData1FacingDirection]
	and a
	jr nz, GetCoordsInFrontOfPlayer.notFacingDown
; facing down
	inc d
	ret
GetCoordsInFrontOfPlayer.notFacingDown
	cp SPRITE_FACING_UP
	jr nz, GetCoordsInFrontOfPlayer.notFacingUp
; facing up
	dec d
	ret
GetCoordsInFrontOfPlayer.notFacingUp
	cp SPRITE_FACING_LEFT
	jr nz, GetCoordsInFrontOfPlayer.notFacingLeft
; facing left
	dec e
	ret
GetCoordsInFrontOfPlayer.notFacingLeft
; facing right
	inc e
	ret
