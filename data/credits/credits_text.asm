CreditsTextPointers:
; entries correspond to CRED_* constants
	table_width 2
	.DW CredVersion
	.DW CredTajiri
	.DW CredTaOota
	.DW CredMorimoto
	.DW CredWatanabe
	.DW CredMasuda
	.DW CredNisino
	.DW CredSugimori
	.DW CredNishida
	.DW CredMiyamoto
	.DW CredKawaguchi
	.DW CredIshihara
	.DW CredYamauchi
	.DW CredZinnai
	.DW CredHishida
	.DW CredSakai
	.DW CredYamaguchi
	.DW CredYamamoto
	.DW CredTaniguchi
	.DW CredNonomura
	.DW CredFuziwara
	.DW CredMatsusima
	.DW CredTomisawa
	.DW CredKawamoto
	.DW CredKakei
	.DW CredTsuchiya
	.DW CredTaNakamura
	.DW CredYuda
	.DW CredMon
	.DW CredDirector
	.DW CredProgrammers
	.DW CredCharDesign
	.DW CredMusic
	.DW CredSoundEffects
	.DW CredGameDesign
	.DW CredMonsterDesign
	.DW CredGameScene
	.DW CredParam
	.DW CredMap
	.DW CredTest
	.DW CredSpecial
	.DW CredProducers
	.DW CredProducer
	.DW CredExecutive
	.DW CredTamada
	.DW CredSaOota
	.DW CredYoshikawa
	.DW CredToOota
	.DW CredUSStaff
	.DW CredUSCoord
	.DW CredTilden
	.DW CredKawakami
	.DW CredHiNakamura
	.DW CredGiese
	.DW CredOsborne
	.DW CredTrans
	.DW CredOgasawara
	.DW CredIwata
	.DW CredIzushi
	.DW CredHarada
	.DW CredMurakawa
	.DW CredFukui
	.DW CredClub
	.DW CredPAAD
	assert_table_length NUM_CRED_STRINGS

CredVersion:
.IF defined(_RED)
		.DB -8
		.STRINGMAP pokemon, "RED VERSION STAFF@"
.ENDIF
.IF defined(_BLUE)
		.DB -8
		.STRINGMAP pokemon, "BLUE VERSION STAFF@"
.ENDIF
CredTajiri:
		.DB -6
		.STRINGMAP pokemon, "SATOSHI TAJIRI@"
CredTaOota:
		.DB -6
		.STRINGMAP pokemon, "TAKENORI OOTA@"
CredMorimoto:
		.DB -7
		.STRINGMAP pokemon, "SHIGEKI MORIMOTO@"
CredWatanabe:
		.DB -7
		.STRINGMAP pokemon, "TETSUYA WATANABE@"
CredMasuda:
		.DB -6
		.STRINGMAP pokemon, "JUNICHI MASUDA@"
CredNisino:
		.DB -5
		.STRINGMAP pokemon, "KOHJI NISINO@"
CredSugimori:
		.DB -5
		.STRINGMAP pokemon, "KEN SUGIMORI@"
CredNishida:
		.DB -6
		.STRINGMAP pokemon, "ATSUKO NISHIDA@"
CredMiyamoto:
		.DB -7
		.STRINGMAP pokemon, "SHIGERU MIYAMOTO@"
CredKawaguchi:
		.DB -8
		.STRINGMAP pokemon, "TAKASHI KAWAGUCHI@"
CredIshihara:
		.DB -8
		.STRINGMAP pokemon, "TSUNEKAZU ISHIHARA@"
CredYamauchi:
		.DB -7
		.STRINGMAP pokemon, "HIROSHI YAMAUCHI@"
CredZinnai:
		.DB -7
		.STRINGMAP pokemon, "HIROYUKI ZINNAI@"
CredHishida:
		.DB -7
		.STRINGMAP pokemon, "TATSUYA HISHIDA@"
CredSakai:
		.DB -6
		.STRINGMAP pokemon, "YASUHIRO SAKAI@"
CredYamaguchi:
		.DB -7
		.STRINGMAP pokemon, "WATARU YAMAGUCHI@"
CredYamamoto:
		.DB -8
		.STRINGMAP pokemon, "KAZUYUKI YAMAMOTO@"
CredTaniguchi:
		.DB -8
		.STRINGMAP pokemon, "RYOHSUKE TANIGUCHI@"
CredNonomura:
		.DB -8
		.STRINGMAP pokemon, "FUMIHIRO NONOMURA@"
CredFuziwara:
		.DB -7
		.STRINGMAP pokemon, "MOTOFUMI FUZIWARA@"
