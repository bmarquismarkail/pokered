CinnabarGymBlaineText:
	.DB $08 ; text_asm
	LD A, ($D79A)
	BIT 1, A ; EVENT_BEAT_BLAINE
	JR Z, CinnabarGymBlaineText.beforeBeat
	BIT 0, A ; EVENT_GOT_TM38
	JR NZ, CinnabarGymBlaineText.afterBeat
	CALL Z, CinnabarGymReceiveTM38
	CALL $30B6 ; DisableWaitingAfterTextDisplay
	JP $24D7 ; TextScriptEnd
CinnabarGymBlaineText.afterBeat:
	LD HL, CinnabarGymBlaineText.PostBattleAdviceText
	CALL $3C49 ; PrintText
	JP $24D7
CinnabarGymBlaineText.beforeBeat:
	LD HL, CinnabarGymBlaineText.PreBattleText
	CALL $3C49
	LD HL, CinnabarGymBlaineText.ReceivedVolcanoBadgeText
	LD DE, CinnabarGymBlaineText.ReceivedVolcanoBadgeText
	CALL $3354 ; SaveEndBattleTextPointers
	LD A, 7
	LD ($D05C), A ; wGymLeaderNo
	JP CinnabarGymStartBattleScript

CinnabarGymBlaineText.PreBattleText:
	.DB $17
	.DW $4844
	.DB $28,$50
CinnabarGymBlaineText.ReceivedVolcanoBadgeText:
	.DB $17
	.DW $48C7
	.DB $28,$11,$0D,$50
CinnabarGymBlaineText.PostBattleAdviceText:
	.DB $17
	.DW $48FD
	.DB $28,$50
CinnabarGymBlaineVolcanoBadgeInfoText:
	.DB $17
	.DW $4946
	.DB $28,$50
CinnabarGymBlaineReceivedTM38Text:
	.DB $17
	.DW $49A8
	.DB $28,$0B
CinnabarGymBlaineTM38ExplanationText:
	.DB $17
	.DW $49BC
	.DB $28,$50
CinnabarGymBlaineTM38NoRoomText:
	.DB $17
	.DW $4A1E
	.DB $28,$50
CinnabarGymBlaineTextEnd:
.ASSERT CinnabarGymBlaineTextEnd - CinnabarGymBlaineText == 90
