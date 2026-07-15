; Seven trainers, each with battle, end-battle, and after-battle text records.
SaffronGymChanneler1BattleText:
	.DB $17
	.DW $5F33
	.DB $28, $50
SaffronGymChanneler1EndBattleText:
	.DB $17
	.DW $5F62
	.DB $28, $50
SaffronGymChanneler1AfterBattleText:
	.DB $17
	.DW $5F74
	.DB $28, $50
SaffronGymYoungster1BattleText:
	.DB $17
	.DW $5FE0
	.DB $28, $50
SaffronGymYoungster1EndBattleText:
	.DB $17
	.DW $6002
	.DB $28, $50
SaffronGymYoungster1AfterBattleText:
	.DB $17
	.DW $6019
	.DB $28, $50
SaffronGymChanneler2BattleText:
	.DB $17
	.DW $6042
	.DB $28, $50
SaffronGymChanneler2EndBattleText:
	.DB $17
	.DW $6091
	.DB $28, $50
SaffronGymChanneler2AfterBattleText:
	.DB $17
	.DW $609D
	.DB $28, $50
SaffronGymYoungster2BattleText:
	.DB $17
	.DW $60C9
	.DB $28, $50
SaffronGymYoungster2EndBattleText:
	.DB $17
	.DW $60F1
	.DB $28, $50
SaffronGymYoungster2AfterBattleText:
	.DB $17
	.DW $6107
	.DB $28, $50
SaffronGymChanneler3BattleText:
	.DB $17
	.DW $613C
	.DB $28, $50
SaffronGymChanneler3EndBattleText:
	.DB $17
	.DW $615E
	.DB $28, $50
SaffronGymChanneler3AfterBattleText:
	.DB $17
	.DW $6171
	.DB $28, $50
SaffronGymYoungster3BattleText:
	.DB $17
	.DW $619C
	.DB $28, $50
SaffronGymYoungster3EndBattleText:
	.DB $17
	.DW $61E4
	.DB $28, $50
SaffronGymYoungster3AfterBattleText:
	.DB $17
	.DW $61FE
	.DB $28, $50
SaffronGymYoungster4BattleText:
	.DB $17
	.DW $6277
	.DB $28, $50
SaffronGymYoungster4EndBattleText:
	.DB $17
	.DW $62CA
	.DB $28, $50
SaffronGymYoungster4AfterBattleText:
	.DB $17
	.DW $62D3
	.DB $28, $50
SaffronGymTrainerRecordsEnd:
.ASSERT SaffronGymTrainerRecordsEnd - SaffronGymChanneler1BattleText == 105
