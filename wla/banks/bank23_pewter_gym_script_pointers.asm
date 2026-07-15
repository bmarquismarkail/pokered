; Pewter Gym map-script dispatch table.
PewterGym_ScriptPointers:
.DW $3219 ; CheckFightingMapTrainers
.DW $324C ; DisplayEnemyTrainerTextAndStartBattle
.DW $3275 ; EndTrainerBattle
.DW $43D2 ; PewterGymBrockPostBattle
PewterGymScriptPointersEnd:
.ASSERT PewterGymScriptPointersEnd - PewterGym_ScriptPointers == 8
