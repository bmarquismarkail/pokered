Route22WildMons:
	def_grass_wildmons 25 ; encounter rate
	.DB  3, RATTATA
.IF defined(_RED)
	.DB  3, NIDORAN_M
	.DB  4, RATTATA
	.DB  4, NIDORAN_M
	.DB  2, RATTATA
	.DB  2, NIDORAN_M
	.DB  3, SPEAROW
	.DB  5, SPEAROW
	.DB  3, NIDORAN_F
	.DB  4, NIDORAN_F
.ENDIF
.IF defined(_BLUE)
	.DB  3, NIDORAN_F
	.DB  4, RATTATA
	.DB  4, NIDORAN_F
	.DB  2, RATTATA
	.DB  2, NIDORAN_F
	.DB  3, SPEAROW
	.DB  5, SPEAROW
	.DB  3, NIDORAN_M
	.DB  4, NIDORAN_M
.ENDIF
	end_grass_wildmons

	def_water_wildmons 0 ; encounter rate
	end_water_wildmons
