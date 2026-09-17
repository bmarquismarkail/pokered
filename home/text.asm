TextBoxBorder:
; Draw a c×b text box at hl.

	; top row
	push hl
	ld a, $79
	ld [hli], a
	inc a ; "─"
	call TextBoxBorder.PlaceChars
	inc a ; "┐"
	ld [hl], a
	pop hl

	ld de, SCREEN_WIDTH
	add hl, de

	; middle rows
TextBoxBorder.next
	push hl
	ld a, $7c
	ld [hli], a
	ld a, $7f
	call TextBoxBorder.PlaceChars
	ld [hl], $7c
	pop hl

	ld de, SCREEN_WIDTH
	add hl, de
	dec b
	jr nz, TextBoxBorder.next

	; bottom row
	ld a, $7d
	ld [hli], a
	ld a, $7a
	call TextBoxBorder.PlaceChars
	ld [hl], $7e
	ret

TextBoxBorder.PlaceChars:
; Place char a c times.
	ld d, c
TextBoxBorder.loop
	ld [hli], a
	dec d
	jr nz, TextBoxBorder.loop
	ret

PlaceString:
	push hl

PlaceNextChar:
	ld a, [de]
	cp $50
	jr nz, PlaceNextChar.NotTerminator
	ld b, h
	ld c, l
	pop hl
	ret

PlaceNextChar.NotTerminator
	cp $4e
	jr nz, PlaceNextChar.NotNext
	ld bc, 2 * SCREEN_WIDTH
	ldh a, [lobyte(hUILayoutFlags)]
	bit BIT_SINGLE_SPACED_LINES, a
	jr z, PlaceNextChar.ok
	ld bc, SCREEN_WIDTH
PlaceNextChar.ok
	pop hl
	add hl, bc
	push hl
	jp NextChar

PlaceNextChar.NotNext
	cp $4f
	jr nz, PlaceNextChar.NotLine
	pop hl
	hlcoord 1, 16
	push hl
	jp NextChar

PlaceNextChar.NotLine

; Check against a dictionary
	dict $00,    NullChar
	dict $4c,  WLA_GLOBAL_ContTextNoPause
	dict $4b,   WLA_GLOBAL_ContText
	dict $51,    Paragraph
	dict $49,    PageChar
	dict $52,  PrintPlayerName
	dict $53,   PrintRivalName
	dict $54,         PlacePOKe
	dict $5b,      PCChar
	dict $5e,  RocketChar
	dict $5c,      TMChar
	dict $5d, TrainerChar
	dict $55,    ContText
	dict $56,      SixDotsChar
	dict $57,    DoneText
	dict $58,  PromptText
	dict $4a,    PlacePKMN
	dict $5f,  PlaceDexEnd
	dict $59,  PlaceMoveTargetsName
	dict $5a,    PlaceMoveUsersName

	ld [hli], a
	call PrintLetterDelay

NextChar:
	inc de
	jp PlaceNextChar

NullChar:
	ld b, h
	ld c, l
	pop hl
	; A "<NULL>" character in a printed string
	; displays an error message with the current value
	; of hTextID in decimal format.
	; This is a debugging leftover.
	ld de, TextIDErrorText
	dec de
	ret

TextIDErrorText: ; "[hTextID] ERROR."
	text_far WLA_GLOBAL_TextIDErrorText
	text_end

.MACRO print_name
	push de
	ld de, \1
	jr PlaceCommandCharacter
.ENDM

PrintPlayerName: print_name wPlayerName
PrintRivalName:  print_name wRivalName

TrainerChar: print_name TrainerCharText
TMChar:      print_name TMCharText
PCChar:      print_name PCCharText
RocketChar:  print_name RocketCharText
PlacePOKe:   print_name PlacePOKeText
SixDotsChar: print_name SixDotsCharText
PlacePKMN:   print_name PlacePKMNText

PlaceMoveTargetsName:
	ldh a, [lobyte(hWhoseTurn)]
	xor 1
	jr PlaceMoveUsersName.place

PlaceMoveUsersName:
	ldh a, [lobyte(hWhoseTurn)]

PlaceMoveUsersName.place:
	push de
	and a
	jr nz, PlaceMoveUsersName.enemy

	ld de, wBattleMonNick
	jr PlaceCommandCharacter

