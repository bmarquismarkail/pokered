; Far calls to another bank

; There is no difference between `farcall` and `callfar`, except the arbitrary
; order in which they set `b` and `hl` before calling `FarCall`.
; We use the more natural name "farcall" for the more common order.
; The same goes for `farjp` and `jpfar`.

.MACRO farcall
	ld b, bank(\1)
	ld hl, \1
	call Bankswitch
.ENDM

.MACRO callfar
	ld hl, \1
	ld b, bank(\1)
	call Bankswitch
.ENDM

.MACRO farjp
	ld b, bank(\1)
	ld hl, \1
	jp Bankswitch
.ENDM

.MACRO jpfar
	ld hl, \1
	ld b, bank(\1)
	jp Bankswitch
.ENDM

.MACRO homecall
	ldh a, [lobyte(hLoadedROMBank)]
	push af
	ld a, bank(\1)
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	call \1
	pop af
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
.ENDM

.MACRO homecall_sf ; homecall but save flags by popping into bc instead of af
	ldh a, [lobyte(hLoadedROMBank)]
	push af
	ld a, bank(\1)
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	call \1
	pop bc
	ld a, b
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
.ENDM
