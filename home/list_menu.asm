; INPUT:
; [wListMenuID] = list menu ID
; [wListPointer] = address of the list (2 bytes)
DisplayListMenuID:
	xor a
	ldh [lobyte(hAutoBGTransferEnabled)], a ; disable auto-transfer
	ld a, 1
	ldh [lobyte(hJoy7)], a ; joypad state update flag
	ld a, [wBattleType]
	and a ; is it the Old Man battle?
	jr nz, DisplayListMenuID.specialBattleType
	ld a, $01 ; hardcoded bank
	jr DisplayListMenuID.bankswitch
DisplayListMenuID.specialBattleType ; Old Man battle
	ld a, bank(DisplayBattleMenu)
DisplayListMenuID.bankswitch
	call BankswitchHome
	ld hl, wStatusFlags5
	set BIT_NO_TEXT_DELAY, [hl]
	xor a
	ld [wMenuItemToSwap], a ; 0 means no item is currently being swapped
	ld [wListCount], a
	ld a, [wListPointer]
	ld l, a
	ld a, [wListPointer + 1]
	ld h, a ; hl = address of the list
	ld a, [hl] ; the first byte is the number of entries in the list
	ld [wListCount], a
	ld a, LIST_MENU_BOX
	ld [wTextBoxID], a
	call DisplayTextBoxID ; draw the menu text box
	call UpdateSprites ; disable sprites behind the text box
; the code up to .skipMovingSprites appears to be useless
	hlcoord 4, 2 ; coordinates of upper left corner of menu text box
	lb "de", 9, 14 ; height and width of menu text box
	ld a, [wListMenuID]
	and a ; PCPOKEMONLISTMENU?
	jr nz, DisplayListMenuID.skipMovingSprites
	call UpdateSprites
DisplayListMenuID.skipMovingSprites
	ld a, 1 ; max menu item ID is 1 if the list has less than 2 entries
	ld [wMenuWatchMovingOutOfBounds], a
	ld a, [wListCount]
	cp 2 ; does the list have less than 2 entries?
	jr c, DisplayListMenuID.setMenuVariables
	ld a, 2 ; max menu item ID is 2 if the list has at least 2 entries
DisplayListMenuID.setMenuVariables
	ld [wMaxMenuItem], a
	ld a, 4
	ld [wTopMenuItemY], a
	ld a, 5
	ld [wTopMenuItemX], a
	ld a, PAD_A | PAD_B | PAD_SELECT
	ld [wMenuWatchedKeys], a
	ld c, 10
	call DelayFrames

DisplayListMenuIDLoop:
	xor a
	ldh [lobyte(hAutoBGTransferEnabled)], a ; disable transfer
	call PrintListMenuEntries
	ld a, 1
	ldh [lobyte(hAutoBGTransferEnabled)], a ; enable transfer
	call Delay3
	ld a, [wBattleType]
	and a ; is it the Old Man battle?
	jr z, DisplayListMenuIDLoop.notOldManBattle
; Old Man battle
	ld a, $ed
	ldcoord_a 5, 4 ; place menu cursor in front of first menu entry
	ld c, 80
	call DelayFrames
	xor a
	ld [wCurrentMenuItem], a
	hlcoord 5, 4
	ld a, l
	ld [wMenuCursorLocation], a
	ld a, h
	ld [wMenuCursorLocation + 1], a
	jr DisplayListMenuIDLoop.buttonAPressed
DisplayListMenuIDLoop.notOldManBattle
	call LoadGBPal
	call HandleMenuInput
	push af
	call PlaceMenuCursor
	pop af
	bit B_PAD_A, a
	jp z, DisplayListMenuIDLoop.checkOtherKeys
DisplayListMenuIDLoop.buttonAPressed
	ld a, [wCurrentMenuItem]
	call PlaceUnfilledArrowMenuCursor

