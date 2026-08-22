Serial:
	push af
	push bc
	push de
	push hl
	ldh a, [lobyte(hSerialConnectionStatus)]
	inc a
	jr z, Serial.connectionNotYetEstablished
	ldh a, [lobyte(rSB)]
	ldh [lobyte(hSerialReceiveData)], a
	ldh a, [lobyte(hSerialSendData)]
	ldh [lobyte(rSB)], a
	ldh a, [lobyte(hSerialConnectionStatus)]
	cp USING_INTERNAL_CLOCK
	jr z, Serial.done
; using external clock
	ld a, SC_START | SC_EXTERNAL
	ldh [lobyte(rSC)], a
	jr Serial.done
Serial.connectionNotYetEstablished
	ldh a, [lobyte(rSB)]
	ldh [lobyte(hSerialReceiveData)], a
	ldh [lobyte(hSerialConnectionStatus)], a
	cp USING_INTERNAL_CLOCK
	jr z, Serial.usingInternalClock
; using external clock
	xor a
	ldh [lobyte(rSB)], a
	ld a, $3
	ldh [lobyte(rDIV)], a
Serial.waitLoop
	ldh a, [lobyte(rDIV)]
	bit 7, a ; wait until rDIV has incremented from $3 to $80 or more
	jr nz, Serial.waitLoop
	ld a, SC_START | SC_EXTERNAL
	ldh [lobyte(rSC)], a
	jr Serial.done
Serial.usingInternalClock
	xor a
	ldh [lobyte(rSB)], a
Serial.done
	ld a, $1
	ldh [lobyte(hSerialReceivedNewData)], a
	ld a, SERIAL_NO_DATA_BYTE
	ldh [lobyte(hSerialSendData)], a
	pop hl
	pop de
	pop bc
	pop af
	reti

; hl = send data
; de = receive data
; bc = length of data
Serial_ExchangeBytes:
	ld a, 1
	ldh [lobyte(hSerialIgnoringInitialData)], a
Serial_ExchangeBytes.loop
	ld a, [hl]
	ldh [lobyte(hSerialSendData)], a
	call Serial_ExchangeByte
	push bc
	ld b, a
	inc hl
	ld a, 48
Serial_ExchangeBytes.waitLoop
	dec a
	jr nz, Serial_ExchangeBytes.waitLoop
	ldh a, [lobyte(hSerialIgnoringInitialData)]
	and a
	ld a, b
	pop bc
	jr z, Serial_ExchangeBytes.storeReceivedByte
	dec hl
	cp SERIAL_PREAMBLE_BYTE
	jr nz, Serial_ExchangeBytes.loop
	xor a
	ldh [lobyte(hSerialIgnoringInitialData)], a
	jr Serial_ExchangeBytes.loop
Serial_ExchangeBytes.storeReceivedByte
	ld [de], a
	inc de
	dec bc
	ld a, b
	or c
	jr nz, Serial_ExchangeBytes.loop
	ret

Serial_ExchangeByte:
	xor a
	ldh [lobyte(hSerialReceivedNewData)], a
	ldh a, [lobyte(hSerialConnectionStatus)]
	cp USING_INTERNAL_CLOCK
	jr nz, Serial_ExchangeByte.loop
	ld a, SC_START | SC_INTERNAL
	ldh [lobyte(rSC)], a
Serial_ExchangeByte.loop
	ldh a, [lobyte(hSerialReceivedNewData)]
	and a
	jr nz, Serial_ExchangeByte.ok
	ldh a, [lobyte(hSerialConnectionStatus)]
	cp USING_EXTERNAL_CLOCK
	jr nz, Serial_ExchangeByte.doNotIncrementUnknownCounter
	call IsUnknownCounterZero
	jr z, Serial_ExchangeByte.doNotIncrementUnknownCounter
	call WaitLoop_15Iterations
	push hl
	ld hl, wUnknownSerialCounter + 1
	inc [hl]
	jr nz, Serial_ExchangeByte.noCarry
	dec hl
	inc [hl]
