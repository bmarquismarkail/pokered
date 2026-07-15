; Brock's text-engine handler and its pre/post-battle text records.
PewterGymBrockText:
	.DB $08 ; text_asm
	LD A, ($D755) ; event flag byte
	BIT 7, A ; EVENT_BEAT_BROCK
	JR Z, PewterGymBrockText.beforeBeat
	BIT 6, A ; EVENT_GOT_TM34
	JR NZ, PewterGymBrockText.afterBeat
	CALL Z, PewterGymScriptReceiveTM34
	CALL $30B6 ; DisableWaitingAfterTextDisplay
	JR PewterGymBrockText.done
PewterGymBrockText.afterBeat:
	LD HL, PewterGymBrockText.PostBattleAdviceText
	CALL PrintText
	JR PewterGymBrockText.done
PewterGymBrockText.beforeBeat:
	LD HL, PewterGymBrockText.PreBattleText
	CALL PrintText
	LD HL, $D72D ; wStatusFlags3
	SET 6, (HL) ; BIT_TALKED_TO_TRAINER
	SET 7, (HL) ; BIT_PRINT_END_BATTLE_TEXT
	LD HL, $44BC ; PewterGymBrockReceivedBoulderBadgeText
	LD DE, $44BC
	CALL $3354 ; SaveEndBattleTextPointers
	LDH A, ($8C) ; hSpriteIndex
	LD ($CF13), A ; wSpriteIndex
	CALL $336A ; EngageMapTrainer
	CALL $32D7 ; InitBattleEnemyParameters
	LD A, $01
	LD ($D05C), A ; wGymLeaderNo
	XOR A
	LDH ($B4), A ; hJoyHeld
	LD A, $03 ; SCRIPT_PEWTERGYM_BROCK_POST_BATTLE
	LD ($D5FC), A ; wPewterGymCurScript
	LD ($DA39), A ; wCurMapScript
PewterGymBrockText.done:
	JP $24D7 ; TextScriptEnd

PewterGymBrockText.PreBattleText:
	.DB $17
	.DW $697A ; _PewterGymBrockPreBattleText
	.DB $25, $50
PewterGymBrockText.PostBattleAdviceText:
	.DB $17
	.DW $4000 ; _PewterGymBrockPostBattleAdviceText
	.DB $26, $50
PewterGymBrockTextEnd:
.ASSERT PewterGymBrockTextEnd - PewterGymBrockText == 90
