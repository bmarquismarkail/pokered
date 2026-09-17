TitleScroll_WaitBall:
; Wait around for the TitleBall animation to play out.
; hi: speed
; lo: duration
	.DB $05, $05, 0

TitleScroll_In:
; Scroll a TitleMon in from the right.
; hi: speed
; lo: duration
	.DB $a2, $94, $84, $63, $52, $31, $11, 0

TitleScroll_Out:
; Scroll a TitleMon out to the left.
; hi: speed
; lo: duration
	.DB $12, $22, $32, $42, $52, $62, $83, $93, 0

TitleScroll:
	ld a, d

	ld bc, TitleScroll_In
	ld d, $88
	ld e, 0 ; don't animate titleball

	and a
	jr nz, TitleScroll.ok

	ld bc, TitleScroll_Out
	ld d, $00
	ld e, 0 ; don't animate titleball
TitleScroll.ok

_TitleScroll:
WLA_GLOBAL_TitleScroll:
	ld a, [bc]
	and a
	ret z

	inc bc
	push bc

	ld b, a
	and $f
	ld c, a
	ld a, b
	and $f0
	swap a
	ld b, a

_TitleScroll.loop:
WLA_GLOBAL_TitleScroll__loop:
	ld h, d
	ld l, $48
	call WLA_GLOBAL_TitleScroll__ScrollBetween

	ld h, $00
	ld l, $88
	call WLA_GLOBAL_TitleScroll__ScrollBetween

	ld a, d
	add b
	ld d, a

	call GetTitleBallY
	dec c
	jr nz, WLA_GLOBAL_TitleScroll__loop

	pop bc
	jr WLA_GLOBAL_TitleScroll

_TitleScroll.ScrollBetween:
WLA_GLOBAL_TitleScroll__ScrollBetween:
_TitleScroll.wait:
WLA_GLOBAL_TitleScroll__wait:
	ldh a, [lobyte(rLY)] ; rLY
	cp l
	jr nz, WLA_GLOBAL_TitleScroll__wait

	ld a, h
	ldh [lobyte(rSCX)], a

_TitleScroll.wait2:
WLA_GLOBAL_TitleScroll__wait2:
	ldh a, [lobyte(rLY)] ; rLY
	cp h
	jr z, WLA_GLOBAL_TitleScroll__wait2
	ret

TitleBallYTable:
; OBJ y-positions for the Poke Ball held by Red in the title screen.
; This is really two 0-terminated lists. Initiated with an index of 1.
	.DB 0, $71, $6f, $6e, $6d, $6c, $6d, $6e, $6f, $71, $74, 0

TitleScreenAnimateBallIfStarterOut:
; Animate the TitleBall if a starter just got scrolled out.
	ld a, [wTitleMonSpecies]
	cp STARTER1
	jr z, TitleScreenAnimateBallIfStarterOut.ok
	cp STARTER2
	jr z, TitleScreenAnimateBallIfStarterOut.ok
	cp STARTER3
	ret nz
TitleScreenAnimateBallIfStarterOut.ok
	ld e, 1 ; animate titleball
	ld bc, TitleScroll_WaitBall
	ld d, 0
	jp WLA_GLOBAL_TitleScroll

GetTitleBallY:
; Get position e from TitleBallYTable
	push de
	push hl
	xor a
	ld d, a
	ld hl, TitleBallYTable
	add hl, de
	ld a, [hl]
	pop hl
	pop de
	and a
	ret z
	ld [wShadowOAMSprite10YCoord], a
	inc e
	ret