; pointless because both values are overwritten before they are read
	ld a, $01
	ld [wMenuExitMethod], a
	ld [wChosenMenuItem], a

	xor a
	ld [wMenuWatchMovingOutOfBounds], a
	ld a, [wCurrentMenuItem]
	ld c, a
	ld a, [wListScrollOffset]
	add c
	ld c, a
	ld a, [wListCount]
	and a ; is the list empty?
	jp z, ExitListMenu ; if so, exit the menu
	dec a
	cp c ; did the player select Cancel?
	jp c, ExitListMenu ; if so, exit the menu
	ld a, c
	ld [wWhichPokemon], a
	ld a, [wListMenuID]
	cp ITEMLISTMENU
	jr nz, DisplayListMenuIDLoop.skipMultiplying
; if it's an item menu
	sla c ; item entries are 2 bytes long, so multiply by 2
DisplayListMenuIDLoop.skipMultiplying
	ld a, [wListPointer]
	ld l, a
	ld a, [wListPointer + 1]
	ld h, a
	inc hl ; hl = beginning of list entries
	ld b, 0
	add hl, bc
	ld a, [hl]
	ld [wCurListMenuItem], a
	ld a, [wListMenuID]
	and a ; PCPOKEMONLISTMENU?
	jr z, DisplayListMenuIDLoop.pokemonList
; if it's an item menu
	push hl
	call GetItemPrice
	pop hl
	ld a, [wListMenuID]
	cp ITEMLISTMENU
	jr nz, DisplayListMenuIDLoop.skipGettingQuantity
	inc hl
	ld a, [hl] ; a = item quantity
	ld [wMaxItemQuantity], a
DisplayListMenuIDLoop.skipGettingQuantity
	ld a, [wCurItem]
	ld [wNameListIndex], a
	ld a, bank(ItemNames)
	ld [wPredefBank], a
	call GetName
	jr DisplayListMenuIDLoop.storeChosenEntry
DisplayListMenuIDLoop.pokemonList
	ld hl, wPartyCount
	ld a, [wListPointer]
	cp l ; is it a list of party pokemon or box pokemon?
	ld hl, wPartyMonNicks
	jr z, DisplayListMenuIDLoop.getPokemonName
	ld hl, wBoxMonNicks ; box pokemon names
DisplayListMenuIDLoop.getPokemonName
	ld a, [wWhichPokemon]
	call GetPartyMonName
DisplayListMenuIDLoop.storeChosenEntry ; store the menu entry that the player chose and return
	ld de, wNameBuffer
	call CopyToStringBuffer
	ld a, CHOSE_MENU_ITEM
	ld [wMenuExitMethod], a
	ld a, [wCurrentMenuItem]
	ld [wChosenMenuItem], a
	xor a
	ldh [lobyte(hJoy7)], a ; joypad state update flag
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	jp BankswitchBack
DisplayListMenuIDLoop.checkOtherKeys ; check B, SELECT, Up, and Down keys
	bit B_PAD_B, a
	jp nz, ExitListMenu ; if so, exit the menu
	bit B_PAD_SELECT, a
	jp nz, HandleItemListSwapping ; if so, allow the player to swap menu entries
	ld b, a
	bit B_PAD_DOWN, b
	ld hl, wListScrollOffset
	jr z, DisplayListMenuIDLoop.upPressed
; Down pressed
	ld a, [hl]
	add 3
	ld b, a
	ld a, [wListCount]
	cp b ; will going down scroll past the Cancel button?
	jp c, DisplayListMenuIDLoop
	inc [hl] ; if not, go down
	jp DisplayListMenuIDLoop
DisplayListMenuIDLoop.upPressed
	ld a, [hl]
	and a
	jp z, DisplayListMenuIDLoop
	dec [hl]
	jp DisplayListMenuIDLoop

DisplayChooseQuantityMenu:
; text box dimensions/coordinates for just quantity
	hlcoord 15, 9
	ld b, 1 ; height
	ld c, 3 ; width
	ld a, [wListMenuID]
	cp PRICEDITEMLISTMENU
	jr nz, DisplayChooseQuantityMenu.drawTextBox
