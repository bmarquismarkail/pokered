HPBarLength:
	call GetPredefRegisters

; calculates bc * 48 / de, the number of pixels the HP bar has
; the result is always at least 1
GetHPBarLength:
	push hl
	xor a
	ld hl, hMultiplicand
	ld [hli], a
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ld [hl], $30
	call Multiply      ; 48 * bc (hp bar is 48 pixels long)
	ld a, d
	and a
	jr z, GetHPBarLength.maxHPSmaller256
	srl d              ; make HP in de fit into 1 byte by dividing by 4
	rr e
	srl d
	rr e
	ldh a, [lobyte(hMultiplicand+1)]
	ld b, a
	ldh a, [lobyte(hMultiplicand+2)]
	srl b              ; divide multiplication result as well
	rr a
	srl b
	rr a
	ldh [lobyte(hMultiplicand+2)], a
	ld a, b
	ldh [lobyte(hMultiplicand+1)], a
GetHPBarLength.maxHPSmaller256
	ld a, e
	ldh [lobyte(hDivisor)], a
	ld b, $4
	call Divide
	ldh a, [lobyte(hMultiplicand+2)]
	ld e, a            ; e = bc * 48 / de (num of pixels of HP bar)
	pop hl
	and a
	ret nz
	ld e, $1           ; make result at least 1
	ret

; predef $48
UpdateHPBar:
UpdateHPBar2:
	push hl
	ld hl, wHPBarOldHP
	ld a, [hli]
	ld c, a      ; old HP into bc
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld e, a      ; new HP into de
	ld d, [hl]
	pop hl
	push de
	push bc
	call UpdateHPBar_CalcHPDifference
	ld a, e
	ld [wHPBarHPDifference+1], a
	ld a, d
	ld [wHPBarHPDifference], a
	pop bc
	pop de
	call UpdateHPBar_CompareNewHPToOldHP
	ret z
	ld a, $ff
	jr c, UpdateHPBar2.HPdecrease
	ld a, $1
UpdateHPBar2.HPdecrease
	ld [wHPBarDelta], a
	call GetPredefRegisters
	ld a, [wHPBarNewHP]
	ld e, a
	ld a, [wHPBarNewHP+1]
	ld d, a
UpdateHPBar2.animateHPBarLoop
	push de
	ld a, [wHPBarOldHP]
	ld c, a
	ld a, [wHPBarOldHP+1]
	ld b, a
	call UpdateHPBar_CompareNewHPToOldHP
	jr z, UpdateHPBar2.animateHPBarDone
	jr nc, UpdateHPBar2.HPIncrease
; HP decrease
	dec bc        ; subtract 1 HP
	ld a, c
	ld [wHPBarNewHP], a
	ld a, b
	ld [wHPBarNewHP+1], a
	call UpdateHPBar_CalcOldNewHPBarPixels
	ld a, e
	sub d         ; calc pixel difference
	jr UpdateHPBar2.ok
UpdateHPBar2.HPIncrease
	inc bc        ; add 1 HP
	ld a, c
	ld [wHPBarNewHP], a
	ld a, b
	ld [wHPBarNewHP+1], a
	call UpdateHPBar_CalcOldNewHPBarPixels
	ld a, d
	sub e         ; calc pixel difference
UpdateHPBar2.ok
	call UpdateHPBar_PrintHPNumber
	and a
	jr z, UpdateHPBar2.noPixelDifference
	call UpdateHPBar_AnimateHPBar
UpdateHPBar2.noPixelDifference
	ld a, [wHPBarNewHP]
	ld [wHPBarOldHP], a
	ld a, [wHPBarNewHP+1]
	ld [wHPBarOldHP+1], a
	pop de
	jr UpdateHPBar2.animateHPBarLoop
UpdateHPBar2.animateHPBarDone
	pop de
	ld a, e
	ld [wHPBarOldHP], a
	ld a, d
	ld [wHPBarOldHP+1], a
	or e
	jr z, UpdateHPBar2.monFainted
	call UpdateHPBar_CalcOldNewHPBarPixels
	ld d, e
