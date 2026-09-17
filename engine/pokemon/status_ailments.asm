PrintStatusAilment:
	ld a, [de]
	bit PSN, a
	jr nz, PrintStatusAilment.psn
	bit BRN, a
	jr nz, PrintStatusAilment.brn
	bit FRZ, a
	jr nz, PrintStatusAilment.frz
	bit PAR, a
	jr nz, PrintStatusAilment.par
	and SLP_MASK
	ret z
	ld_hli_a_string "SLP"
	ret
PrintStatusAilment.psn
	ld_hli_a_string "PSN"
	ret
PrintStatusAilment.brn
	ld_hli_a_string "BRN"
	ret
PrintStatusAilment.frz
	ld_hli_a_string "FRZ"
	ret
PrintStatusAilment.par
	ld_hli_a_string "PAR"
	ret
