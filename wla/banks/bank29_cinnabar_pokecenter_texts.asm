CinnabarPokecenterNurseText:
	.DB $FF ; script_pokecenter_nurse
CinnabarPokecenterCooltrainerFText:
	.DB $17
	.DW $52DE
	.DB $28,$50
CinnabarPokecenterGentlemanText:
	.DB $17
	.DW $533E
	.DB $28,$50
CinnabarPokecenterLinkReceptionistText:
	.DB $F6 ; script_cable_club_receptionist
CinnabarPokecenterTextsEnd:
.ASSERT CinnabarPokecenterTextsEnd - CinnabarPokecenterNurseText == 12
