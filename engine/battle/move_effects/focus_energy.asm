FocusEnergyEffect_:
	ld hl, wPlayerBattleStatus2
	ldh a, [lobyte(hWhoseTurn)]
	and a
	jr z, FocusEnergyEffect_.notEnemy
	ld hl, wEnemyBattleStatus2
FocusEnergyEffect_.notEnemy
	bit GETTING_PUMPED, [hl] ; is mon already using focus energy?
	jr nz, FocusEnergyEffect_.alreadyUsing
	set GETTING_PUMPED, [hl] ; mon is now using focus energy
	callfar PlayCurrentMoveAnimation
	ld hl, GettingPumpedText
	jp PrintText
FocusEnergyEffect_.alreadyUsing
	ld c, 50
	call DelayFrames
	jpfar PrintButItFailedText_

GettingPumpedText:
	text_pause
	text_far WLA_GLOBAL_GettingPumpedText
	text_end