; text box dimensions/coordinates for quantity and price
	hlcoord 7, 9
	ld b, 1  ; height
	ld c, 11 ; width
DisplayChooseQuantityMenu.drawTextBox
	call TextBoxBorder
	hlcoord 16, 10
	ld a, [wListMenuID]
	cp PRICEDITEMLISTMENU
	jr nz, DisplayChooseQuantityMenu.printInitialQuantity
	hlcoord 8, 10
DisplayChooseQuantityMenu.printInitialQuantity
	ld de, InitialQuantityText
	call PlaceString
	xor a
	ld [wItemQuantity], a ; initialize current quantity to 0
	jp DisplayChooseQuantityMenu.incrementQuantity
DisplayChooseQuantityMenu.waitForKeyPressLoop
	call JoypadLowSensitivity
	ldh a, [lobyte(hJoyPressed)] ; newly pressed buttons
	bit B_PAD_A, a
	jp nz, DisplayChooseQuantityMenu.buttonAPressed
	bit B_PAD_B, a
	jp nz, DisplayChooseQuantityMenu.buttonBPressed
	bit B_PAD_UP, a
	jr nz, DisplayChooseQuantityMenu.incrementQuantity
	bit B_PAD_DOWN, a
	jr nz, DisplayChooseQuantityMenu.decrementQuantity
	jr DisplayChooseQuantityMenu.waitForKeyPressLoop
DisplayChooseQuantityMenu.incrementQuantity
	ld a, [wMaxItemQuantity]
	inc a
	ld b, a
	ld hl, wItemQuantity ; current quantity
	inc [hl]
	ld a, [hl]
	cp b
	jr nz, DisplayChooseQuantityMenu.handleNewQuantity
; wrap to 1 if the player goes above the max quantity
	ld a, 1
	ld [hl], a
	jr DisplayChooseQuantityMenu.handleNewQuantity
DisplayChooseQuantityMenu.decrementQuantity
	ld hl, wItemQuantity ; current quantity
	dec [hl]
	jr nz, DisplayChooseQuantityMenu.handleNewQuantity
; wrap to the max quantity if the player goes below 1
	ld a, [wMaxItemQuantity]
	ld [hl], a
DisplayChooseQuantityMenu.handleNewQuantity
	hlcoord 17, 10
	ld a, [wListMenuID]
	cp PRICEDITEMLISTMENU
	jr nz, DisplayChooseQuantityMenu.printQuantity
DisplayChooseQuantityMenu.printPrice
	ld c, $03
	ld a, [wItemQuantity]
	ld b, a
	ld hl, hMoney ; total price
; initialize total price to 0
	xor a
	ld [hli], a
	ld [hli], a
	ld [hl], a
DisplayChooseQuantityMenu.addLoop ; loop to multiply the individual price by the quantity to get the total price
	ld de, hMoney + 2
	ld hl, hItemPrice + 2
	push bc
	predef AddBCDPredef ; add the individual price to the current sum
	pop bc
	dec b
	jr nz, DisplayChooseQuantityMenu.addLoop
	ldh a, [lobyte(hHalveItemPrices)]
	and a ; should the price be halved (for selling items)?
	jr z, DisplayChooseQuantityMenu.skipHalvingPrice
	xor a
	ldh [lobyte(hDivideBCDDivisor)], a
	ldh [lobyte(hDivideBCDDivisor + 1)], a
	ld a, $02
	ldh [lobyte(hDivideBCDDivisor + 2)], a
	predef DivideBCDPredef3 ; halves the price
; store the halved price
	ldh a, [lobyte(hDivideBCDQuotient)]
	ldh [lobyte(hMoney)], a
	ldh a, [lobyte(hDivideBCDQuotient + 1)]
	ldh [lobyte(hMoney + 1)], a
	ldh a, [lobyte(hDivideBCDQuotient + 2)]
	ldh [lobyte(hMoney + 2)], a