Serial_ExchangeByte.noCarry
	pop hl
	call IsUnknownCounterZero
	jr nz, Serial_ExchangeByte.loop
	jp SetUnknownCounterToFFFF
Serial_ExchangeByte.doNotIncrementUnknownCounter
	ldh a, [lobyte(rIE)]
	and IE_SERIAL | IE_TIMER | IE_STAT | IE_VBLANK
	cp IE_SERIAL
	jr nz, Serial_ExchangeByte.loop
	ld a, [wUnknownSerialCounter2]
	dec a
	ld [wUnknownSerialCounter2], a
	jr nz, Serial_ExchangeByte.loop
	ld a, [wUnknownSerialCounter2 + 1]
	dec a
	ld [wUnknownSerialCounter2 + 1], a
	jr nz, Serial_ExchangeByte.loop
	ldh a, [lobyte(hSerialConnectionStatus)]
	cp USING_EXTERNAL_CLOCK
	jr z, Serial_ExchangeByte.ok
	ld a, 255
Serial_ExchangeByte.waitLoop
	dec a
	jr nz, Serial_ExchangeByte.waitLoop
Serial_ExchangeByte.ok
	xor a
	ldh [lobyte(hSerialReceivedNewData)], a
	ldh a, [lobyte(rIE)]
	and IE_SERIAL | IE_TIMER | IE_STAT | IE_VBLANK
	sub IE_SERIAL
	jr nz, Serial_ExchangeByte.skipReloadingUnknownCounter2
	ld [wUnknownSerialCounter2], a
	ld a, $50
	ld [wUnknownSerialCounter2 + 1], a
Serial_ExchangeByte.skipReloadingUnknownCounter2
	ldh a, [lobyte(hSerialReceiveData)]
	cp SERIAL_NO_DATA_BYTE
	ret nz
	call IsUnknownCounterZero
	jr z, Serial_ExchangeByte.done
	push hl
	ld hl, wUnknownSerialCounter + 1
	ld a, [hl]
	dec a
	ld [hld], a
	inc a
	jr nz, Serial_ExchangeByte.noBorrow
	dec [hl]
Serial_ExchangeByte.noBorrow
	pop hl
	call IsUnknownCounterZero
	jr z, SetUnknownCounterToFFFF
Serial_ExchangeByte.done
	ldh a, [lobyte(rIE)]
	and IE_SERIAL | IE_TIMER | IE_STAT | IE_VBLANK
	cp IE_SERIAL
	ld a, SERIAL_NO_DATA_BYTE
	ret z
	ld a, [hl]
	ldh [lobyte(hSerialSendData)], a
	call DelayFrame
	jp Serial_ExchangeByte

WaitLoop_15Iterations:
	ld a, 15
WaitLoop_15Iterations.waitLoop
	dec a
	jr nz, WaitLoop_15Iterations.waitLoop
	ret

IsUnknownCounterZero:
	push hl
	ld hl, wUnknownSerialCounter
	ld a, [hli]
	or [hl]
	pop hl
	ret

; a is always 0 when this is called
SetUnknownCounterToFFFF:
	dec a
	ld [wUnknownSerialCounter], a
	ld [wUnknownSerialCounter + 1], a
	ret

; This is used to exchange the button press and selected menu item on the link menu.
; The data is sent thrice and read twice to increase reliability.
Serial_ExchangeLinkMenuSelection:
	ld hl, wLinkMenuSelectionSendBuffer
	ld de, wLinkMenuSelectionReceiveBuffer
	ld c, 2 ; number of bytes to save
	ld a, 1
	ldh [lobyte(hSerialIgnoringInitialData)], a
Serial_ExchangeLinkMenuSelection.loop
	call DelayFrame
	ld a, [hl]
	ldh [lobyte(hSerialSendData)], a
	call Serial_ExchangeByte
	ld b, a
	inc hl
	ldh a, [lobyte(hSerialIgnoringInitialData)]
	and a
	ld a, 0
	ldh [lobyte(hSerialIgnoringInitialData)], a
	jr nz, Serial_ExchangeLinkMenuSelection.loop
	ld a, b
	ld [de], a
	inc de
	dec c
	jr nz, Serial_ExchangeLinkMenuSelection.loop
	ret

