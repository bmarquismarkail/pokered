Route11WildMons:
	def_grass_wildmons 15 ; encounter rate
.IF defined(_RED)
	.DB 14, EKANS
	.DB 15, SPEAROW
	.DB 12, EKANS
	.DB  9, DROWZEE
	.DB 13, SPEAROW
	.DB 13, DROWZEE
	.DB 15, EKANS
.ENDIF
.IF defined(_BLUE)
	.DB 14, SANDSHREW
	.DB 15, SPEAROW
	.DB 12, SANDSHREW
	.DB  9, DROWZEE
	.DB 13, SPEAROW
	.DB 13, DROWZEE
	.DB 15, SANDSHREW
.ENDIF
	.DB 17, SPEAROW
	.DB 11, DROWZEE
	.DB 15, DROWZEE
	end_grass_wildmons

	def_water_wildmons 0 ; encounter rate
	end_water_wildmons
