Route23WildMons:
	def_grass_wildmons 10 ; encounter rate
.IF defined(_RED)
	.DB 26, EKANS
.ENDIF
.IF defined(_BLUE)
	.DB 26, SANDSHREW
.ENDIF
	.DB 33, DITTO
	.DB 26, SPEAROW
	.DB 38, FEAROW
	.DB 38, DITTO
	.DB 38, FEAROW
.IF defined(_RED)
	.DB 41, ARBOK
.ENDIF
.IF defined(_BLUE)
	.DB 41, SANDSLASH
.ENDIF
	.DB 43, DITTO
	.DB 41, FEAROW
	.DB 43, FEAROW
	end_grass_wildmons

	def_water_wildmons 0 ; encounter rate
	end_water_wildmons
