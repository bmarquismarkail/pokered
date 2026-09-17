; stores hl in [wTrainerHeaderPtr]
StoreTrainerHeaderPointer:
	ld a, h
	ld [wTrainerHeaderPtr], a
	ld a, l
	ld [wTrainerHeaderPtr+1], a
	ret

; executes the current map script from the function pointer array provided in de.
; a: map script index to execute (unless overridden by [wStatusFlags7] BIT_USE_CUR_MAP_SCRIPT)
; hl: trainer header pointer
ExecuteCurMapScriptInTable:
	push af
	push de
	call StoreTrainerHeaderPointer
	pop hl
	pop af
	push hl
	ld hl, wStatusFlags7
	bit BIT_USE_CUR_MAP_SCRIPT, [hl]
	res BIT_USE_CUR_MAP_SCRIPT, [hl]
	jr z, ExecuteCurMapScriptInTable.useProvidedIndex ; test if map script index was overridden manually
	ld a, [wCurMapScript]
ExecuteCurMapScriptInTable.useProvidedIndex
	pop hl
	ld [wCurMapScript], a
	call CallFunctionInTable
	ld a, [wCurMapScript]
	ret

LoadGymLeaderAndCityName:
	push de
	ld de, wGymCityName
	ld bc, GYM_CITY_LENGTH
	call CopyData ; load city name
	pop hl
	ld de, wGymLeaderName
	ld bc, NAME_LENGTH
	jp CopyData   ; load gym leader name

; reads specific information from trainer header (pointed to at wTrainerHeaderPtr)
; a: offset in header data
;    0 -> flag's bit (into wTrainerHeaderFlagBit)
;    2 -> flag's byte ptr (into hl)
;    4 -> before battle text (into hl)
;    6 -> after battle text (into hl)
;    8 -> end battle text (into hl)
ReadTrainerHeaderInfo:
	push de
	push af
	ld d, $0
	ld e, a
	ld hl, wTrainerHeaderPtr
	ld a, [hli]
	ld l, [hl]
	ld h, a
	add hl, de
	pop af
	and a
	jr nz, ReadTrainerHeaderInfo.nonZeroOffset
	ld a, [hl]
	ld [wTrainerHeaderFlagBit], a  ; store flag's bit
	jr ReadTrainerHeaderInfo.done
ReadTrainerHeaderInfo.nonZeroOffset
	cp $2
	jr z, ReadTrainerHeaderInfo.readPointer ; read flag's byte ptr
	cp $4
	jr z, ReadTrainerHeaderInfo.readPointer ; read before battle text
	cp $6
	jr z, ReadTrainerHeaderInfo.readPointer ; read after battle text
	cp $8
	jr z, ReadTrainerHeaderInfo.readPointer ; read end battle text
	cp $a
	jr nz, ReadTrainerHeaderInfo.done
	ld a, [hli]        ; read end battle text (2) but override the result afterwards (XXX why, bug?)
	ld d, [hl]
	ld e, a
	jr ReadTrainerHeaderInfo.done
ReadTrainerHeaderInfo.readPointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
ReadTrainerHeaderInfo.done
	pop de
	ret

TrainerFlagAction:
	predef_jump FlagActionPredef

TalkToTrainer:
	call StoreTrainerHeaderPointer
	xor a
	call ReadTrainerHeaderInfo     ; read flag's bit
	ld a, $2
	call ReadTrainerHeaderInfo     ; read flag's byte ptr
	ld a, [wTrainerHeaderFlagBit]
	ld c, a
	ld b, FLAG_TEST
	call TrainerFlagAction      ; read trainer's flag
	ld a, c
	and a
	jr z, TalkToTrainer.trainerNotYetFought     ; test trainer's flag
	ld a, $6
	call ReadTrainerHeaderInfo     ; print after battle text
	jp PrintText
