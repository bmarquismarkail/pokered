GetTrainerName_:
	ld hl, wLinkEnemyTrainerName
	ld a, [wLinkState]
	and a
	jr nz, GetTrainerName_.foundName
	ld hl, wRivalName
	ld a, [wTrainerClass]
	cp RIVAL1
	jr z, GetTrainerName_.foundName
	cp RIVAL2
	jr z, GetTrainerName_.foundName
	cp RIVAL3
	jr z, GetTrainerName_.foundName
	ld [wNameListIndex], a
	ld a, TRAINER_NAME
	ld [wNameListType], a
	ld a, bank(TrainerNames)
	ld [wPredefBank], a
	call GetName
	ld hl, wNameBuffer
GetTrainerName_.foundName
	ld de, wTrainerName
	ld bc, TRAINER_NAME_LENGTH
	jp CopyData
