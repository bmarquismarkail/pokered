; Pseudo-OAM flags used by game logic
	const_def
	const BIT_END_OF_OAM_DATA    ; 0
	const BIT_SPRITE_UNDER_GRASS ; 1

; Used in SpriteFacingAndAnimationTable (see data/sprites/facings.asm)
.DEFINE FACING_END 1 << BIT_END_OF_OAM_DATA
.DEFINE UNDER_GRASS 1 << BIT_SPRITE_UNDER_GRASS