DisplayChooseQuantityMenu.skipHalvingPrice
	hlcoord 12, 10
	ld de, SpacesBetweenQuantityAndPriceText
	call PlaceString
	ld de, hMoney ; total price
	ld c, 3 | LEADING_ZEROES | MONEY_SIGN
	call PrintBCDNumber
	hlcoord 9, 10
DisplayChooseQuantityMenu.printQuantity
	ld de, wItemQuantity ; current quantity
	lb "bc", LEADING_ZEROES | 1, 2 ; 1 byte, 2 digits
	call PrintNumber
	jp DisplayChooseQuantityMenu.waitForKeyPressLoop
DisplayChooseQuantityMenu.buttonAPressed ; the player chose to make the transaction
	xor a
	ld [wMenuItemToSwap], a ; 0 means no item is currently being swapped
	ret
DisplayChooseQuantityMenu.buttonBPressed ; the player chose to cancel the transaction
	xor a
	ld [wMenuItemToSwap], a ; 0 means no item is currently being swapped
	ld a, $ff
	ret

InitialQuantityText:
		.STRINGMAP pokemon, "×01@"

SpacesBetweenQuantityAndPriceText:
		.STRINGMAP pokemon, "      @"

ExitListMenu:
	ld a, [wCurrentMenuItem]
	ld [wChosenMenuItem], a
	ld a, CANCELLED_MENU
	ld [wMenuExitMethod], a
	ld [wMenuWatchMovingOutOfBounds], a
	xor a
	ldh [lobyte(hJoy7)], a
	ld hl, wStatusFlags5
	res BIT_NO_TEXT_DELAY, [hl]
	call BankswitchBack
	xor a
	ld [wMenuItemToSwap], a ; 0 means no item is currently being swapped
	scf
	ret

PrintListMenuEntries:
	hlcoord 5, 3
	ld b, 9
	ld c, 14
	call ClearScreenArea
	ld a, [wListPointer]
	ld e, a
	ld a, [wListPointer + 1]
	ld d, a
	inc de ; de = beginning of list entries
	ld a, [wListScrollOffset]
	ld c, a
	ld a, [wListMenuID]
	cp ITEMLISTMENU
	ld a, c
	jr nz, PrintListMenuEntries.skipMultiplying
; if it's an item menu
; item entries are 2 bytes long, so multiply by 2
	sla a
	sla c
PrintListMenuEntries.skipMultiplying
	add e
	ld e, a
	jr nc, PrintListMenuEntries.noCarry
	inc d
PrintListMenuEntries.noCarry
	hlcoord 6, 4 ; coordinates of first list entry name
	ld b, 4 ; print 4 names
PrintListMenuEntries.loop
	ld a, b
	ld [wWhichPokemon], a
	ld a, [de]
	ld [wNamedObjectIndex], a
	cp $ff
	jp z, PrintListMenuEntries.printCancelMenuItem
	push bc
	push de
	push hl
	push hl
	push de
	ld a, [wListMenuID]
	and a ; PCPOKEMONLISTMENU?
	jr z, PrintListMenuEntries.pokemonPCMenu
	cp MOVESLISTMENU
	jr z, PrintListMenuEntries.movesMenu
; item menu
	call GetItemName
	jr PrintListMenuEntries.placeNameString
PrintListMenuEntries.pokemonPCMenu
	push hl
	ld hl, wPartyCount
	ld a, [wListPointer]
	cp l ; is it a list of party pokemon or box pokemon?
	ld hl, wPartyMonNicks
	jr z, PrintListMenuEntries.getPokemonName
	ld hl, wBoxMonNicks ; box pokemon names
PrintListMenuEntries.getPokemonName
	ld a, [wWhichPokemon]
	ld b, a
	ld a, 4
	sub b
	ld b, a
	ld a, [wListScrollOffset]
	add b
	call GetPartyMonName
	pop hl
	jr PrintListMenuEntries.placeNameString
PrintListMenuEntries.movesMenu
	call GetMoveName
