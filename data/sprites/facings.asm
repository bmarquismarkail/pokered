SpriteFacingAndAnimationTable:
; This table is used for overworld sprites $1-$9.
	.DW SpriteFacingAndAnimationTable.StandingDown, SpriteFacingAndAnimationTable.NormalOAM  ; facing down, walk animation frame 0
	.DW SpriteFacingAndAnimationTable.WalkingDown,  SpriteFacingAndAnimationTable.NormalOAM  ; facing down, walk animation frame 1
	.DW SpriteFacingAndAnimationTable.StandingDown, SpriteFacingAndAnimationTable.NormalOAM  ; facing down, walk animation frame 2
	.DW SpriteFacingAndAnimationTable.WalkingDown,  SpriteFacingAndAnimationTable.FlippedOAM ; facing down, walk animation frame 3
	.DW SpriteFacingAndAnimationTable.StandingUp,   SpriteFacingAndAnimationTable.NormalOAM  ; facing up, walk animation frame 0
	.DW SpriteFacingAndAnimationTable.WalkingUp,    SpriteFacingAndAnimationTable.NormalOAM  ; facing up, walk animation frame 1
	.DW SpriteFacingAndAnimationTable.StandingUp,   SpriteFacingAndAnimationTable.NormalOAM  ; facing up, walk animation frame 2
	.DW SpriteFacingAndAnimationTable.WalkingUp,    SpriteFacingAndAnimationTable.FlippedOAM ; facing up, walk animation frame 3
	.DW SpriteFacingAndAnimationTable.StandingLeft, SpriteFacingAndAnimationTable.NormalOAM  ; facing left, walk animation frame 0
	.DW SpriteFacingAndAnimationTable.WalkingLeft,  SpriteFacingAndAnimationTable.NormalOAM  ; facing left, walk animation frame 1
	.DW SpriteFacingAndAnimationTable.StandingLeft, SpriteFacingAndAnimationTable.NormalOAM  ; facing left, walk animation frame 2
	.DW SpriteFacingAndAnimationTable.WalkingLeft,  SpriteFacingAndAnimationTable.NormalOAM  ; facing left, walk animation frame 3
	.DW SpriteFacingAndAnimationTable.StandingLeft, SpriteFacingAndAnimationTable.FlippedOAM ; facing right, walk animation frame 0
	.DW SpriteFacingAndAnimationTable.WalkingLeft,  SpriteFacingAndAnimationTable.FlippedOAM ; facing right, walk animation frame 1
	.DW SpriteFacingAndAnimationTable.StandingLeft, SpriteFacingAndAnimationTable.FlippedOAM ; facing right, walk animation frame 2
	.DW SpriteFacingAndAnimationTable.WalkingLeft,  SpriteFacingAndAnimationTable.FlippedOAM ; facing right, walk animation frame 3
; The rest of this table is used for sprites $a and $b.
; All orientation and animation parameters lead to the same result.
; Used for immobile sprites like items on the ground.
	.DW SpriteFacingAndAnimationTable.StandingDown, SpriteFacingAndAnimationTable.NormalOAM  ; facing down, walk animation frame 0
	.DW SpriteFacingAndAnimationTable.StandingDown, SpriteFacingAndAnimationTable.NormalOAM  ; facing down, walk animation frame 1
	.DW SpriteFacingAndAnimationTable.StandingDown, SpriteFacingAndAnimationTable.NormalOAM  ; facing down, walk animation frame 2
	.DW SpriteFacingAndAnimationTable.StandingDown, SpriteFacingAndAnimationTable.NormalOAM  ; facing down, walk animation frame 3
	.DW SpriteFacingAndAnimationTable.StandingDown, SpriteFacingAndAnimationTable.NormalOAM  ; facing up, walk animation frame 0
	.DW SpriteFacingAndAnimationTable.StandingDown, SpriteFacingAndAnimationTable.NormalOAM  ; facing up, walk animation frame 1
	.DW SpriteFacingAndAnimationTable.StandingDown, SpriteFacingAndAnimationTable.NormalOAM  ; facing up, walk animation frame 2
	.DW SpriteFacingAndAnimationTable.StandingDown, SpriteFacingAndAnimationTable.NormalOAM  ; facing up, walk animation frame 3
	.DW SpriteFacingAndAnimationTable.StandingDown, SpriteFacingAndAnimationTable.NormalOAM  ; facing left, walk animation frame 0
	.DW SpriteFacingAndAnimationTable.StandingDown, SpriteFacingAndAnimationTable.NormalOAM  ; facing left, walk animation frame 1
	.DW SpriteFacingAndAnimationTable.StandingDown, SpriteFacingAndAnimationTable.NormalOAM  ; facing left, walk animation frame 2
	.DW SpriteFacingAndAnimationTable.StandingDown, SpriteFacingAndAnimationTable.NormalOAM  ; facing left, walk animation frame 3
	.DW SpriteFacingAndAnimationTable.StandingDown, SpriteFacingAndAnimationTable.NormalOAM  ; facing right, walk animation frame 0
	.DW SpriteFacingAndAnimationTable.StandingDown, SpriteFacingAndAnimationTable.NormalOAM  ; facing right, walk animation frame 1
	.DW SpriteFacingAndAnimationTable.StandingDown, SpriteFacingAndAnimationTable.NormalOAM  ; facing right, walk animation frame 2
	.DW SpriteFacingAndAnimationTable.StandingDown, SpriteFacingAndAnimationTable.NormalOAM  ; facing right, walk animation frame 3

; four tile ids compose an overworld sprite
SpriteFacingAndAnimationTable.StandingDown: .DB $00, $01, $02, $03
SpriteFacingAndAnimationTable.WalkingDown: .DB $80, $81, $82, $83
SpriteFacingAndAnimationTable.StandingUp: .DB $04, $05, $06, $07
SpriteFacingAndAnimationTable.WalkingUp: .DB $84, $85, $86, $87
SpriteFacingAndAnimationTable.StandingLeft: .DB $08, $09, $0a, $0b
SpriteFacingAndAnimationTable.WalkingLeft: .DB $88, $89, $8a, $8b

SpriteFacingAndAnimationTable.NormalOAM:
	; y, x, attributes
	.DB 0, 0, $00 ; top left
	.DB 0, 8, $00 ; top right
	.DB 8, 0, UNDER_GRASS ; bottom left
	.DB 8, 8, UNDER_GRASS | FACING_END ; bottom right

SpriteFacingAndAnimationTable.FlippedOAM:
	; y, x, attributes
	.DB 0, 8, OAM_XFLIP ; top left
	.DB 0, 0, OAM_XFLIP ; top right
	.DB 8, 8, OAM_XFLIP | UNDER_GRASS ; bottom left
	.DB 8, 0, OAM_XFLIP | UNDER_GRASS | FACING_END ; bottom right
