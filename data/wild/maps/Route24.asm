Route24WildMons:
	def_grass_wildmons 25 ; encounter rate
.IF defined(_RED)
	.DB  7, WEEDLE
	.DB  8, KAKUNA
	.DB 12, PIDGEY
	.DB 12, ODDISH
	.DB 13, ODDISH
	.DB 10, ABRA
	.DB 14, ODDISH
.ENDIF
.IF defined(_BLUE)
	.DB  7, CATERPIE
	.DB  8, METAPOD
	.DB 12, PIDGEY
	.DB 12, BELLSPROUT
	.DB 13, BELLSPROUT
	.DB 10, ABRA
	.DB 14, BELLSPROUT
.ENDIF
	.DB 13, PIDGEY
	.DB  8, ABRA
	.DB 12, ABRA
	end_grass_wildmons

	def_water_wildmons 0 ; encounter rate
	end_water_wildmons