PlaceMoveUsersName.enemy
	ld de, EnemyText
	call PlaceString
	ld h, b
	ld l, c
	ld de, wEnemyMonNick
	; fallthrough

PlaceCommandCharacter:
	call PlaceString
	ld h, b
	ld l, c
	pop de
	inc de
	jp PlaceNextChar

TMCharText:
	.STRINGMAP pokemon, "TM@"
TrainerCharText:
	.STRINGMAP pokemon, "TRAINER@"
PCCharText:
	.STRINGMAP pokemon, "PC@"
RocketCharText:
	.STRINGMAP pokemon, "ROCKET@"
PlacePOKeText:
	.STRINGMAP pokemon, "POKé@"
SixDotsCharText:
	.STRINGMAP pokemon, "……@"
EnemyText:
	.STRINGMAP pokemon, "Enemy @"
PlacePKMNText:
	.STRINGMAP pokemon, "<PK><MN>@"

ContText:
	push de
	ld b, h
	ld c, l
	ld hl, ContCharText
	call TextCommandProcessor
	ld h, b
	ld l, c
	pop de
	inc de
	jp PlaceNextChar

ContCharText:
	text_far WLA_GLOBAL_ContCharText
	text_end

PlaceDexEnd:
	ld [hl], $e8
	pop hl
	ret

PromptText:
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jp z, PromptText.ok
	ld a, $ee
	ldcoord_a 18, 16
PromptText.ok
	call ProtectedDelay3
	call ManualTextScroll
	ld a, $7f
	ldcoord_a 18, 16

DoneText:
	pop hl
	ld de, DoneText.stop
	dec de
	ret

DoneText.stop:
	text_end

Paragraph:
	push de
	ld a, $ee
	ldcoord_a 18, 16
	call ProtectedDelay3
	call ManualTextScroll
	hlcoord 1, 13
	lb "bc", 4, 18
	call ClearScreenArea
	ld c, 20
	call DelayFrames
	pop de
	hlcoord 1, 14
	jp NextChar

PageChar:
	push de
	ld a, $ee
	ldcoord_a 18, 16
	call ProtectedDelay3
	call ManualTextScroll
	hlcoord 1, 10
	lb "bc", 7, 18
	call ClearScreenArea
	ld c, 20
	call DelayFrames
	pop de
	pop hl
	hlcoord 1, 11
	push hl
	jp NextChar

_ContText:
WLA_GLOBAL_ContText:
	ld a, $ee
	ldcoord_a 18, 16
	call ProtectedDelay3
	push de
	call ManualTextScroll
	pop de
	ld a, $7f
	ldcoord_a 18, 16
_ContTextNoPause:
WLA_GLOBAL_ContTextNoPause:
	push de
	call ScrollTextUpOneLine
	call ScrollTextUpOneLine
	hlcoord 1, 16
	pop de
	jp NextChar

; move both rows of text in the normal text box up one row
; always called twice in a row
; first time, copy the two rows of text to the "in between" rows that are usually empty
; second time, copy the bottom row of text into the top row of text
ScrollTextUpOneLine:
	hlcoord 0, 14 ; top row of text
	decoord 0, 13 ; empty line above text
	ld b, SCREEN_WIDTH * 3
ScrollTextUpOneLine.copyText
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, ScrollTextUpOneLine.copyText
	hlcoord 1, 16
	ld a, $7f
	ld b, SCREEN_WIDTH - 2
ScrollTextUpOneLine.clearText
	ld [hli], a
	dec b
	jr nz, ScrollTextUpOneLine.clearText

	ld b, 5
ScrollTextUpOneLine.WaitFrame
	call DelayFrame
	dec b
	jr nz, ScrollTextUpOneLine.WaitFrame

	ret

ProtectedDelay3:
	push bc
	call Delay3
	pop bc
	ret

TextCommandProcessor:
	ld a, [wLetterPrintingDelayFlags]
	push af
	set BIT_TEXT_DELAY, a
	ld e, a
	ldh a, [lobyte(hClearLetterPrintingDelayFlags)]
	xor e
	ld [wLetterPrintingDelayFlags], a
	ld a, c
	ld [wTextDest], a
	ld a, b
	ld [wTextDest + 1], a

