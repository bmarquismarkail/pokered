CeruleanCaveB1FWildMons:
	def_grass_wildmons 25 ; encounter rate
	.DB 55, RHYDON
	.DB 55, MAROWAK
	.DB 55, ELECTRODE
	.DB 64, CHANSEY
	.DB 64, PARASECT
	.DB 64, RAICHU
.IF defined(_RED)
	.DB 57, ARBOK
.ENDIF
.IF defined(_BLUE)
	.DB 57, SANDSLASH
.ENDIF
	.DB 65, DITTO
	.DB 63, DITTO
	.DB 67, DITTO
	end_grass_wildmons

	def_water_wildmons 0 ; encounter rate
	end_water_wildmons
