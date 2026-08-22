; unique moves for gym leaders
; this is not automatic! you have to write the index you want to [wLoneAttackNo]
; first. e.g., erika's script writes 4 to [wLoneAttackNo] to get mega drain,
; the fourth entry in the list.
LoneMoves:
	; pokemon index, move to give nth pokemon
	.DB 1, BIDE
	.DB 1, BUBBLEBEAM
	.DB 2, THUNDERBOLT
	.DB 2, MEGA_DRAIN
	.DB 3, TOXIC
	.DB 3, PSYWAVE
	.DB 3, FIRE_BLAST
	.DB 4, FISSURE

; unique moves for elite 4
; all trainers in this class are given this move automatically
; (unrelated to LoneMoves)
TeamMoves:
	; trainer, move
	.DB LORELEI, BLIZZARD
	.DB BRUNO,   FISSURE
	.DB AGATHA,  TOXIC
	.DB LANCE,   BARRIER
	.DB -1 ; end
