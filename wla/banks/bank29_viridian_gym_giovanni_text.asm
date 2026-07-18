ViridianGymGiovanniText:
	.DB $08
	LD A, ($D751)
	BIT 1, A ; EVENT_BEAT_VIRIDIAN_GYM_GIOVANNI
	JR Z, ViridianGymGiovanniText.beforeBeat
	BIT 0, A ; EVENT_GOT_TM27
	JR NZ, ViridianGymGiovanniText.afterBeat
	CALL Z, ViridianGymReceiveTM27
	CALL $30B6 ; DisableWaitingAfterTextDisplay
	JR ViridianGymGiovanniText.text_script_end
ViridianGymGiovanniText.afterBeat:
	LD A, 1
	LD ($CC3C), A
	LD HL, ViridianGymGiovanniText.PostBattleAdviceText
	CALL $3C49
	CALL $20EF ; GBFadeOutToBlack
	LD A, $32 ; TOGGLE_VIRIDIAN_GYM_GIOVANNI
	LD ($CC4D), A
	LD A, $11 ; HideObject predef
	CALL $3E6D
	CALL $2429 ; UpdateSprites
	CALL $3DD7 ; Delay3
	CALL $20D1 ; GBFadeInFromBlack
	JR ViridianGymGiovanniText.text_script_end
ViridianGymGiovanniText.beforeBeat:
	LD HL, ViridianGymGiovanniText.PreBattleText
	CALL $3C49
	LD HL, $D72D ; wStatusFlags3
	SET 6, (HL)
	SET 7, (HL)
	LD HL, ViridianGymGiovanniText.ReceivedEarthBadgeText
	LD DE, ViridianGymGiovanniText.ReceivedEarthBadgeText
	CALL $3354 ; SaveEndBattleTextPointers
	LDH A, ($8C)
	LD ($CF13), A ; wSpriteIndex
	CALL $336A ; EngageMapTrainer
	CALL $32D7 ; InitBattleEnemyParameters
	LD A, 8
	LD ($D05C), A ; wGymLeaderNo
	LD A, 3
	LD ($D5FB), A
ViridianGymGiovanniText.text_script_end:
	JP $24D7
ViridianGymGiovanniText.PreBattleText:
	.DB $17
	.DW $5E09
	.DB $25,$50
ViridianGymGiovanniText.ReceivedEarthBadgeText:
	.DB $17
	.DW $5ED5
	.DB $25,$0B,$50
ViridianGymGiovanniText.PostBattleAdviceText:
	.DB $17
	.DW $5F2B
	.DB $25,$0D,$50
ViridianGymGiovanniEarthBadgeInfoText:
	.DB $17
	.DW $5FCC
	.DB $25,$50
ViridianGymGiovanniReceivedTM27Text:
	.DB $17
	.DW $6082
	.DB $25,$0B
ViridianGymGiovanniTM27ExplanationText:
	.DB $17
	.DW $6095
	.DB $25,$50
ViridianGymGiovanniTM27NoRoomText:
	.DB $17
	.DW $6104
	.DB $25,$50
ViridianGymGiovanniTextEnd:
.ASSERT ViridianGymGiovanniTextEnd - ViridianGymGiovanniText == 138
