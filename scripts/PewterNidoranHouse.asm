PewterNidoranHouse_Script:
	jp EnableAutoTextBoxDrawing

PewterNidoranHouse_TextPointers:
	def_text_pointers
	dw_const PewterNidoranHouseNidoranText,       TEXT_PEWTERNIDORANHOUSE_NIDORAN
	dw_const PewterNidoranHouseLittleBoyText,     TEXT_PEWTERNIDORANHOUSE_LITTLE_BOY
	dw_const PewterNidoranHouseMiddleAgedManText, TEXT_PEWTERNIDORANHOUSE_MIDDLE_AGED_MAN

PewterNidoranHouseNidoranText:
	text_far WLA_GLOBAL_PewterNidoranHouseNidoranText
	text_asm
	ld a, NIDORAN_M
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd

PewterNidoranHouseLittleBoyText:
	text_far WLA_GLOBAL_PewterNidoranHouseLittleBoyText
	text_end

PewterNidoranHouseMiddleAgedManText:
	text_far WLA_GLOBAL_PewterNidoranHouseMiddleAgedManText
	text_end