UpdateHPBar2.monFainted
	call UpdateHPBar_PrintHPNumber
	ld a, $1
	call UpdateHPBar_AnimateHPBar
	jp Delay3

; animates the HP bar going up or down for (a) ticks (two waiting frames each)
; stops prematurely if bar is filled up
; e: current health (in pixels) to start with
UpdateHPBar_AnimateHPBar:
	push hl
UpdateHPBar_AnimateHPBar.barAnimationLoop
	push af
	push de
	ld d, $6
	call DrawHPBar
	ld c, 2
	call DelayFrames
	pop de
	ld a, [wHPBarDelta] ; +1 or -1
	add e
	cp $31
	jr nc, UpdateHPBar_AnimateHPBar.barFilledUp
	ld e, a
	pop af
	dec a
	jr nz, UpdateHPBar_AnimateHPBar.barAnimationLoop
	pop hl
	ret
UpdateHPBar_AnimateHPBar.barFilledUp
	pop af
	pop hl
	ret

; compares old HP and new HP and sets c and z flags accordingly
UpdateHPBar_CompareNewHPToOldHP:
	ld a, d
	sub b
	ret nz
	ld a, e
	sub c
	ret

; calcs HP difference between bc and de (into de)
UpdateHPBar_CalcHPDifference:
	ld a, d
	sub b
	jr c, UpdateHPBar_CalcHPDifference.oldHPGreater
	jr z, UpdateHPBar_CalcHPDifference.testLowerByte
UpdateHPBar_CalcHPDifference.newHPGreater
	ld a, e
	sub c
	ld e, a
	ld a, d
	sbc b
	ld d, a
	ret
UpdateHPBar_CalcHPDifference.oldHPGreater
	ld a, c
	sub e
	ld e, a
	ld a, b
	sbc d
	ld d, a
	ret
UpdateHPBar_CalcHPDifference.testLowerByte
	ld a, e
	sub c
	jr c, UpdateHPBar_CalcHPDifference.oldHPGreater
	jr nz, UpdateHPBar_CalcHPDifference.newHPGreater
	ld de, $0
	ret

UpdateHPBar_PrintHPNumber:
	push af
	push de
	ld a, [wHPBarType]
	and a
	jr z, UpdateHPBar_PrintHPNumber.done ; don't print number in enemy HUD
; convert from little-endian to big-endian for PrintNumber
	ld a, [wHPBarOldHP]
	ld [wHPBarTempHP + 1], a
	ld a, [wHPBarOldHP + 1]
	ld [wHPBarTempHP], a
	push hl
	ldh a, [lobyte(hUILayoutFlags)]
	bit BIT_PARTY_MENU_HP_BAR, a
	jr z, UpdateHPBar_PrintHPNumber.hpBelowBar
	ld de, $9
	jr UpdateHPBar_PrintHPNumber.next
UpdateHPBar_PrintHPNumber.hpBelowBar
	ld de, $15
UpdateHPBar_PrintHPNumber.next
	add hl, de
	push hl
	ld a, $7f
	ld [hli], a
	ld [hli], a
	ld [hli], a
	pop hl
	ld de, wHPBarTempHP
	lb "bc", 2, 3
	call PrintNumber
	call DelayFrame
	pop hl
UpdateHPBar_PrintHPNumber.done
	pop de
	pop af
	ret

; calcs number of HP bar pixels for old and new HP value
; d: new pixels
; e: old pixels
UpdateHPBar_CalcOldNewHPBarPixels:
	push hl
	ld hl, wHPBarMaxHP
	ld a, [hli]  ; max HP into de
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]  ; old HP into bc
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]  ; new HP into hl
	ld h, [hl]
	ld l, a
	push hl
	push de
	call GetHPBarLength ; calc num pixels for old HP
	ld a, e
	pop de
	pop bc
	push af
	call GetHPBarLength ; calc num pixels for new HP
	pop af
	ld d, e
	ld e, a
	pop hl
	ret
