CeruleanCave1FWildMons:
	def_grass_wildmons 10 ; encounter rate
	.DB 46, GOLBAT
	.DB 46, HYPNO
	.DB 46, MAGNETON
	.DB 49, DODRIO
	.DB 49, VENOMOTH
.IF defined(_RED)
	.DB 52, ARBOK
.ENDIF
.IF defined(_BLUE)
	.DB 52, SANDSLASH
.ENDIF
	.DB 49, KADABRA
	.DB 52, PARASECT
	.DB 53, RAICHU
	.DB 53, DITTO
	end_grass_wildmons

	def_water_wildmons 0 ; encounter rate
	end_water_wildmons
