Route2WildMons:
	def_grass_wildmons 25 ; encounter rate
	.DB  3, RATTATA
	.DB  3, PIDGEY
	.DB  4, PIDGEY
	.DB  4, RATTATA
	.DB  5, PIDGEY
.IF defined(_RED)
	.DB  3, WEEDLE
	.DB  2, RATTATA
	.DB  5, RATTATA
	.DB  4, WEEDLE
	.DB  5, WEEDLE
.ENDIF
.IF defined(_BLUE)
	.DB  3, CATERPIE
	.DB  2, RATTATA
	.DB  5, RATTATA
	.DB  4, CATERPIE
	.DB  5, CATERPIE
.ENDIF
	end_grass_wildmons

	def_water_wildmons 0 ; encounter rate
	end_water_wildmons
