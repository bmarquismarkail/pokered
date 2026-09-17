;\1 = event index
;\2 = return result in carry instead of zero flag
.MACRO CheckEvent
	.REDEFINE event_byte ((\1) / 8)
	ld a, [wEventFlags + event_byte]

	.IF NARGS > 1
		.IF ((((\1) # 8))-(7)) < 1 && ((((\1) # 8))-(7)) > -1
			add a
		.ELSE
			.REPT ((\1) # 8) + 1
				rrca
			.ENDR
		.ENDIF
	.ELSE
		bit (\1) # 8, a
	.ENDIF
.ENDM


;\1 = event index
.MACRO CheckEventReuseA
	.REDEFINE event_byte ((\1) / 8)
	bit (\1) # 8, a
.ENDM


;\1 = event index
;\2 = event index of the last event used before the branch
.MACRO CheckEventAfterBranchReuseA
	.REDEFINE event_byte ((\2) / 8)
	.REDEFINE event_byte ((\1) / 8)
	bit (\1) # 8, a
.ENDM


;\1 = reg
;\2 = event index
;\3 = event index this event is relative to (optional, this is needed when there is a fixed flag address)
.MACRO EventFlagBit
	.IF NARGS > 2
		ld \1, ((\3) # 8) + ((\2) - (\3))
	.ELSE
		ld \1, (\2) # 8
	.ENDIF
.ENDM


;\1 = reg
;\2 = event index
.MACRO EventFlagAddress
	.REDEFINE event_byte ((\2) / 8)
	ld \1, wEventFlags + event_byte
.ENDM


;\1 = event index
.MACRO CheckEventHL
	.REDEFINE event_byte ((\1) / 8)
	ld hl, wEventFlags + event_byte
	bit (\1) # 8, [hl]
.ENDM


;\1 = event index
.MACRO CheckEventReuseHL
	.REDEFINE event_byte ((\1) / 8)
	bit (\1) # 8, [hl]
.ENDM


; dangerous, only use when HL is guaranteed to be the desired value
;\1 = event index
.MACRO CheckEventForceReuseHL
	.REDEFINE event_byte ((\1) / 8)
	bit (\1) # 8, [hl]
.ENDM


;\1 = event index
;\2 = event index of the last event used before the branch
.MACRO CheckEventAfterBranchReuseHL
	.REDEFINE event_byte ((\2) / 8)
	.REDEFINE event_byte ((\1) / 8)
	bit (\1) # 8, [hl]
.ENDM


;\1 = event index
.MACRO CheckAndSetEvent
	.REDEFINE event_byte ((\1) / 8)
	ld hl, wEventFlags + event_byte
	bit (\1) # 8, [hl]
	set (\1) # 8, [hl]
.ENDM


;\1 = event index
.MACRO CheckAndResetEvent
	.REDEFINE event_byte ((\1) / 8)
	ld hl, wEventFlags + event_byte
	bit (\1) # 8, [hl]
	res (\1) # 8, [hl]
.ENDM


;\1 = event index
.MACRO CheckAndSetEventA
	ld a, [wEventFlags + ((\1) / 8)]
	bit (\1) # 8, a
	set (\1) # 8, a
	ld [wEventFlags + ((\1) / 8)], a
.ENDM


;\1 = event index
.MACRO CheckAndResetEventA
	ld a, [wEventFlags + ((\1) / 8)]
	bit (\1) # 8, a
	res (\1) # 8, a
	ld [wEventFlags + ((\1) / 8)], a
.ENDM


;\1 = event index
.MACRO SetEvent
	.REDEFINE event_byte ((\1) / 8)
	ld hl, wEventFlags + event_byte
	set (\1) # 8, [hl]
.ENDM


;\1 = event index
.MACRO SetEventReuseHL
	.REDEFINE event_byte ((\1) / 8)
	set (\1) # 8, [hl]
.ENDM


;\1 = event index
;\2 = event index of the last event used before the branch
.MACRO SetEventAfterBranchReuseHL
	.REDEFINE event_byte ((\2) / 8)
	.REDEFINE event_byte ((\1) / 8)
	set (\1) # 8, [hl]
.ENDM


; dangerous, only use when HL is guaranteed to be the desired value
;\1 = event index
.MACRO SetEventForceReuseHL
	.REDEFINE event_byte ((\1) / 8)
	set (\1) # 8, [hl]
.ENDM


;\1 = event index
;\2 = event index
;\3, \4, ... = additional (optional) event indices
.MACRO SetEvents
	SetEvent \1
	.REPT NARGS - 1
		SetEventReuseHL \2
		.SHIFT
	.ENDR
.ENDM


;\1 = event index
.MACRO ResetEvent
	.REDEFINE event_byte ((\1) / 8)
	ld hl, wEventFlags + event_byte
	res (\1) # 8, [hl]
.ENDM


;\1 = event index
.MACRO ResetEventReuseHL
	.REDEFINE event_byte ((\1) / 8)
	res (\1) # 8, [hl]
.ENDM


;\1 = event index
;\2 = event index of the last event used before the branch
.MACRO ResetEventAfterBranchReuseHL
	.REDEFINE event_byte ((\2) / 8)
	.REDEFINE event_byte ((\1) / 8)
	res (\1) # 8, [hl]
.ENDM


; dangerous, only use when HL is guaranteed to be the desired value
;\1 = event index
.MACRO ResetEventForceReuseHL
	.REDEFINE event_byte ((\1) / 8)
	res (\1) # 8, [hl]
.ENDM


;\1 = event index
;\2 = event index
;\3 = event index (optional)
.MACRO ResetEvents
	ResetEvent \1
	.REPT NARGS - 1
		ResetEventReuseHL \2
		.SHIFT
	.ENDR
.ENDM


;\1 = start
;\2 = end
.MACRO SetEventRange
	.REDEFINE event_start_byte ((\1) >> 3)
	.REDEFINE event_end_byte ((\2) >> 3)
	.REDEFINE event_start_bit ((\1) # 8)
	.REDEFINE event_end_bit ((\2) # 8)
	.IF (((\1) >> 3) - ((\2) >> 3)) > 0
		.FAIL "Incorrect argument order in SetEventRange."
	.ENDIF

	.IF (((\1) >> 3) - ((\2) >> 3)) < 0
		.REDEFINE event_fill_start event_start_byte + 1
		.REDEFINE event_fill_count event_end_byte - event_start_byte - 1

		.IF event_start_bit
			ld a, [wEventFlags + event_start_byte]
			or $ff - ((1 << event_start_bit) - 1)
			ld [wEventFlags + event_start_byte], a
		.ELSE
			.REDEFINE event_fill_start event_fill_start - (1)
			.REDEFINE event_fill_count event_fill_count + (1)
		.ENDIF

		.IF event_end_bit > 6
			.REDEFINE event_fill_count event_fill_count + (1)
		.ENDIF

		.IF event_fill_count > 1
			ld a, $ff
			ld hl, wEventFlags + event_fill_start
			.REPT event_fill_count - 1
				ld [hli], a
			.ENDR
			ld [hl], a
		.ELIF event_fill_count > 0
			ld hl, wEventFlags + event_fill_start
			ld [hl], $ff
		.ENDIF

		.IF event_end_bit
			.IF event_end_bit < 7
				ld a, [wEventFlags + event_end_byte]
				or (1 << (event_end_bit + 1)) - 1
				ld [wEventFlags + event_end_byte], a
			.ENDIF
		.ELSE
			ld hl, wEventFlags + event_end_byte
			set 0, [hl]
		.ENDIF
	.ELSE
		ld a, [wEventFlags + event_start_byte]
		or (1 << (event_end_bit + 1)) - (1 << event_start_bit)
		ld [wEventFlags + event_start_byte], a
	.ENDIF
.ENDM


;\1 = start
;\2 = end
;\3 = assume a is 0 if present
.MACRO ResetEventRange
	.REDEFINE event_start_byte ((\1) >> 3)
	.REDEFINE event_end_byte ((\2) >> 3)
	.REDEFINE event_start_bit ((\1) # 8)
	.REDEFINE event_end_bit ((\2) # 8)

	.IF (((\1) >> 3) - ((\2) >> 3)) > 0
		.FAIL "Incorrect argument order in ResetEventRange."
	.ENDIF

	.IF (((\1) >> 3) - ((\2) >> 3)) < 0
		.REDEFINE event_fill_start event_start_byte + 1
		.REDEFINE event_fill_count event_end_byte - event_start_byte - 1

		.IF event_start_bit
			ld a, [wEventFlags + event_start_byte]
			and (1 << event_start_bit) - 1
			ld [wEventFlags + event_start_byte], a
		.ELSE
			.REDEFINE event_fill_start event_fill_start - (1)
			.REDEFINE event_fill_count event_fill_count + (1)
		.ENDIF

		.IF event_end_bit > 6
			.REDEFINE event_fill_count event_fill_count + (1)
		.ENDIF

		.IF event_fill_count > 1
			ld hl, wEventFlags + event_fill_start
			.IF (NARGS < 3) || event_start_bit
				xor a
			.ENDIF
			.REPT event_fill_count - 1
				ld [hli], a
			.ENDR
			ld [hl], a
		.ELIF event_fill_count > 0
			ld hl, wEventFlags + event_fill_start
			ld [hl], 0
		.ENDIF

		.IF event_end_bit
			.IF event_end_bit < 7
				ld a, [wEventFlags + event_end_byte]
				and $ff - ((1 << (event_end_bit + 1)) - 1)
				ld [wEventFlags + event_end_byte], a
			.ENDIF
		.ELSE
			ld hl, wEventFlags + event_end_byte
			res 0, [hl]
		.ENDIF
	.ELSE
		ld a, [wEventFlags + event_start_byte]
		and $ff - ((1 << (event_end_bit + 1)) - (1 << event_start_bit))
		ld [wEventFlags + event_start_byte], a
	.ENDIF
.ENDM


; returns whether both events are set in Z flag
; This is counter-intuitive because the other event checks set the Z flag when
; the event is not set, but this sets the Z flag when the event is set.
;\1 = event index 1
;\2 = event index 2
;\3 = try to reuse a (optional)
.MACRO CheckBothEventsSet
	.IF ((((\1) / 8))-(((\2) / 8))) < 1 && ((((\1) / 8))-(((\2) / 8))) > -1
		.IF NARGS < 3
			.REDEFINE event_byte ((\1) / 8)
			ld a, [wEventFlags + ((\1) / 8)]
		.ENDIF
		and (1 << ((\1) # 8)) | (1 << ((\2) # 8))
		cp (1 << ((\1) # 8)) | (1 << ((\2) # 8))
	.ELSE
		; This case doesn't happen in the original ROM.
		.IF ((((\1) # 8))-(((\2) # 8))) < 1 && ((((\1) # 8))-(((\2) # 8))) > -1
			push hl
			ld a, [wEventFlags + ((\1) / 8)]
			ld hl, wEventFlags + ((\2) / 8)
			and [hl]
			cpl
			bit ((\1) # 8), a
			pop hl
		.ELSE
			push bc
			ld a, [wEventFlags + ((\1) / 8)]
			and (1 << ((\1) # 8))
			ld b, a
			ld a, [wEventFlags + ((\2) / 8)]
			and (1 << ((\2) # 8))
			or b
			cp (1 << ((\1) # 8)) | (1 << ((\2) # 8))
			pop bc
		.ENDIF
	.ENDIF
.ENDM


; returns the complement of whether either event is set in Z flag
;\1 = event index 1
;\2 = event index 2
;\3 = try to reuse a (optional)
.MACRO CheckEitherEventSet
	.IF ((((\1) / 8))-(((\2) / 8))) < 1 && ((((\1) / 8))-(((\2) / 8))) > -1
		.IF NARGS < 3
			.REDEFINE event_byte ((\1) / 8)
			ld a, [wEventFlags + ((\1) / 8)]
		.ENDIF
		and (1 << ((\1) # 8)) | (1 << ((\2) # 8))
	.ELSE
		; This case doesn't happen in the original ROM.
		.IF ((((\1) # 8))-(((\2) # 8))) < 1 && ((((\1) # 8))-(((\2) # 8))) > -1
			push hl
			ld a, [wEventFlags + ((\1) / 8)]
			ld hl, wEventFlags + ((\2) / 8)
			or [hl]
			bit ((\1) # 8), a
			pop hl
		.ELSE
			push bc
			ld a, [wEventFlags + ((\1) / 8)]
			and (1 << ((\1) # 8))
			ld b, a
			ld a, [wEventFlags + ((\2) / 8)]
			and (1 << ((\2) # 8))
			or b
			pop bc
		.ENDIF
	.ENDIF
.ENDM


; for handling fixed event bits when events are inserted/removed
;\1 = event index
;\2 = fixed flag bit
.MACRO AdjustEventBit
	.IF (((\1) # 8) < (\2)) || (((\1) # 8) > (\2))
		add ((\1) # 8) - (\2)
	.ENDIF
.ENDM
