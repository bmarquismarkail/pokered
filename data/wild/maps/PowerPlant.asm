PowerPlantWildMons:
	def_grass_wildmons 10 ; encounter rate
	.DB 21, VOLTORB
	.DB 21, MAGNEMITE
	.DB 20, PIKACHU
	.DB 24, PIKACHU
	.DB 23, MAGNEMITE
	.DB 23, VOLTORB
	.DB 32, MAGNETON
	.DB 35, MAGNETON
.IF defined(_RED)
	.DB 33, ELECTABUZZ
	.DB 36, ELECTABUZZ
.ENDIF
.IF defined(_BLUE)
	.DB 33, RAICHU
	.DB 36, RAICHU
.ENDIF
	end_grass_wildmons

	def_water_wildmons 0 ; encounter rate
	end_water_wildmons
