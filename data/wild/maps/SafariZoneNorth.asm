SafariZoneNorthWildMons:
	def_grass_wildmons 30 ; encounter rate
.IF defined(_RED)
	.DB 22, NIDORAN_M
	.DB 26, RHYHORN
	.DB 23, PARAS
	.DB 25, EXEGGCUTE
	.DB 30, NIDORINO
	.DB 27, EXEGGCUTE
	.DB 30, NIDORINA
.ENDIF
.IF defined(_BLUE)
	.DB 22, NIDORAN_F
	.DB 26, RHYHORN
	.DB 23, PARAS
	.DB 25, EXEGGCUTE
	.DB 30, NIDORINA
	.DB 27, EXEGGCUTE
	.DB 30, NIDORINO
.ENDIF
	.DB 32, VENOMOTH
	.DB 26, CHANSEY
	.DB 28, TAUROS
	end_grass_wildmons

	def_water_wildmons 0 ; encounter rate
	end_water_wildmons
