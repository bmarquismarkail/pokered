CeruleanGymMistyText:
	.DB $08
	LD A, ($D75E)
	BIT 7, A ; EVENT_BEAT_MISTY
	JR Z, CeruleanGymMistyText.beforeBeat
	BIT 6, A ; EVENT_GOT_TM11
	JR NZ, CeruleanGymMistyText.afterBeat
	CALL Z, CeruleanGymReceiveTM11
	CALL $30B6 ; DisableWaitingAfterTextDisplay
	JR CeruleanGymMistyText.done
CeruleanGymMistyText.afterBeat:
	LD HL, CeruleanGymMistyText.TM11ExplanationText
	CALL PrintText
	JR CeruleanGymMistyText.done
CeruleanGymMistyText.beforeBeat:
	LD HL, CeruleanGymMistyText.PreBattleText
	CALL PrintText
	LD HL, $D72D
	SET 6, (HL)
	SET 7, (HL)
	LD HL, $47D8 ; CeruleanGymMistyReceivedCascadeBadgeText
	LD DE, $47D8
	CALL $3354 ; SaveEndBattleTextPointers
	LDH A, ($8C)
	LD ($CF13), A
	CALL $336A ; EngageMapTrainer
	CALL $32D7 ; InitBattleEnemyParameters
	LD A, $02
	LD ($D05C), A ; wGymLeaderNo
	XOR A
	LDH ($B4), A
	LD A, $03
	LD ($D5FD), A ; wCeruleanGymCurScript
CeruleanGymMistyText.done:
	JP $24D7 ; TextScriptEnd
CeruleanGymMistyText.PreBattleText:
	.DB $17
	.DW $49C1
	.DB $26, $50
CeruleanGymMistyText.TM11ExplanationText:
	.DB $17
	.DW $4A7B
	.DB $26, $50
CeruleanGymMistyTextEnd:
.ASSERT CeruleanGymMistyTextEnd - CeruleanGymMistyText == 87
