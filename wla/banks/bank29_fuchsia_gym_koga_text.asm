FuchsiaGymKogaText:
	.DB $08 ; text_asm
	LD A, ($D792)
	BIT 1, A ; EVENT_BEAT_KOGA
	JR Z, FuchsiaGymKogaText.beforeBeat
	BIT 0, A ; EVENT_GOT_TM06
	JR NZ, FuchsiaGymKogaText.afterBeat
	CALL Z, FuchsiaGymReceiveTM06
	CALL $30B6 ; DisableWaitingAfterTextDisplay
	JR FuchsiaGymKogaText.done
FuchsiaGymKogaText.afterBeat:
	LD HL, FuchsiaGymKogaText.PostBattleAdviceText
	CALL $3C49 ; PrintText
	JR FuchsiaGymKogaText.done
FuchsiaGymKogaText.beforeBeat:
	LD HL, FuchsiaGymKogaText.BeforeBattleText
	CALL $3C49 ; PrintText
	LD HL, $D72D ; wStatusFlags3
	SET 6, (HL) ; BIT_TALKED_TO_TRAINER
	SET 7, (HL) ; BIT_PRINT_END_BATTLE_TEXT
	LD HL, FuchsiaGymKogaText.ReceivedSoulBadgeText
	LD DE, FuchsiaGymKogaText.ReceivedSoulBadgeText
	CALL $3354 ; SaveEndBattleTextPointers
	LDH A, ($8C) ; hSpriteIndex
	LD ($CF13), A ; wSpriteIndex
	CALL $336A ; EngageMapTrainer
	CALL $32D7 ; InitBattleEnemyParameters
	LD A, 5
	LD ($D05C), A ; wGymLeaderNo
	XOR A
	LDH ($B4), A ; hJoyHeld
	LD A, 3 ; SCRIPT_FUCHSIAGYM_KOGA_POST_BATTLE
	LD ($D65B), A ; wFuchsiaGymCurScript
FuchsiaGymKogaText.done:
	JP $24D7 ; TextScriptEnd

FuchsiaGymKogaText.BeforeBattleText:
	.DB $17
	.DW $69B1
	.DB $27,$50
FuchsiaGymKogaText.ReceivedSoulBadgeText:
	.DB $17
	.DW $6A66
	.DB $27,$50
FuchsiaGymKogaText.PostBattleAdviceText:
	.DB $17
	.DW $4000
	.DB $28,$50
FuchsiaGymKogaSoulBadgeInfoText:
	.DB $17
	.DW $4069
	.DB $28,$50
FuchsiaGymKogaReceivedTM06Text:
	.DB $17
	.DW $40EB
	.DB $28,$11
FuchsiaGymKogaTM06ExplanationText:
	.DB $17
	.DW $40FF
	.DB $28,$50
FuchsiaGymKogaTM06NoRoomText:
	.DB $17
	.DW $4143
	.DB $28,$50
FuchsiaGymKogaTextEnd:
.ASSERT FuchsiaGymKogaTextEnd - FuchsiaGymKogaText == 112
