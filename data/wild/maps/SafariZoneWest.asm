SafariZoneWestWildMons:
	def_grass_wildmons 30 ; encounter rate
.IF defined(_RED)
	.DB 25, NIDORAN_M
	.DB 26, DODUO
	.DB 23, VENONAT
	.DB 24, EXEGGCUTE
	.DB 33, NIDORINO
	.DB 26, EXEGGCUTE
	.DB 25, NIDORAN_F
.ENDIF
.IF defined(_BLUE)
	.DB 25, NIDORAN_F
	.DB 26, DODUO
	.DB 23, VENONAT
	.DB 24, EXEGGCUTE
	.DB 33, NIDORINA
	.DB 26, EXEGGCUTE
	.DB 25, NIDORAN_M
.ENDIF
	.DB 31, VENOMOTH
	.DB 26, TAUROS
	.DB 28, KANGASKHAN
	end_grass_wildmons

	def_water_wildmons 0 ; encounter rate
	end_water_wildmons
