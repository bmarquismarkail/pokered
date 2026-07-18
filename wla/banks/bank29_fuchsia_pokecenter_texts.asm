FuchsiaPokecenterNurseText:
	.DB $FF ; script_pokecenter_nurse
FuchsiaPokecenterRockerText:
	.DB $17
	.DW $6387
	.DB $27,$50
FuchsiaPokecenterCooltrainerFText:
	.DB $17
	.DW $63DE
	.DB $27,$50
FuchsiaPokecenterLinkReceptionistText:
	.DB $F6 ; script_cable_club_receptionist
FuchsiaPokecenterTextsEnd:
.ASSERT FuchsiaPokecenterTextsEnd - FuchsiaPokecenterNurseText == 12
