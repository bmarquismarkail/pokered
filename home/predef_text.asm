PrintPredefTextID:
	ldh [lobyte(hTextID)], a
	ld hl, TextPredefs
	call SetMapTextPointer
	ld hl, wTextPredefFlag
	set BIT_TEXT_PREDEF, [hl]
	call DisplayTextID

RestoreMapTextPointer:
	ld hl, wCurMapTextPtr
	ldh a, [lobyte(hSavedMapTextPtr)]
	ld [hli], a
	ldh a, [lobyte(hSavedMapTextPtr + 1)]
	ld [hl], a
	ret

SetMapTextPointer:
	ld a, [wCurMapTextPtr]
	ldh [lobyte(hSavedMapTextPtr)], a
	ld a, [wCurMapTextPtr + 1]
	ldh [lobyte(hSavedMapTextPtr + 1)], a
	ld a, l
	ld [wCurMapTextPtr], a
	ld a, h
	ld [wCurMapTextPtr + 1], a
	ret

.INCLUDE "data/text_predef_pointers.asm"
