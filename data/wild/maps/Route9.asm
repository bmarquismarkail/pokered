Route9WildMons:
	def_grass_wildmons 15 ; encounter rate
	.DB 16, RATTATA
	.DB 16, SPEAROW
	.DB 14, RATTATA
.IF defined(_RED)
	.DB 11, EKANS
	.DB 13, SPEAROW
	.DB 15, EKANS
	.DB 17, RATTATA
	.DB 17, SPEAROW
	.DB 13, EKANS
	.DB 17, EKANS
.ENDIF
.IF defined(_BLUE)
	.DB 11, SANDSHREW
	.DB 13, SPEAROW
	.DB 15, SANDSHREW
	.DB 17, RATTATA
	.DB 17, SPEAROW
	.DB 13, SANDSHREW
	.DB 17, SANDSHREW
.ENDIF
	end_grass_wildmons

	def_water_wildmons 0 ; encounter rate
	end_water_wildmons
