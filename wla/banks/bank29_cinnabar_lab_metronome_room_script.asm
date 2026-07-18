CinnabarLabMetronomeRoom_Script:
	JP $3C3C ; EnableAutoTextBoxDrawing
CinnabarLabMetronomeRoomScriptEnd:
.ASSERT CinnabarLabMetronomeRoomScriptEnd - CinnabarLabMetronomeRoom_Script == 3

CinnabarLabMetronomeRoom_TextPointers:
	.DW CinnabarLabMetronomeRoomScientist1Text,CinnabarLabMetronomeRoomScientist2Text
	.DW CinnabarLabMetronomeRoomPCText,CinnabarLabMetronomeRoomPCText,CinnabarLabMetronomeRoomAmberPipeText
CinnabarLabMetronomeRoomTextPointersEnd:
.ASSERT CinnabarLabMetronomeRoomTextPointersEnd - CinnabarLabMetronomeRoom_TextPointers == 10

CinnabarLabMetronomeRoomScientist1Text:
	.DB $08 ; text_asm
	LD A, ($D7A1)
	BIT 7, A ; EVENT_GOT_TM35
	JR NZ, CinnabarLabMetronomeRoomScientist1Text.gotItem
	LD HL, CinnabarLabMetronomeRoomScientist1Text.Text
	CALL $3C49 ; PrintText
	LD BC, $EB01 ; TM_METRONOME, 1
	CALL $3E2E ; GiveItem
	JR NC, CinnabarLabMetronomeRoomScientist1Text.bagFull
	LD HL, CinnabarLabMetronomeRoomScientist1Text.ReceivedTM35Text
	CALL $3C49 ; PrintText
	LD HL, $D7A1
	SET 7, (HL) ; EVENT_GOT_TM35
	JR CinnabarLabMetronomeRoomScientist1Text.done
CinnabarLabMetronomeRoomScientist1Text.bagFull:
	LD HL, CinnabarLabMetronomeRoomScientist1Text.TM35NoRoomText
	CALL $3C49 ; PrintText
	JR CinnabarLabMetronomeRoomScientist1Text.done
CinnabarLabMetronomeRoomScientist1Text.gotItem:
	LD HL, CinnabarLabMetronomeRoomScientist1Text.TM35ExplanationText
	CALL $3C49 ; PrintText
CinnabarLabMetronomeRoomScientist1Text.done:
	JP $24D7 ; TextScriptEnd
CinnabarLabMetronomeRoomScientist1Text.Text:
	.DB $17
	.DW $4F09
	.DB $28,$50
CinnabarLabMetronomeRoomScientist1Text.ReceivedTM35Text:
	.DB $17
	.DW $4F48
	.DB $28,$0B,$50
CinnabarLabMetronomeRoomScientist1Text.TM35ExplanationText:
	.DB $17
	.DW $4F5D
	.DB $28,$50
CinnabarLabMetronomeRoomScientist1Text.TM35NoRoomText:
	.DB $17
	.DW $4FC7
	.DB $28,$50
CinnabarLabMetronomeRoomScientist1End:
.ASSERT CinnabarLabMetronomeRoomScientist1End - CinnabarLabMetronomeRoomScientist1Text == 73

CinnabarLabMetronomeRoomScientist2Text:
	.DB $17
	.DW $4FE3
	.DB $28,$50
CinnabarLabMetronomeRoomPCText:
	.DB $17
	.DW $5010
	.DB $28,$50
CinnabarLabMetronomeRoomAmberPipeText:
	.DB $17
	.DW $50D8
	.DB $28,$50
CinnabarLabMetronomeRoomTextsEnd:
.ASSERT CinnabarLabMetronomeRoomTextsEnd - CinnabarLabMetronomeRoomScientist2Text == 15