Serial_PrintWaitingTextAndSyncAndExchangeNybble:
	call SaveScreenTilesToBuffer1
	callfar PrintWaitingText
	call Serial_SyncAndExchangeNybble
	jp LoadScreenTilesFromBuffer1

Serial_SyncAndExchangeNybble:
	vc_hook Wireless_WaitLinkTransfer
	ld a, $ff
	ld [wSerialExchangeNybbleReceiveData], a
Serial_SyncAndExchangeNybble.loop1
	call Serial_ExchangeNybble
	call DelayFrame
	call IsUnknownCounterZero
	jr z, Serial_SyncAndExchangeNybble.next1
	push hl
	ld hl, wUnknownSerialCounter + 1
	dec [hl]
	jr nz, Serial_SyncAndExchangeNybble.next2
	dec hl
	dec [hl]
	jr nz, Serial_SyncAndExchangeNybble.next2
	pop hl
	xor a
	jp SetUnknownCounterToFFFF
Serial_SyncAndExchangeNybble.next2
	pop hl
Serial_SyncAndExchangeNybble.next1
	ld a, [wSerialExchangeNybbleReceiveData]
	inc a
	jr z, Serial_SyncAndExchangeNybble.loop1
	vc_patch Wireless_net_delay_3
.IF defined(_RED_VC) || defined(_BLUE_VC)
	ld b, 26
.ELSE
	ld b, 10
.ENDIF
	vc_patch_end
Serial_SyncAndExchangeNybble.loop2
	call DelayFrame
	call Serial_ExchangeNybble
	dec b
	jr nz, Serial_SyncAndExchangeNybble.loop2
	vc_patch Wireless_net_delay_4
.IF defined(_RED_VC) || defined(_BLUE_VC)
	ld b, 26
.ELSE
	ld b, 10
.ENDIF
	vc_patch_end
Serial_SyncAndExchangeNybble.loop3
	call DelayFrame
	call Serial_SendZeroByte
	dec b
	jr nz, Serial_SyncAndExchangeNybble.loop3
	ld a, [wSerialExchangeNybbleReceiveData]
	ld [wSerialSyncAndExchangeNybbleReceiveData], a
	vc_hook Wireless_WaitLinkTransfer_ret
	ret

Serial_ExchangeNybble:
	call Serial_ExchangeNybble.doExchange
	ld a, [wSerialExchangeNybbleSendData]
	add $60
	ldh [lobyte(hSerialSendData)], a
	ldh a, [lobyte(hSerialConnectionStatus)]
	cp USING_INTERNAL_CLOCK
	jr nz, Serial_ExchangeNybble.doExchange
	ld a, SC_START | SC_INTERNAL
	ldh [lobyte(rSC)], a
Serial_ExchangeNybble.doExchange
	ldh a, [lobyte(hSerialReceiveData)]
	ld [wSerialExchangeNybbleTempReceiveData], a
	and $f0
	cp $60
	ret nz
	xor a
	ldh [lobyte(hSerialReceiveData)], a
	ld a, [wSerialExchangeNybbleTempReceiveData]
	and $f
	ld [wSerialExchangeNybbleReceiveData], a
	ret

Serial_SendZeroByte:
	xor a
	ldh [lobyte(hSerialSendData)], a
	ldh a, [lobyte(hSerialConnectionStatus)]
	cp USING_INTERNAL_CLOCK
	ret nz
	ld a, SC_START | SC_INTERNAL
	ldh [lobyte(rSC)], a
	ret

Serial_TryEstablishingExternallyClockedConnection:
	ld a, ESTABLISH_CONNECTION_WITH_EXTERNAL_CLOCK
	ldh [lobyte(rSB)], a
	xor a
	ldh [lobyte(hSerialReceiveData)], a
	ld a, SC_START | SC_EXTERNAL
	ldh [lobyte(rSC)], a
	ret
