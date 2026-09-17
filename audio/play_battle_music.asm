PlayBattleMusic:
	xor a
	ld [wAudioFadeOutControl], a
	ld [wLowHealthAlarm], a
	dec a ; SFX_STOP_ALL_MUSIC
	ld [wNewSoundID], a
	call PlaySound
	call DelayFrame
	ld c, bank(Music_GymLeaderBattle)
	ld a, [wGymLeaderNo]
	and a
	jr z, PlayBattleMusic.notGymLeaderBattle
	ld a, MUSIC_GYM_LEADER_BATTLE
	jr PlayBattleMusic.playSong
PlayBattleMusic.notGymLeaderBattle
	ld a, [wCurOpponent]
	cp OPP_ID_OFFSET
	jr c, PlayBattleMusic.wildBattle
	cp OPP_RIVAL3
	jr z, PlayBattleMusic.finalBattle
	cp OPP_LANCE
	jr nz, PlayBattleMusic.normalTrainerBattle
	ld a, MUSIC_GYM_LEADER_BATTLE ; lance also plays gym leader theme
	jr PlayBattleMusic.playSong
PlayBattleMusic.normalTrainerBattle
	ld a, MUSIC_TRAINER_BATTLE
	jr PlayBattleMusic.playSong
PlayBattleMusic.finalBattle
	ld a, MUSIC_FINAL_BATTLE
	jr PlayBattleMusic.playSong
PlayBattleMusic.wildBattle
	ld a, MUSIC_WILD_BATTLE
PlayBattleMusic.playSong
	jp PlayMusic
