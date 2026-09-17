PrintTrashText:
	call EnableAutoTextBoxDrawing
	tx_pre_jump VermilionGymTrashText

VermilionGymTrashText:
	text_far WLA_GLOBAL_VermilionGymTrashText
	text_end

GymTrashScript:
	call EnableAutoTextBoxDrawing
	ld a, [wHiddenEventFunctionArgument]
	ld [wGymTrashCanIndex], a

; Don't do the trash can puzzle if it's already been done.
	CheckEvent EVENT_2ND_LOCK_OPENED
	jr z, GymTrashScript.ok

	tx_pre_jump VermilionGymTrashText

GymTrashScript.ok
	CheckEventReuseA EVENT_1ST_LOCK_OPENED
	jr nz, GymTrashScript.trySecondLock

	ld a, [wFirstLockTrashCanIndex]
	ld b, a
	ld a, [wGymTrashCanIndex]
	cp b
	jr z, GymTrashScript.openFirstLock

	tx_pre_id VermilionGymTrashText
	jr GymTrashScript.done

GymTrashScript.openFirstLock
; Next can is trying for the second switch.
	SetEvent EVENT_1ST_LOCK_OPENED

	ld hl, GymTrashCans
	ld a, [wGymTrashCanIndex]
	; * 5
	ld b, a
	add a
	add a
	add b

	ld d, 0
	ld e, a
	add hl, de
	ld a, [hli]

; Bug: This code should calculate a value in the range [0, 3],
; but if the mask and random number don't have any 1 bits in common, then
; the result of the AND will be 0. When 1 is subtracted from that, the value
; will become $ff. This will result in 255 being added to hl, which will cause
; hl to point to one of the zero bytes that pad the end of the ROM bank.
; Trash can 0 was intended to be able to have the second lock only when the
; first lock was in trash can 1 or 3. However, due to this bug, trash can 0 can
; have the second lock regardless of which trash can had the first lock.

	ldh [lobyte(hGymTrashCanRandNumMask)], a
	push hl
	call Random
	swap a
	ld b, a
	ldh a, [lobyte(hGymTrashCanRandNumMask)]
	and b
	dec a
	pop hl

	ld d, 0
	ld e, a
	add hl, de
	ld a, [hl]
	and $f
	ld [wSecondLockTrashCanIndex], a

	tx_pre_id VermilionGymTrashSuccessText1
	jr GymTrashScript.done

GymTrashScript.trySecondLock
	ld a, [wSecondLockTrashCanIndex]
	ld b, a
	ld a, [wGymTrashCanIndex]
	cp b
	jr z, GymTrashScript.openSecondLock

; Reset the cans.
	ResetEvent EVENT_1ST_LOCK_OPENED
	call Random

	and $e
	ld [wFirstLockTrashCanIndex], a

	tx_pre_id VermilionGymTrashFailText
	jr GymTrashScript.done

GymTrashScript.openSecondLock
; Completed the trash can puzzle.
	SetEvent EVENT_2ND_LOCK_OPENED
	ld hl, wCurrentMapScriptFlags
	set BIT_CUR_MAP_LOADED_2, [hl]

	tx_pre_id VermilionGymTrashSuccessText3

GymTrashScript.done
	jp PrintPredefTextID

GymTrashCans:
; byte 0: mask for random number
; bytes 1-4: indices of the trash cans that can have the second lock
;            (but see the comment above explaining a bug regarding this)
; Note that the mask is simply the number of valid trash can indices that
; follow. The remaining bytes are filled with 0 to pad the length of each entry
; to 5 bytes.
	.DB 2,  1,  3,  0,  0 ; 0
	.DB 3,  0,  2,  4,  0 ; 1
	.DB 2,  1,  5,  0,  0 ; 2
	.DB 3,  0,  4,  6,  0 ; 3
	.DB 4,  1,  3,  5,  7 ; 4
	.DB 3,  2,  4,  8,  0 ; 5
	.DB 3,  3,  7,  9,  0 ; 6
	.DB 4,  4,  6,  8, 10 ; 7
	.DB 3,  5,  7, 11,  0 ; 8
	.DB 3,  6, 10, 12,  0 ; 9
	.DB 4,  7,  9, 11, 13 ; 10
	.DB 3,  8, 10, 14,  0 ; 11
	.DB 2,  9, 13,  0,  0 ; 12
	.DB 3, 10, 12, 14,  0 ; 13
	.DB 2, 11, 13,  0,  0 ; 14

VermilionGymTrashSuccessText1:
	text_far WLA_GLOBAL_VermilionGymTrashSuccessText1
	text_asm
	call WaitForSoundToFinish
	ld a, SFX_SWITCH
	call PlaySound
	call WaitForSoundToFinish
	jp TextScriptEnd

; unused
VermilionGymTrashSuccessText2:
	text_far WLA_GLOBAL_VermilionGymTrashSuccessText2
	text_end

; unused
VermilionGymTrashSuccessPlaySfx:
	text_asm
	call WaitForSoundToFinish
	ld a, SFX_SWITCH
	call PlaySound
	call WaitForSoundToFinish
	jp TextScriptEnd

VermilionGymTrashSuccessText3:
	text_far WLA_GLOBAL_VermilionGymTrashSuccessText3
	text_asm
	call WaitForSoundToFinish
	ld a, SFX_GO_INSIDE
	call PlaySound
	call WaitForSoundToFinish
	jp TextScriptEnd

VermilionGymTrashFailText:
	text_far WLA_GLOBAL_VermilionGymTrashFailText
	text_asm
	call WaitForSoundToFinish
	ld a, SFX_DENIED
	call PlaySound
	call WaitForSoundToFinish
	jp TextScriptEnd
