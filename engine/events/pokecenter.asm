DisplayPokemonCenterDialogue_:
	call SaveScreenTilesToBuffer1 ; save screen
	ld hl, PokemonCenterWelcomeText
	call PrintText
	ld hl, wStatusFlags4
	bit BIT_USED_POKECENTER, [hl]
	set BIT_UNKNOWN_4_1, [hl]
	set BIT_USED_POKECENTER, [hl]
	jr nz, DisplayPokemonCenterDialogue_.skipShallWeHealYourPokemon
	ld hl, ShallWeHealYourPokemonText
	call PrintText
DisplayPokemonCenterDialogue_.skipShallWeHealYourPokemon
	call YesNoChoicePokeCenter ; yes/no menu
	ld a, [wCurrentMenuItem]
	and a
	jr nz, DisplayPokemonCenterDialogue_.declinedHealing ; if the player chose No
	call SetLastBlackoutMap
	call LoadScreenTilesFromBuffer1 ; restore screen
	ld hl, NeedYourPokemonText
	call PrintText
	ld a, $18
	ld [wSprite01StateData1ImageIndex], a ; make the nurse turn to face the machine
	call Delay3
	predef HealParty
	farcall AnimateHealingMachine ; do the healing machine animation
	xor a
	ld [wAudioFadeOutControl], a
	ld a, [wAudioSavedROMBank]
	ld [wAudioROMBank], a
	ld a, [wMapMusicSoundID]
	ld [wLastMusicSoundID], a
	ld [wNewSoundID], a
	call PlaySound
	ld hl, PokemonFightingFitText
	call PrintText
	ld a, $14
	ld [wSprite01StateData1ImageIndex], a ; make the nurse bow
	ld c, a
	call DelayFrames
	jr DisplayPokemonCenterDialogue_.done
DisplayPokemonCenterDialogue_.declinedHealing
	call LoadScreenTilesFromBuffer1 ; restore screen
DisplayPokemonCenterDialogue_.done
	ld hl, PokemonCenterFarewellText
	call PrintText
	jp UpdateSprites

PokemonCenterWelcomeText:
	text_far WLA_GLOBAL_PokemonCenterWelcomeText
	text_end

ShallWeHealYourPokemonText:
	text_pause
	text_far WLA_GLOBAL_ShallWeHealYourPokemonText
	text_end

NeedYourPokemonText:
	text_far WLA_GLOBAL_NeedYourPokemonText
	text_end

PokemonFightingFitText:
	text_far WLA_GLOBAL_PokemonFightingFitText
	text_end

PokemonCenterFarewellText:
	text_pause
	text_far WLA_GLOBAL_PokemonCenterFarewellText
	text_end
