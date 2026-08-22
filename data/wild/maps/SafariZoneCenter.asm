SafariZoneCenterWildMons:
	def_grass_wildmons 30 ; encounter rate
.IF defined(_RED)
	.DB 22, NIDORAN_M
	.DB 25, RHYHORN
	.DB 22, VENONAT
	.DB 24, EXEGGCUTE
	.DB 31, NIDORINO
	.DB 25, EXEGGCUTE
	.DB 31, NIDORINA
	.DB 30, PARASECT
	.DB 23, SCYTHER
.ENDIF
.IF defined(_BLUE)
	.DB 22, NIDORAN_F
	.DB 25, RHYHORN
	.DB 22, VENONAT
	.DB 24, EXEGGCUTE
	.DB 31, NIDORINA
	.DB 25, EXEGGCUTE
	.DB 31, NIDORINO
	.DB 30, PARASECT
	.DB 23, PINSIR
.ENDIF
	.DB 23, CHANSEY
	end_grass_wildmons

	def_water_wildmons 0 ; encounter rate
	end_water_wildmons
