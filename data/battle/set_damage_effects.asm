SetDamageEffects:
; moves that do damage but not through normal calculations
; e.g., Super Fang, Psywave
	.DB SUPER_FANG_EFFECT
	.DB SPECIAL_DAMAGE_EFFECT
	.DB -1 ; end
