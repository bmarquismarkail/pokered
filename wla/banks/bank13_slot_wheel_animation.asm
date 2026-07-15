; Structured replacement for slot wheel animation/input code.
SlotMachine_AnimWheel1:
	ld bc, SlotMachineWheel1
	ld de, wSlotMachineWheel1Offset
	ld hl, wShadowOAMSprite00
	ld a, $30
	ld (wBaseCoordX), a
	jr SlotMachine_AnimWheel

SlotMachine_AnimWheel2:
	ld bc, SlotMachineWheel2
	ld de, wSlotMachineWheel2Offset
	ld hl, wShadowOAMSprite12
	ld a, $50
	ld (wBaseCoordX), a
	jr SlotMachine_AnimWheel

SlotMachine_AnimWheel3:
	ld bc, SlotMachineWheel3
	ld de, wSlotMachineWheel3Offset
	ld hl, wShadowOAMSprite24
	ld a, $70
	ld (wBaseCoordX), a

SlotMachine_AnimWheel:
	ld a, $58
	ld (wBaseCoordY), a
	push de
	ld a, (de)
	ld d, b
	add c
	ld e, a
	jr nc, SlotMachine_AnimWheel.loop
	inc d
SlotMachine_AnimWheel.loop:
	ld a, (wBaseCoordY)
	ld (HL+), a
	ld a, (wBaseCoordX)
	ld (HL+), a
	ld a, (de)
	ld (HL+), a
	ld a, $80
	ld (HL+), a
	ld a, (wBaseCoordY)
	ld (HL+), a
	ld a, (wBaseCoordX)
	add $8
	ld (HL+), a
	ld a, (de)
	inc a
	ld (HL+), a
	ld a, $80
	ld (HL+), a
	inc de
	ld a, (wBaseCoordY)
	sub $8
	ld (wBaseCoordY), a
	cp $28
	jr nz, SlotMachine_AnimWheel.loop
	pop de
	ld a, (de)
	inc a ; advance the offset so that the wheel animates
	cp 30
	jr nz, SlotMachine_AnimWheel.skip
	xor a ; wrap around to 0 when the offset reaches 30
SlotMachine_AnimWheel.skip:
	ld (de), a
	ret

SlotMachine_HandleInputWhileWheelsSpin:
	call DelayFrame
	call JoypadLowSensitivity
	ldh a, (hJoy5 - $FF00)
	and PAD_A
	ret z
	ld hl, wStoppingWhichSlotMachineWheel
	ld a, (hl)
	dec a
	ld de, wSlotMachineWheel1SlipCounter
	jr z, SlotMachine_HandleInputWhileWheelsSpin.skip
	dec a
	ld de, wSlotMachineWheel2SlipCounter
	jr z, SlotMachine_HandleInputWhileWheelsSpin.skip
SlotMachine_HandleInputWhileWheelsSpin.loop:
	inc (hl)
	ld a, SFX_SLOTS_STOP_WHEEL
	jp PlaySound
SlotMachine_HandleInputWhileWheelsSpin.skip:
	ld a, (de)
	and a
	ret nz
	jr SlotMachine_HandleInputWhileWheelsSpin.loop
SlotWheelAnimationEnd:
