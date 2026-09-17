FuchsiaGoodRodHouse_Script:
	jp EnableAutoTextBoxDrawing

FuchsiaGoodRodHouse_TextPointers:
	def_text_pointers
	dw_const FuchsiaGoodRodHouseFishingGuruText, TEXT_FUCHSIAGOODRODHOUSE_FISHING_GURU

FuchsiaGoodRodHouseFishingGuruText:
	text_asm
	ld a, [wStatusFlags1]
	bit BIT_GOT_GOOD_ROD, a
	jr nz, FuchsiaGoodRodHouseFishingGuruText.got_item
	ld hl, FuchsiaGoodRodHouseFishingGuruText.Text
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, FuchsiaGoodRodHouseFishingGuruText.refused
	lb "bc", GOOD_ROD, 1
	call GiveItem
	jr nc, FuchsiaGoodRodHouseFishingGuruText.bag_full
	ld hl, wStatusFlags1
	set BIT_GOT_GOOD_ROD, [hl]
	ld hl, FuchsiaGoodRodHouseFishingGuruText.ReceivedGoodRodText
	jr FuchsiaGoodRodHouseFishingGuruText.done
FuchsiaGoodRodHouseFishingGuruText.bag_full
	ld hl, FuchsiaGoodRodHouseFishingGuruText.NoRoomText
	jr FuchsiaGoodRodHouseFishingGuruText.done
FuchsiaGoodRodHouseFishingGuruText.refused
	ld hl, FuchsiaGoodRodHouseFishingGuruText.ThatsSoDisappointingText
	jr FuchsiaGoodRodHouseFishingGuruText.done
FuchsiaGoodRodHouseFishingGuruText.got_item
	ld hl, FuchsiaGoodRodHouseFishingGuruText.HowAreTheFishText
FuchsiaGoodRodHouseFishingGuruText.done
	call PrintText
	jp TextScriptEnd

FuchsiaGoodRodHouseFishingGuruText.Text:
	text_far WLA_GLOBAL_FuchsiaGoodRodHouseFishingGuruText
	text_end

FuchsiaGoodRodHouseFishingGuruText.ReceivedGoodRodText:
	text_far WLA_GLOBAL_FuchsiaGoodRodHouseFishingGuruReceivedGoodRodText
	sound_get_item_1
	text_end

FuchsiaGoodRodHouseFishingGuruText.UnusedText:
	para "つり　こそ"
	line "おとこの　ロマン　だ！"

	para "へぼいつりざおは"
	line "コイキングしか　つれ　なんだが"
	line "この　いいつりざおなら"
	line "もっと　いいもんが　つれるんじゃ！"
	done

FuchsiaGoodRodHouseFishingGuruText.ThatsSoDisappointingText:
	text_far WLA_GLOBAL_FuchsiaGoodRodHouseFishingGuruThatsSoDisappointingText
	text_end

FuchsiaGoodRodHouseFishingGuruText.HowAreTheFishText:
	text_far WLA_GLOBAL_FuchsiaGoodRodHouseFishingGuruHowAreTheFishText
	text_end

FuchsiaGoodRodHouseFishingGuruText.NoRoomText:
	text_far WLA_GLOBAL_FuchsiaGoodRodHouseFishingGuruNoRoomText
	text_end