TalkToTrainer.trainerNotYetFought
	ld a, $4
	call ReadTrainerHeaderInfo     ; print before battle text
	call PrintText
	ld a, $a
	call ReadTrainerHeaderInfo     ; (?) does nothing apparently (maybe bug in ReadTrainerHeaderInfo)
	push de
	ld a, $8
	call ReadTrainerHeaderInfo     ; read end battle text
	pop de
	call SaveEndBattleTextPointers
	ld hl, wStatusFlags7
	set BIT_USE_CUR_MAP_SCRIPT, [hl] ; activate map script index override (index is set below)
	ld hl, wMiscFlags
	bit BIT_SEEN_BY_TRAINER, [hl]  ; test if player is already engaging the trainer (because the trainer saw the player)
	ret nz
; if the player talked to the trainer of his own volition
	call EngageMapTrainer
	ld hl, wCurMapScript
	inc [hl]      ; increment map script index before StartTrainerBattle increments it again (next script function is usually EndTrainerBattle)
	jp StartTrainerBattle

; checks if any trainers are seeing the player and wanting to fight
CheckFightingMapTrainers:
.IF defined(_DEBUG)
	call DebugPressedOrHeldB
	jr nz, CheckFightingMapTrainers.trainerNotEngaging
.ENDIF
	call CheckForEngagingTrainers
	ld a, [wSpriteIndex]
	cp $ff
	jr nz, CheckFightingMapTrainers.trainerEngaging
.IF defined(_DEBUG)
CheckFightingMapTrainers.trainerNotEngaging
.ENDIF
	xor a
	ld [wSpriteIndex], a
	ld [wTrainerHeaderFlagBit], a
	ret
CheckFightingMapTrainers.trainerEngaging
	ld hl, wStatusFlags7
	set BIT_TRAINER_BATTLE, [hl]
	ld [wEmotionBubbleSpriteIndex], a
	xor a ; EXCLAMATION_BUBBLE
	ld [wWhichEmotionBubble], a
	predef EmotionBubble
	ld a, PAD_CTRL_PAD
	ld [wJoyIgnore], a
	xor a
	ldh [lobyte(hJoyHeld)], a
	call TrainerWalkUpToPlayer_Bank0
	ld hl, wCurMapScript
	inc [hl] ; increment map script index (next script function is usually DisplayEnemyTrainerTextAndStartBattle)
	ret

; display the before battle text after the enemy trainer has walked up to the player's sprite
DisplayEnemyTrainerTextAndStartBattle:
	ld a, [wStatusFlags5]
	and 1 << BIT_SCRIPTED_NPC_MOVEMENT
	ret nz ; return if the enemy trainer hasn't finished walking to the player's sprite
	ld [wJoyIgnore], a
	ld a, [wSpriteIndex]
	ldh [lobyte(hSpriteIndex)], a
	call DisplayTextID
	; fall through

StartTrainerBattle:
	xor a
	ld [wJoyIgnore], a
	call InitBattleEnemyParameters
	ld hl, wStatusFlags3
	set BIT_TALKED_TO_TRAINER, [hl]
	set BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, wStatusFlags4
	set BIT_UNKNOWN_4_1, [hl]
	ld hl, wCurMapScript
	inc [hl] ; increment map script index (next script function is usually EndTrainerBattle)
	ret

EndTrainerBattle:
	ld hl, wCurrentMapScriptFlags
	set BIT_CUR_MAP_LOADED_1, [hl]
	set BIT_CUR_MAP_LOADED_2, [hl]
	ld hl, wStatusFlags3
	res BIT_PRINT_END_BATTLE_TEXT, [hl]
	ld hl, wMiscFlags
	res BIT_SEEN_BY_TRAINER, [hl] ; player is no longer engaged by any trainer
	ld a, [wIsInBattle]
	cp $ff
	jp z, ResetButtonPressedAndMapScript
	ld a, $2
	call ReadTrainerHeaderInfo
	ld a, [wTrainerHeaderFlagBit]
	ld c, a
	ld b, FLAG_SET
	call TrainerFlagAction   ; flag trainer as fought
	ld a, [wEnemyMonOrTrainerClass]
	cp OPP_ID_OFFSET
	jr nc, EndTrainerBattle.skipRemoveSprite ; test if trainer was fought (in that case skip removing the corresponding sprite)
	ld hl, wToggleableObjectList
	ld de, $2
	ld a, [wSpriteIndex]
	call IsInArray ; search for sprite ID
	inc hl
	ld a, [hl]
	ld [wToggleableObjectIndex], a ; load corresponding toggleable object index and remove it
	predef HideObject