PrintListMenuEntries.placeNameString
	call PlaceString
	pop de
	pop hl
	ld a, [wPrintItemPrices]
	and a ; should prices be printed?
	jr z, PrintListMenuEntries.skipPrintingItemPrice
; print item price
	push hl
	ld a, [de]
	ld de, ItemPrices
	ld [wCurItem], a
	call GetItemPrice
	pop hl
	ld bc, SCREEN_WIDTH + 5 ; 1 row down and 5 columns right
	add hl, bc
	ld c, 3 | LEADING_ZEROES | MONEY_SIGN
	call PrintBCDNumber
PrintListMenuEntries.skipPrintingItemPrice
	ld a, [wListMenuID]
	and a ; PCPOKEMONLISTMENU?
	jr nz, PrintListMenuEntries.skipPrintingPokemonLevel
; print Pokemon level
	ld a, [wNamedObjectIndex]
	push af
	push hl
	ld hl, wPartyCount
	ld a, [wListPointer]
	cp l ; is it a list of party pokemon or box pokemon?
	ld a, PLAYER_PARTY_DATA
	jr z, PrintListMenuEntries.next
	ld a, BOX_DATA
PrintListMenuEntries.next
	ld [wMonDataLocation], a
	ld hl, wWhichPokemon
	ld a, [hl]
	ld b, a
	ld a, $04
	sub b
	ld b, a
	ld a, [wListScrollOffset]
	add b
	ld [hl], a
	call LoadMonData
	ld a, [wMonDataLocation]
	and a ; is it a list of party pokemon or box pokemon?
	jr z, PrintListMenuEntries.skipCopyingLevel
; copy level
	ld a, [wLoadedMonBoxLevel]
	ld [wLoadedMonLevel], a
PrintListMenuEntries.skipCopyingLevel
	pop hl
	ld bc, SCREEN_WIDTH + 8 ; 1 row down and 8 columns right
	add hl, bc
	call PrintLevel
	pop af
	ld [wNamedObjectIndex], a
PrintListMenuEntries.skipPrintingPokemonLevel
	pop hl
	pop de
	inc de
	ld a, [wListMenuID]
	cp ITEMLISTMENU
	jr nz, PrintListMenuEntries.nextListEntry
; print item quantity
	ld a, [wNamedObjectIndex]
	ld [wCurItem], a
	call IsKeyItem ; check if item is unsellable
	ld a, [wIsKeyItem]
	and a ; is the item unsellable?
	jr nz, PrintListMenuEntries.skipPrintingItemQuantity ; if so, don't print the quantity
	push hl
	ld bc, SCREEN_WIDTH + 8 ; 1 row down and 8 columns right
	add hl, bc
	ld a, $f1
	ld [hli], a
	ld a, [wNamedObjectIndex]
	push af
	ld a, [de]
	ld [wMaxItemQuantity], a
	push de
	ld de, wTempByteValue
	ld [de], a
	lb "bc", 1, 2
	call PrintNumber
	pop de
	pop af
	ld [wNamedObjectIndex], a
	pop hl
PrintListMenuEntries.skipPrintingItemQuantity
	inc de
	pop bc
	inc c
	push bc
	inc c
	ld a, [wMenuItemToSwap] ; ID of item chosen for swapping (counts from 1)
	and a ; is an item being swapped?
	jr z, PrintListMenuEntries.nextListEntry
	sla a
	cp c ; is it this item?
	jr nz, PrintListMenuEntries.nextListEntry
	dec hl
	ld a, $ec
	ld [hli], a
PrintListMenuEntries.nextListEntry
	ld bc, 2 * SCREEN_WIDTH ; 2 rows
	add hl, bc
	pop bc
	inc c
	dec b
	jp nz, PrintListMenuEntries.loop
	ld bc, -8
	add hl, bc
	ld a, $ee
	ld [hl], a
	ret
PrintListMenuEntries.printCancelMenuItem
	ld de, ListMenuCancelText
	jp PlaceString

ListMenuCancelText:
		.STRINGMAP pokemon, "CANCEL@"
