SafariZoneEastWildMons:
	def_grass_wildmons 30 ; encounter rate
.IF defined(_RED)
	.DB 24, NIDORAN_M
	.DB 26, DODUO
	.DB 22, PARAS
	.DB 25, EXEGGCUTE
	.DB 33, NIDORINO
	.DB 23, EXEGGCUTE
	.DB 24, NIDORAN_F
	.DB 25, PARASECT
	.DB 25, KANGASKHAN
	.DB 28, SCYTHER
.ENDIF
.IF defined(_BLUE)
	.DB 24, NIDORAN_F
	.DB 26, DODUO
	.DB 22, PARAS
	.DB 25, EXEGGCUTE
	.DB 33, NIDORINA
	.DB 23, EXEGGCUTE
	.DB 24, NIDORAN_M
	.DB 25, PARASECT
	.DB 25, KANGASKHAN
	.DB 28, PINSIR
.ENDIF
	end_grass_wildmons

	def_water_wildmons 0 ; encounter rate
	end_water_wildmons
