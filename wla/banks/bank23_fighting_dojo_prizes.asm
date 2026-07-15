FightingDojoHitmonleePokeBallText:
	.DB $08
	LD A, ($D7B1)
	AND $C0
	JR Z, FightingDojoHitmonleePokeBallText.GetMon
	LD HL, FightingDojoBetterNotGetGreedyText
	CALL PrintText
	JR FightingDojoHitmonleePokeBallText.done
FightingDojoHitmonleePokeBallText.GetMon:
	LD A, $2B
	CALL $349B
	LD HL, FightingDojoHitmonleePokeBallText.Text
	CALL PrintText
	CALL $35EC
	LD A, ($CC26)
	AND A
	JR NZ, FightingDojoHitmonleePokeBallText.done
	LD A, ($CF91)
	LD B, A
	LD C, 30
	CALL $3E48
	JR NC, FightingDojoHitmonleePokeBallText.done
	LD A, $4A
	LD ($CC4D), A
	LD A, $11
	CALL $3E6D
	LD HL, $D7B1
	SET 6, (HL)
	SET 0, (HL)
FightingDojoHitmonleePokeBallText.done:
	JP $24D7
FightingDojoHitmonleePokeBallText.Text:
	.DB $17
	.DW $5B4A
	.DB $28, $50
FightingDojoHitmonleeTextEnd:
.ASSERT FightingDojoHitmonleeTextEnd - FightingDojoHitmonleePokeBallText == 72

FightingDojoHitmonchanPokeBallText:
	.DB $08
	LD A, ($D7B1)
	AND $C0
	JR Z, FightingDojoHitmonchanPokeBallText.GetMon
	LD HL, FightingDojoBetterNotGetGreedyText
	CALL PrintText
	JR FightingDojoHitmonchanPokeBallText.done
FightingDojoHitmonchanPokeBallText.GetMon:
	LD A, $2C
	CALL $349B
	LD HL, FightingDojoHitmonchanPokeBallText.Text
	CALL PrintText
	CALL $35EC
	LD A, ($CC26)
	AND A
	JR NZ, FightingDojoHitmonchanPokeBallText.done
	LD A, ($CF91)
	LD B, A
	LD C, 30
	CALL $3E48
	JR NC, FightingDojoHitmonchanPokeBallText.done
	LD HL, $D7B1
	SET 7, (HL)
	SET 0, (HL)
	LD A, $4B
	LD ($CC4D), A
	LD A, $11
	CALL $3E6D
FightingDojoHitmonchanPokeBallText.done:
	JP $24D7
FightingDojoHitmonchanPokeBallText.Text:
	.DB $17
	.DW $5B70
	.DB $28, $50
FightingDojoHitmonchanTextEnd:
.ASSERT FightingDojoHitmonchanTextEnd - FightingDojoHitmonchanPokeBallText == 72

FightingDojoBetterNotGetGreedyText:
	.DB $17
	.DW $5B9A
	.DB $28, $50
FightingDojoPrizesEnd:
.ASSERT FightingDojoPrizesEnd - FightingDojoHitmonleePokeBallText == 149
