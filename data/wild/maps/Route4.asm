Route4WildMons:
	def_grass_wildmons 20 ; encounter rate
	.DB 10, RATTATA
	.DB 10, SPEAROW
	.DB  8, RATTATA
.IF defined(_RED)
	.DB  6, EKANS
	.DB  8, SPEAROW
	.DB 10, EKANS
	.DB 12, RATTATA
	.DB 12, SPEAROW
	.DB  8, EKANS
	.DB 12, EKANS
.ENDIF
.IF defined(_BLUE)
	.DB  6, SANDSHREW
	.DB  8, SPEAROW
	.DB 10, SANDSHREW
	.DB 12, RATTATA
	.DB 12, SPEAROW
	.DB  8, SANDSHREW
	.DB 12, SANDSHREW
.ENDIF
	end_grass_wildmons

	def_water_wildmons 0 ; encounter rate
	end_water_wildmons
