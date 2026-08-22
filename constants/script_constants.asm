; EmotionBubblesPointerTable indexes (see engine/overworld/emotion_bubbles.asm)
	const_def
	const EXCLAMATION_BUBBLE ; 0
	const QUESTION_BUBBLE    ; 1
	const SMILE_BUBBLE       ; 2

; slot symbols
.DEFINE SLOTS7 $0200
.DEFINE SLOTSBAR $0604
.DEFINE SLOTSCHERRY $0A08
.DEFINE SLOTSFISH $0E0C
.DEFINE SLOTSBIRD $1210
.DEFINE SLOTSMOUSE $1614

; StartSlotMachine dialogs
.DEFINE SLOTS_OUTOFORDER $fd
.DEFINE SLOTS_OUTTOLUNCH $fe
.DEFINE SLOTS_SOMEONESKEYS $ff

; in game trades
; TradeMons indexes (see data/events/trades.asm)
	const_def
	const TRADE_FOR_TERRY
	const TRADE_FOR_MARCEL
	const TRADE_FOR_CHIKUCHIKU ; unused
	const TRADE_FOR_SAILOR
	const TRADE_FOR_DUX
	const TRADE_FOR_MARC
	const TRADE_FOR_LOLA
	const TRADE_FOR_DORIS
	const TRADE_FOR_CRINKLES
	const TRADE_FOR_SPOT
.DEFINE NUM_NPC_TRADES const_value

; in game trade dialog sets
; InGameTradeTextPointers indexes (see engine/events/in_game_trades.asm)
	const_def
	const TRADE_DIALOGSET_CASUAL
	const TRADE_DIALOGSET_EVOLUTION
	const TRADE_DIALOGSET_HAPPY
.DEFINE NUM_TRADE_DIALOGSETS const_value

; OaksAideScript results
.DEFINE OAKS_AIDE_BAG_FULL $00
.DEFINE OAKS_AIDE_GOT_ITEM $01
.DEFINE OAKS_AIDE_NOT_ENOUGH_MONS $80
.DEFINE OAKS_AIDE_REFUSED $ff
