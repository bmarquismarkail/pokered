DisplayUsedMoveText:
	ld hl, UsedMoveText
	jp PrintText

UsedMoveText:
	text_far WLA_GLOBAL_ActorNameText
	text_asm

	ldh a, [lobyte(hWhoseTurn)]
	and a
	ld a, [wPlayerMoveNum]
	ld hl, wPlayerUsedMove
	jr z, UsedMoveText.playerTurn

	ld a, [wEnemyMoveNum]
	ld hl, wEnemyUsedMove

UsedMoveText.playerTurn
	ld [hl], a
	ld [wMoveGrammar], a
	call GetMoveGrammar
	ld a, [wMonIsDisobedient]
	and a
	ld hl, UsedMove2Text
	ret nz

	; check move grammar
	ld a, [wMoveGrammar]
	cp $3
	ld hl, UsedMove2Text
	ret c
	ld hl, UsedMove1Text
	ret

UsedMove1Text:
	text_far WLA_GLOBAL_UsedMove1Text
	text_asm
	jr UsedMoveText_CheckObedience

UsedMove2Text:
	text_far WLA_GLOBAL_UsedMove2Text
	text_asm
	; fall through

UsedMoveText_CheckObedience:
; check obedience
	ld a, [wMonIsDisobedient]
	and a
	jr z, UsedMoveText_CheckObedience.GetMoveNameText
; print "instead,"
	ld hl, UsedMoveText_CheckObedience.UsedInsteadText
	ret

UsedMoveText_CheckObedience.UsedInsteadText:
	text_far WLA_GLOBAL_UsedInsteadText
	text_asm
	; fall through

UsedMoveText_CheckObedience.GetMoveNameText:
	ld hl, MoveNameText
	ret

MoveNameText:
	text_far WLA_GLOBAL_MoveNameText
	text_asm
	ld hl, MoveNameText.endusedmovetexts
	ld a, [wMoveGrammar]
	add a
	push bc
	ld b, $0
	ld c, a
	add hl, bc
	pop bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ret

MoveNameText.endusedmovetexts:
; entries correspond to MoveGrammar sets
	.DW EndUsedMove1Text
	.DW EndUsedMove2Text
	.DW EndUsedMove3Text
	.DW EndUsedMove4Text
	.DW EndUsedMove5Text

EndUsedMove1Text:
	text_far WLA_GLOBAL_EndUsedMove1Text
	text_end

EndUsedMove2Text:
	text_far WLA_GLOBAL_EndUsedMove2Text
	text_end

EndUsedMove3Text:
	text_far WLA_GLOBAL_EndUsedMove3Text
	text_end

EndUsedMove4Text:
	text_far WLA_GLOBAL_EndUsedMove4Text
	text_end

EndUsedMove5Text:
	text_far WLA_GLOBAL_EndUsedMove5Text
	text_end

; This function is redundant in the English localization.
; In Japanese, it selects one of 5 distinct sentence structures.
; In English, all of these sentences have the exact same structure,
; so this serves no purpose.
GetMoveGrammar:
	push bc
	ld a, [wMoveGrammar] ; move ID
	ld c, a
	ld b, $0
	ld hl, MoveGrammar
GetMoveGrammar.loop
	ld a, [hli]
; end of table?
	cp -1
	jr z, GetMoveGrammar.end
; match?
	cp c
	jr z, GetMoveGrammar.end
; advance grammar type at 0
	and a
	jr nz, GetMoveGrammar.loop
; next grammar type
	inc b
	jr GetMoveGrammar.loop

GetMoveGrammar.end
; wMoveGrammar now contains move grammar
	ld a, b
	ld [wMoveGrammar], a
	pop bc
	ret

.INCLUDE "data/moves/grammar.asm"
