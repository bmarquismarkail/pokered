ViridianForestWildMons:
	def_grass_wildmons 8 ; encounter rate
.IF defined(_RED)
	.DB  4, WEEDLE
	.DB  5, KAKUNA
	.DB  3, WEEDLE
	.DB  5, WEEDLE
	.DB  4, KAKUNA
	.DB  6, KAKUNA
	.DB  4, METAPOD
	.DB  3, CATERPIE
.ENDIF
.IF defined(_BLUE)
	.DB  4, CATERPIE
	.DB  5, METAPOD
	.DB  3, CATERPIE
	.DB  5, CATERPIE
	.DB  4, METAPOD
	.DB  6, METAPOD
	.DB  4, KAKUNA
	.DB  3, WEEDLE
.ENDIF
	.DB  3, PIKACHU
	.DB  5, PIKACHU
	end_grass_wildmons

	def_water_wildmons 0 ; encounter rate
	end_water_wildmons
