BankswitchHome:
; switches to bank # in a
; Only use this when in the home bank!
	ld [wBankswitchHomeTemp], a
	ldh a, [lobyte(hLoadedROMBank)]
	ld [wBankswitchHomeSavedROMBank], a
	ld a, [wBankswitchHomeTemp]
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	ret

BankswitchBack:
; returns from BankswitchHome
	ld a, [wBankswitchHomeSavedROMBank]
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	ret

Bankswitch:
; self-contained bankswitch, use this when not in the home bank
; switches to the bank in b
	ldh a, [lobyte(hLoadedROMBank)]
	push af
	ld a, b
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	ld bc, Bankswitch.Return
	push bc
	jp hl
Bankswitch.Return
	pop bc
	ld a, b
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	ret