EndTrainerBattle.skipRemoveSprite
	ld hl, wStatusFlags5
	bit BIT_UNKNOWN_5_4, [hl]
	res BIT_UNKNOWN_5_4, [hl]
	ret nz

ResetButtonPressedAndMapScript:
	xor a
	ld [wJoyIgnore], a
	ldh [lobyte(hJoyHeld)], a
	ldh [lobyte(hJoyPressed)], a
	ldh [lobyte(hJoyReleased)], a
	ld [wCurMapScript], a               ; reset battle status
	ret

; calls TrainerWalkUpToPlayer
TrainerWalkUpToPlayer_Bank0:
	farjp TrainerWalkUpToPlayer

; sets opponent type and mon set/lvl based on the engaging trainer data
InitBattleEnemyParameters:
	ld a, [wEngagedTrainerClass]
	ld [wCurOpponent], a
	ld [wEnemyMonOrTrainerClass], a
	cp OPP_ID_OFFSET
	ld a, [wEngagedTrainerSet]
	jr c, InitBattleEnemyParameters.noTrainer
	ld [wTrainerNo], a
	ret
InitBattleEnemyParameters.noTrainer
	ld [wCurEnemyLevel], a
	ret

GetSpritePosition1:
	ld hl, WLA_GLOBAL_GetSpritePosition1
	jr SpritePositionBankswitch

GetSpritePosition2:
	ld hl, WLA_GLOBAL_GetSpritePosition2
	jr SpritePositionBankswitch

SetSpritePosition1:
	ld hl, WLA_GLOBAL_SetSpritePosition1
	jr SpritePositionBankswitch

SetSpritePosition2:
	ld hl, WLA_GLOBAL_SetSpritePosition2
SpritePositionBankswitch:
	ld b, $15
	jp Bankswitch ; indirect jump to one of the four functions

CheckForEngagingTrainers:
	xor a
	call ReadTrainerHeaderInfo       ; read trainer flag's bit (unused)
	ld d, h                          ; store trainer header address in de
	ld e, l
CheckForEngagingTrainers.trainerLoop
	call StoreTrainerHeaderPointer   ; set trainer header pointer to current trainer
	ld a, [de]
	ld [wSpriteIndex], a             ; store trainer flag's bit
	ld [wTrainerHeaderFlagBit], a
	cp -1
	ret z
	ld a, $2
	call ReadTrainerHeaderInfo       ; read trainer flag's byte ptr
	ld b, FLAG_TEST
	ld a, [wTrainerHeaderFlagBit]
	ld c, a
	call TrainerFlagAction           ; read trainer flag
	ld a, c
	and a ; has the trainer already been defeated?
	jr nz, CheckForEngagingTrainers.continue
	push hl
	push de
	push hl
	xor a
	call ReadTrainerHeaderInfo       ; get trainer header pointer
	inc hl
	ld a, [hl]                       ; read trainer engage distance
	pop hl
	ld [wTrainerEngageDistance], a
	ld a, [wSpriteIndex]
	swap a
	ld [wTrainerSpriteOffset], a
	predef TrainerEngage
	pop de
	pop hl
	ld a, [wTrainerSpriteOffset]
	and a
	ret nz ; break if the trainer is engaging
CheckForEngagingTrainers.continue
	ld hl, $c
	add hl, de
	ld d, h
	ld e, l
	jr CheckForEngagingTrainers.trainerLoop

; hl = text if the player wins
; de = text if the player loses
SaveEndBattleTextPointers:
	ldh a, [lobyte(hLoadedROMBank)]
	ld [wEndBattleTextRomBank], a
	ld a, h
	ld [wEndBattleWinTextPointer], a
	ld a, l
	ld [wEndBattleWinTextPointer + 1], a
	ld a, d
	ld [wEndBattleLoseTextPointer], a
	ld a, e
	ld [wEndBattleLoseTextPointer + 1], a
	ret

