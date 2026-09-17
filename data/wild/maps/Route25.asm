Route25WildMons:
	def_grass_wildmons 15 ; encounter rate
.IF defined(_RED)
	.DB  8, WEEDLE
	.DB  9, KAKUNA
	.DB 13, PIDGEY
	.DB 12, ODDISH
	.DB 13, ODDISH
	.DB 12, ABRA
	.DB 14, ODDISH
	.DB 10, ABRA
	.DB  7, METAPOD
	.DB  8, CATERPIE
.ENDIF
.IF defined(_BLUE)
	.DB  8, CATERPIE
	.DB  9, METAPOD
	.DB 13, PIDGEY
	.DB 12, BELLSPROUT
	.DB 13, BELLSPROUT
	.DB 12, ABRA
	.DB 14, BELLSPROUT
	.DB 10, ABRA
	.DB  7, KAKUNA
	.DB  8, WEEDLE
.ENDIF
	end_grass_wildmons

	def_water_wildmons 0 ; encounter rate
	end_water_wildmons