NextTextCommand:
	ld a, [hli]
	cp TX_END
	jr nz, NextTextCommand.TextCommand
	pop af
	ld [wLetterPrintingDelayFlags], a
	ret

NextTextCommand.TextCommand:
	push hl
	cp TX_FAR
	jp z, TextCommand_FAR
	cp TX_SOUND_POKEDEX_RATING
	jp nc, TextCommand_SOUND
	ld hl, TextCommandJumpTable
	push bc
	add a
	ld b, 0
	ld c, a
	add hl, bc
	pop bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

TextCommand_BOX:
; draw a box (height, width)
	pop hl
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	push hl
	ld h, d
	ld l, e
	call TextBoxBorder
	pop hl
	jr NextTextCommand

TextCommand_START:
; write text until "@"
	pop hl
	ld d, h
	ld e, l
	ld h, b
	ld l, c
	call PlaceString
	ld h, d
	ld l, e
	inc hl
	jr NextTextCommand

TextCommand_RAM:
; write text from a ram address (little endian)
	pop hl
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	push hl
	ld h, b
	ld l, c
	call PlaceString
	pop hl
	jr NextTextCommand

TextCommand_BCD:
; write bcd from address, typically ram
	pop hl
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	push hl
	ld h, b
	ld l, c
	ld c, a
	call PrintBCDNumber
	ld b, h
	ld c, l
	pop hl
	jr NextTextCommand

TextCommand_MOVE:
; move to a new tile
	pop hl
	ld a, [hli]
	ld [wTextDest], a
	ld c, a
	ld a, [hli]
	ld [wTextDest + 1], a
	ld b, a
	jp NextTextCommand

TextCommand_LOW:
; write text at (1,16)
	pop hl
	bccoord 1, 16 ; second line of dialogue text box
	jp NextTextCommand

TextCommand_PROMPT_BUTTON:
; wait for button press; show arrow
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jp z, TextCommand_WAIT_BUTTON
	ld a, $ee
	ldcoord_a 18, 16 ; place down arrow in lower right corner of dialogue text box
	push bc
	call ManualTextScroll ; blink arrow and wait for A or B to be pressed
	pop bc
	ld a, $7f
	ldcoord_a 18, 16 ; overwrite down arrow with blank space
	pop hl
	jp NextTextCommand

TextCommand_SCROLL:
; pushes text up two lines and sets the BC cursor to the border tile
; below the first character column of the text box.
	ld a, $7f
	ldcoord_a 18, 16 ; place blank space in lower right corner of dialogue text box
	call ScrollTextUpOneLine
	call ScrollTextUpOneLine
	pop hl
	bccoord 1, 16 ; second line of dialogue text box
	jp NextTextCommand

TextCommand_START_ASM:
; run assembly code
	pop hl
	ld de, NextTextCommand
	push de
	jp hl

TextCommand_NUM:
; print a number
	pop hl
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	push hl
	ld h, b
	ld l, c
	ld b, a
	and $0f
	ld c, a
	ld a, b
	and $f0
	swap a
	set BIT_LEFT_ALIGN, a
	ld b, a
	call PrintNumber
	ld b, h
	ld c, l
	pop hl
	jp NextTextCommand

TextCommand_PAUSE:
; wait for button press or 30 frames
	push bc
	call Joypad
	ldh a, [lobyte(hJoyHeld)]
	and PAD_A | PAD_B
	jr nz, TextCommand_PAUSE.done
	ld c, 30 ; half a second
	call DelayFrames
TextCommand_PAUSE.done
	pop bc
	pop hl
	jp NextTextCommand

TextCommand_SOUND:
; play a sound effect from TextCommandSounds
	pop hl
	push bc
	dec hl
	ld a, [hli]
	ld b, a ; b = text command number that got us here
	push hl
	ld hl, TextCommandSounds
TextCommand_SOUND.loop
	ld a, [hli]
	cp b
	jr z, TextCommand_SOUND.play
	inc hl
	jr TextCommand_SOUND.loop