; loads data of some trainer on the current map and plays pre-battle music
; [wSpriteIndex]: sprite ID of trainer who is engaged
EngageMapTrainer:
	ld hl, wMapSpriteExtraData
	ld d, $0
	ld a, [wSpriteIndex]
	dec a
	add a
	ld e, a
	add hl, de     ; seek to engaged trainer data
	ld a, [hli]    ; load trainer class
	ld [wEngagedTrainerClass], a
	ld a, [hl]     ; load trainer mon set
	ld [wEngagedTrainerSet], a
	jp PlayTrainerMusic

PrintEndBattleText:
	push hl
	ld hl, wStatusFlags3
	bit BIT_PRINT_END_BATTLE_TEXT, [hl]
	res BIT_PRINT_END_BATTLE_TEXT, [hl]
	pop hl
	ret z
	ldh a, [lobyte(hLoadedROMBank)]
	push af
	ld a, [wEndBattleTextRomBank]
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	push hl
	farcall SaveTrainerName
	ld hl, TrainerEndBattleText
	call PrintText
	pop hl
	pop af
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	farcall SetEnemyTrainerToStayAndFaceAnyDirection
	jp WaitForSoundToFinish

GetSavedEndBattleTextPointer:
	ld a, [wBattleResult]
	and a
	jr nz, GetSavedEndBattleTextPointer.lostBattle
; won battle
	ld a, [wEndBattleWinTextPointer]
	ld h, a
	ld a, [wEndBattleWinTextPointer + 1]
	ld l, a
	ret
GetSavedEndBattleTextPointer.lostBattle
	ld a, [wEndBattleLoseTextPointer]
	ld h, a
	ld a, [wEndBattleLoseTextPointer + 1]
	ld l, a
	ret

TrainerEndBattleText:
	text_far WLA_GLOBAL_TrainerNameText
	text_asm
	call GetSavedEndBattleTextPointer
	call TextCommandProcessor
	jp TextScriptEnd

; only engage with the trainer if the player is not already
; engaged with another trainer
; XXX unused?
CheckIfAlreadyEngaged:
	ld a, [wMiscFlags]
	bit BIT_SEEN_BY_TRAINER, a
	ret nz
	call EngageMapTrainer
	xor a
	ret

PlayTrainerMusic:
	ld a, [wEngagedTrainerClass]
	cp OPP_RIVAL1
	ret z
	cp OPP_RIVAL2
	ret z
	cp OPP_RIVAL3
	ret z
	ld a, [wGymLeaderNo]
	and a
	ret nz
	xor a
	ld [wAudioFadeOutControl], a
	ld a, SFX_STOP_ALL_MUSIC
	call PlaySound
	ld a, bank(Music_MeetEvilTrainer)
	ld [wAudioROMBank], a
	ld [wAudioSavedROMBank], a
	ld a, [wEngagedTrainerClass]
	ld b, a
	ld hl, EvilTrainerList
PlayTrainerMusic.evilTrainerListLoop
	ld a, [hli]
	cp $ff
	jr z, PlayTrainerMusic.noEvilTrainer
	cp b
	jr nz, PlayTrainerMusic.evilTrainerListLoop
	ld a, MUSIC_MEET_EVIL_TRAINER
	jr PlayTrainerMusic.PlaySound
PlayTrainerMusic.noEvilTrainer
	ld hl, FemaleTrainerList
PlayTrainerMusic.femaleTrainerListLoop
	ld a, [hli]
	cp $ff
	jr z, PlayTrainerMusic.maleTrainer
	cp b
	jr nz, PlayTrainerMusic.femaleTrainerListLoop
	ld a, MUSIC_MEET_FEMALE_TRAINER
	jr PlayTrainerMusic.PlaySound
PlayTrainerMusic.maleTrainer
	ld a, MUSIC_MEET_MALE_TRAINER
PlayTrainerMusic.PlaySound
	ld [wNewSoundID], a
	jp PlaySound

.INCLUDE "data/trainers/encounter_types.asm"
