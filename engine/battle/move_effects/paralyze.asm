ParalyzeEffect_:
	ld hl, wEnemyMonStatus
	ld de, wPlayerMoveType
	ldh a, [lobyte(hWhoseTurn)]
	and a
	jp z, ParalyzeEffect_.next
	ld hl, wBattleMonStatus
	ld de, wEnemyMoveType
ParalyzeEffect_.next
	ld a, [hl]
	and a ; does the target already have a status ailment?
	jr nz, ParalyzeEffect_.didntAffect
; check if the target is immune due to types
	ld a, [de]
	cp ELECTRIC
	jr nz, ParalyzeEffect_.hitTest
	ld b, h
	ld c, l
	inc bc
	ld a, [bc]
	cp GROUND
	jr z, ParalyzeEffect_.doesntAffect
	inc bc
	ld a, [bc]
	cp GROUND
	jr z, ParalyzeEffect_.doesntAffect
ParalyzeEffect_.hitTest
	push hl
	callfar MoveHitTest
	pop hl
	ld a, [wMoveMissed]
	and a
	jr nz, ParalyzeEffect_.didntAffect
	set PAR, [hl]
	callfar QuarterSpeedDueToParalysis
	ld c, 30
	call DelayFrames
	callfar PlayCurrentMoveAnimation
	jpfar PrintMayNotAttackText
ParalyzeEffect_.didntAffect
	ld c, 50
	call DelayFrames
	jpfar PrintDidntAffectText
ParalyzeEffect_.doesntAffect
	ld c, 50
	call DelayFrames
	jpfar PrintDoesntAffectText