TextCommand_SOUND.play
	cp TX_SOUND_CRY_NIDORINA
	jr z, TextCommand_SOUND.pokemonCry
	cp TX_SOUND_CRY_PIDGEOT
	jr z, TextCommand_SOUND.pokemonCry
	cp TX_SOUND_CRY_DEWGONG
	jr z, TextCommand_SOUND.pokemonCry
	ld a, [hl]
	call PlaySound
	call WaitForSoundToFinish
	pop hl
	pop bc
	jp NextTextCommand

TextCommand_SOUND.pokemonCry
	push de
	ld a, [hl]
	call PlayCry
	pop de
	pop hl
	pop bc
	jp NextTextCommand

TextCommandSounds:
	.DB TX_SOUND_GET_ITEM_1,           SFX_GET_ITEM_1 ; actually plays SFX_LEVEL_UP when the battle music engine is loaded
	.DB TX_SOUND_CAUGHT_MON,           SFX_CAUGHT_MON
	.DB TX_SOUND_POKEDEX_RATING,       SFX_POKEDEX_RATING ; unused
	.DB TX_SOUND_GET_ITEM_1_DUPLICATE, SFX_GET_ITEM_1 ; unused
	.DB TX_SOUND_GET_ITEM_2,           SFX_GET_ITEM_2
	.DB TX_SOUND_GET_KEY_ITEM,         SFX_GET_KEY_ITEM
	.DB TX_SOUND_DEX_PAGE_ADDED,       SFX_DEX_PAGE_ADDED
	.DB TX_SOUND_CRY_NIDORINA,         NIDORINA ; used in OakSpeech
	.DB TX_SOUND_CRY_PIDGEOT,          PIDGEOT  ; used in SaffronCityPidgeotText
	.DB TX_SOUND_CRY_DEWGONG,          DEWGONG  ; unused

TextCommand_DOTS:
; wait for button press or 30 frames while printing "…"s
	pop hl
	ld a, [hli]
	ld d, a
	push hl
	ld h, b
	ld l, c

TextCommand_DOTS.loop
	ld a, $75
	ld [hli], a
	push de
	call Joypad
	pop de
	ldh a, [lobyte(hJoyHeld)] ; joypad state
	and PAD_A | PAD_B
	jr nz, TextCommand_DOTS.next ; if so, skip the delay
	ld c, 10
	call DelayFrames
TextCommand_DOTS.next
	dec d
	jr nz, TextCommand_DOTS.loop

	ld b, h
	ld c, l
	pop hl
	jp NextTextCommand

TextCommand_WAIT_BUTTON:
; wait for button press; don't show arrow
	push bc
	call ManualTextScroll
	pop bc
	pop hl
	jp NextTextCommand

TextCommand_FAR:
; write text from a different bank (little endian)
	pop hl
	ldh a, [lobyte(hLoadedROMBank)]
	push af

	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]

	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a

	push hl
	ld l, e
	ld h, d
	call TextCommandProcessor
	pop hl

	pop af
	ldh [lobyte(hLoadedROMBank)], a
	ld [rROMB], a
	jp NextTextCommand

TextCommandJumpTable:
; entries correspond to TX_* constants (see macros/scripts/text.asm)
	.DW TextCommand_START         ; TX_START
	.DW TextCommand_RAM           ; TX_RAM
	.DW TextCommand_BCD           ; TX_BCD
	.DW TextCommand_MOVE          ; TX_MOVE
	.DW TextCommand_BOX           ; TX_BOX
	.DW TextCommand_LOW           ; TX_LOW
	.DW TextCommand_PROMPT_BUTTON ; TX_PROMPT_BUTTON
.IF defined(_DEBUG)
	.DW WLA_GLOBAL_ContTextNoPause          ; TX_SCROLL
.ELSE
	.DW TextCommand_SCROLL        ; TX_SCROLL
.ENDIF
	.DW TextCommand_START_ASM     ; TX_START_ASM
	.DW TextCommand_NUM           ; TX_NUM
	.DW TextCommand_PAUSE         ; TX_PAUSE
	.DW TextCommand_SOUND         ; TX_SOUND_GET_ITEM_1 (also handles other TX_SOUND_* commands)
	.DW TextCommand_DOTS          ; TX_DOTS
	.DW TextCommand_WAIT_BUTTON   ; TX_WAIT_BUTTON
	; greater TX_* constants are handled directly by NextTextCommand
