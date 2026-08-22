CinnabarLabFossilRoom_Script:
	jp EnableAutoTextBoxDrawing

CinnabarLabFossilRoom_TextPointers:
	def_text_pointers
	dw_const CinnabarLabFossilRoomScientist1Text, TEXT_CINNABARLABFOSSILROOM_SCIENTIST1
	dw_const CinnabarLabFossilRoomScientist2Text, TEXT_CINNABARLABFOSSILROOM_SCIENTIST2

Lab4Script_GetFossilsInBag:
; construct a list of all fossils in the player's bag
	xor a
	ld [wFilteredBagItemsCount], a
	ld de, wFilteredBagItems
	ld hl, FossilsList
Lab4Script_GetFossilsInBag.loop
	ld a, [hli]
	and a
	jr z, Lab4Script_GetFossilsInBag.done
	push hl
	push de
	ld [wTempByteValue], a
	ld b, a
	predef GetQuantityOfItemInBag
	pop de
	pop hl
	ld a, b
	and a
	jr z, Lab4Script_GetFossilsInBag.loop
	; A fossil is in the bag
	ld a, [wTempByteValue]
	ld [de], a
	inc de
	push hl
	ld hl, wFilteredBagItemsCount
	inc [hl]
	pop hl
	jr Lab4Script_GetFossilsInBag.loop
Lab4Script_GetFossilsInBag.done
	ld a, $ff
	ld [de], a
	ret

FossilsList:
	.DB DOME_FOSSIL
	.DB HELIX_FOSSIL
	.DB OLD_AMBER
	.DB 0 ; end

CinnabarLabFossilRoomScientist1Text:
	text_asm
	CheckEvent EVENT_GAVE_FOSSIL_TO_LAB
	jr nz, CinnabarLabFossilRoomScientist1Text.check_done_reviving
	ld hl, CinnabarLabFossilRoomScientist1Text.Text
	call PrintText
	call Lab4Script_GetFossilsInBag
	ld a, [wFilteredBagItemsCount]
	and a
	jr z, CinnabarLabFossilRoomScientist1Text.no_fossils
	farcall GiveFossilToCinnabarLab
	jr CinnabarLabFossilRoomScientist1Text.done
CinnabarLabFossilRoomScientist1Text.no_fossils
	ld hl, CinnabarLabFossilRoomScientist1Text.NoFossilsText
	call PrintText
CinnabarLabFossilRoomScientist1Text.done
	jp TextScriptEnd
CinnabarLabFossilRoomScientist1Text.check_done_reviving
	CheckEventAfterBranchReuseA EVENT_LAB_STILL_REVIVING_FOSSIL, EVENT_GAVE_FOSSIL_TO_LAB
	jr z, CinnabarLabFossilRoomScientist1Text.done_reviving
	ld hl, CinnabarLabFossilRoomScientist1Text.GoForAWalkText
	call PrintText
	jr CinnabarLabFossilRoomScientist1Text.done
CinnabarLabFossilRoomScientist1Text.done_reviving
	call LoadFossilItemAndMonNameBank1D
	ld hl, CinnabarLabFossilRoomScientist1Text.FossilIsBackToLifeText
	call PrintText
	SetEvent EVENT_LAB_HANDING_OVER_FOSSIL_MON
	ld a, [wFossilMon]
	ld b, a
	ld c, 30
	call GivePokemon
	jr nc, CinnabarLabFossilRoomScientist1Text.done
	ResetEvents EVENT_GAVE_FOSSIL_TO_LAB, EVENT_LAB_STILL_REVIVING_FOSSIL, EVENT_LAB_HANDING_OVER_FOSSIL_MON
	jr CinnabarLabFossilRoomScientist1Text.done

CinnabarLabFossilRoomScientist1Text.Text:
	text_far WLA_GLOBAL_CinnabarLabFossilRoomScientist1Text
	text_end

CinnabarLabFossilRoomScientist1Text.NoFossilsText:
	text_far WLA_GLOBAL_CinnabarLabFossilRoomScientist1NoFossilsText
	text_end

CinnabarLabFossilRoomScientist1Text.GoForAWalkText:
	text_far WLA_GLOBAL_CinnabarLabFossilRoomScientist1GoForAWalkText
	text_end

CinnabarLabFossilRoomScientist1Text.FossilIsBackToLifeText:
	text_far WLA_GLOBAL_CinnabarLabFossilRoomScientist1FossilIsBackToLifeText
	text_end

CinnabarLabFossilRoomScientist2Text:
	text_asm
	ld a, TRADE_FOR_SAILOR
	ld [wWhichTrade], a
	predef DoInGameTradeDialogue
	jp TextScriptEnd

LoadFossilItemAndMonNameBank1D:
	farjp LoadFossilItemAndMonName
