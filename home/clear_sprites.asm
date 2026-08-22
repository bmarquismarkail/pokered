ClearSprites:
	xor a
	ld hl, wShadowOAM
	ld b, wShadowOAMEnd - wShadowOAM
ClearSprites.loop
	ld [hli], a
	dec b
	jr nz, ClearSprites.loop
	ret

HideSprites:
	ld a, SCREEN_HEIGHT_PX + OAM_Y_OFS
	ld hl, wShadowOAMSprite00YCoord
	ld de, OBJ_SIZE
	ld b, OAM_COUNT
HideSprites.loop
	ld [hl], a
	add hl, de
	dec b
	jr nz, HideSprites.loop
	ret