CredMatsusima:
		.DB -7
		.STRINGMAP pokemon, "KENJI MATSUSIMA@"
CredTomisawa:
		.DB -7
		.STRINGMAP pokemon, "AKIHITO TOMISAWA@"
CredKawamoto:
		.DB -7
		.STRINGMAP pokemon, "HIROSHI KAWAMOTO@"
CredKakei:
		.DB -6
		.STRINGMAP pokemon, "AKIYOSHI KAKEI@"
CredTsuchiya:
		.DB -7
		.STRINGMAP pokemon, "KAZUKI TSUCHIYA@"
CredTaNakamura:
		.DB -6
		.STRINGMAP pokemon, "TAKEO NAKAMURA@"
CredYuda:
		.DB -6
		.STRINGMAP pokemon, "MASAMITSU YUDA@"
CredMon:
		.DB -3
		.STRINGMAP pokemon, "#MON@"
CredDirector:
		.DB -3
		.STRINGMAP pokemon, "DIRECTOR@"
CredProgrammers:
		.DB -5
		.STRINGMAP pokemon, "PROGRAMMERS@"
CredCharDesign:
		.DB -7
		.STRINGMAP pokemon, "CHARACTER DESIGN@"
CredMusic:
		.DB -2
		.STRINGMAP pokemon, "MUSIC@"
CredSoundEffects:
		.DB -6
		.STRINGMAP pokemon, "SOUND EFFECTS@"
CredGameDesign:
		.DB -5
		.STRINGMAP pokemon, "GAME DESIGN@"
CredMonsterDesign:
		.DB -6
		.STRINGMAP pokemon, "MONSTER DESIGN@"
CredGameScene:
		.DB -6
		.STRINGMAP pokemon, "GAME SCENARIO@"
CredParam:
		.DB -8
		.STRINGMAP pokemon, "PARAMETRIC DESIGN@"
CredMap:
		.DB -4
		.STRINGMAP pokemon, "MAP DESIGN@"
CredTest:
		.DB -7
		.STRINGMAP pokemon, "PRODUCT TESTING@"
CredSpecial:
		.DB -6
		.STRINGMAP pokemon, "SPECIAL THANKS@"
CredProducers:
		.DB -4
		.STRINGMAP pokemon, "PRODUCERS@"
CredProducer:
		.DB -4
		.STRINGMAP pokemon, "PRODUCER@"
CredExecutive:
		.DB -8
		.STRINGMAP pokemon, "EXECUTIVE PRODUCER@"
CredTamada:
		.DB -6
		.STRINGMAP pokemon, "SOUSUKE TAMADA@"
CredSaOota:
		.DB -5
		.STRINGMAP pokemon, "SATOSHI OOTA@"
CredYoshikawa:
		.DB -6
		.STRINGMAP pokemon, "RENA YOSHIKAWA@"
CredToOota:
		.DB -6
		.STRINGMAP pokemon, "TOMOMICHI OOTA@"
CredUSStaff:
		.DB -7
		.STRINGMAP pokemon, "US VERSION STAFF@"
CredUSCoord:
		.DB -7
		.STRINGMAP pokemon, "US COORDINATION@"
CredTilden:
		.DB -5
		.STRINGMAP pokemon, "GAIL TILDEN@"
CredKawakami:
		.DB -6
		.STRINGMAP pokemon, "NAOKO KAWAKAMI@"
CredHiNakamura:
		.DB -6
		.STRINGMAP pokemon, "HIRO NAKAMURA@"
CredGiese:
		.DB -6
		.STRINGMAP pokemon, "WILLIAM GIESE@"
CredOsborne:
		.DB -5
		.STRINGMAP pokemon, "SARA OSBORNE@"
CredTrans:
		.DB -7
		.STRINGMAP pokemon, "TEXT TRANSLATION@"
CredOgasawara:
		.DB -6
		.STRINGMAP pokemon, "NOB OGASAWARA@"
CredIwata:
		.DB -5
		.STRINGMAP pokemon, "SATORU IWATA@"
CredIzushi:
		.DB -7
		.STRINGMAP pokemon, "TAKEHIRO IZUSHI@"
CredHarada:
		.DB -7
		.STRINGMAP pokemon, "TAKAHIRO HARADA@"
CredMurakawa:
		.DB -7
		.STRINGMAP pokemon, "TERUKI MURAKAWA@"
CredFukui:
		.DB -5
		.STRINGMAP pokemon, "KOHTA FUKUI@"
CredClub:
		.DB -9
		.STRINGMAP pokemon, "NCL SUPER MARIO CLUB@"
CredPAAD:
		.DB -5
		.STRINGMAP pokemon, "PAAD TESTING@"
