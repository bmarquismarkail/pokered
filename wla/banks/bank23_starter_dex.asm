; Native WLA-DX form of engine/events/starter_dex.asm.
StarterDex:
	LD A, $4b
	LD (wPokedexOwned), A
	LD A, $3d ; ShowPokedexData predef ID
	CALL Predef
	XOR A
	LD (wPokedexOwned), A
	RET
StarterDexEnd:
