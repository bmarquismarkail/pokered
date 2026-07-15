; Standard nurse script and gentleman far-text record.
PewterPokecenterNurseText:
	.DB $FF ; script_pokecenter_nurse
PewterPokecenterGentlemanText:
	.DB $17
	.DW $4704 ; _PewterPokecenterGentlemanText
	.DB $26, $50
PewterPokecenterSmallTextsEnd:
.ASSERT PewterPokecenterSmallTextsEnd - PewterPokecenterNurseText == 6
