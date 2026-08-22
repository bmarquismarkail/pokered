;******************************************************************************
; Game Boy hardware constant definitions
; https://github.com/gbdev/hardware.inc
;******************************************************************************

; To the extent possible under law, the authors of this work have
; waived all copyright and related or neighboring rights to the work.
; See https://creativecommons.org/publicdomain/zero/1.0/ for details.
; SPDX-License-Identifier: CC0-1.0

.IF !defined(HARDWARE_INC)
.DEFINE HARDWARE_INC 1
.DEFINE HARDWARE_INC_VERSION "5.3.0"


;******************************************************************************
; Memory-mapped registers ($FFxx range)
;******************************************************************************

; -- JOYP / P1 ($FF00) --------------------------------------------------------
; Joypad face buttons
.DEFINE rJOYP $FF00

.DEFINE B_JOYP_GET_BUTTONS 5 ; 0 = reading buttons     [r/w]
.DEFINE B_JOYP_GET_CTRL_PAD 4 ; 0 = reading Control Pad [r/w]
    .DEFINE JOYP_GET %00110000 ; select which inputs to read from the lower nybble
        .DEFINE JOYP_GET_BUTTONS %00010000 ; reading A/B/Select/Start buttons
        .DEFINE JOYP_GET_CTRL_PAD %00100000 ; reading Control Pad directions
        .DEFINE JOYP_GET_NONE %00110000 ; reading nothing

.DEFINE B_JOYP_START 3 ; 0 = Start is pressed  (if reading buttons)     [ro]
.DEFINE B_JOYP_SELECT 2 ; 0 = Select is pressed (if reading buttons)     [ro]
.DEFINE B_JOYP_B 1 ; 0 = B is pressed      (if reading buttons)     [ro]
.DEFINE B_JOYP_A 0 ; 0 = A is pressed      (if reading buttons)     [ro]
.DEFINE B_JOYP_DOWN 3 ; 0 = Down is pressed   (if reading Control Pad) [ro]
.DEFINE B_JOYP_UP 2 ; 0 = Up is pressed     (if reading Control Pad) [ro]
.DEFINE B_JOYP_LEFT 1 ; 0 = Left is pressed   (if reading Control Pad) [ro]
.DEFINE B_JOYP_RIGHT 0 ; 0 = Right is pressed  (if reading Control Pad) [ro]
    .DEFINE JOYP_INPUTS %00001111 ; bits equal to 0 indicate pressed (when reading inputs)
    .DEFINE JOYP_START 1 << B_JOYP_START
    .DEFINE JOYP_SELECT 1 << B_JOYP_SELECT
    .DEFINE JOYP_B 1 << B_JOYP_B
    .DEFINE JOYP_A 1 << B_JOYP_A
    .DEFINE JOYP_DOWN 1 << B_JOYP_DOWN
    .DEFINE JOYP_UP 1 << B_JOYP_UP
    .DEFINE JOYP_LEFT 1 << B_JOYP_LEFT
    .DEFINE JOYP_RIGHT 1 << B_JOYP_RIGHT

; SGB command packet transfer uses for JOYP bits
.DEFINE B_JOYP_SGB_ONE 5 ; 0 = sending 1 bit
.DEFINE B_JOYP_SGB_ZERO 4 ; 0 = sending 0 bit
    .DEFINE JOYP_SGB_START %00000000 ; start SGB packet transfer
    .DEFINE JOYP_SGB_ONE %00010000 ; send 1 bit
    .DEFINE JOYP_SGB_ZERO %00100000 ; send 0 bit
    .DEFINE JOYP_SGB_FINISH %00110000 ; finish SGB packet transfer

; Combined input byte, with Control Pad in high nybble (conventional order)
.DEFINE B_PAD_DOWN 7
.DEFINE B_PAD_UP 6
.DEFINE B_PAD_LEFT 5
.DEFINE B_PAD_RIGHT 4
.DEFINE B_PAD_START 3
.DEFINE B_PAD_SELECT 2
.DEFINE B_PAD_B 1
.DEFINE B_PAD_A 0
    .DEFINE PAD_CTRL_PAD %11110000
    .DEFINE PAD_BUTTONS %00001111
    .DEFINE PAD_DOWN 1 << B_PAD_DOWN
    .DEFINE PAD_UP 1 << B_PAD_UP
    .DEFINE PAD_LEFT 1 << B_PAD_LEFT
    .DEFINE PAD_RIGHT 1 << B_PAD_RIGHT
    .DEFINE PAD_START 1 << B_PAD_START
    .DEFINE PAD_SELECT 1 << B_PAD_SELECT
    .DEFINE PAD_B 1 << B_PAD_B
    .DEFINE PAD_A 1 << B_PAD_A

; Combined input byte, with Control Pad in low nybble (swapped order)
.DEFINE B_PAD_SWAP_START 7
.DEFINE B_PAD_SWAP_SELECT 6
.DEFINE B_PAD_SWAP_B 5
.DEFINE B_PAD_SWAP_A 4
.DEFINE B_PAD_SWAP_DOWN 3
.DEFINE B_PAD_SWAP_UP 2
.DEFINE B_PAD_SWAP_LEFT 1
.DEFINE B_PAD_SWAP_RIGHT 0
    .DEFINE PAD_SWAP_CTRL_PAD %00001111
    .DEFINE PAD_SWAP_BUTTONS %11110000
    .DEFINE PAD_SWAP_START 1 << B_PAD_SWAP_START
    .DEFINE PAD_SWAP_SELECT 1 << B_PAD_SWAP_SELECT
    .DEFINE PAD_SWAP_B 1 << B_PAD_SWAP_B
    .DEFINE PAD_SWAP_A 1 << B_PAD_SWAP_A
    .DEFINE PAD_SWAP_DOWN 1 << B_PAD_SWAP_DOWN
    .DEFINE PAD_SWAP_UP 1 << B_PAD_SWAP_UP
    .DEFINE PAD_SWAP_LEFT 1 << B_PAD_SWAP_LEFT
    .DEFINE PAD_SWAP_RIGHT 1 << B_PAD_SWAP_RIGHT

; -- SB ($FF01) ---------------------------------------------------------------
; Serial transfer data [r/w]
.DEFINE rSB $FF01

; -- SC ($FF02) ---------------------------------------------------------------
; Serial transfer control
.DEFINE rSC $FF02

.DEFINE B_SC_START 7 ; reading 1 = transfer in progress, writing 1 = start transfer        [r/w]
.DEFINE B_SC_SPEED 1 ; (CGB only) 1 = use faster internal clock                            [r/w]
.DEFINE B_SC_SOURCE 0 ; 0 = use external clock ("slave"), 1 = use internal clock ("master") [r/w]
    .DEFINE SC_START 1 << B_SC_START
    .DEFINE SC_SPEED 1 << B_SC_SPEED
        .DEFINE SC_SLOW 0 << B_SC_SPEED
        .DEFINE SC_FAST 1 << B_SC_SPEED
    .DEFINE SC_SOURCE 1 << B_SC_SOURCE
        .DEFINE SC_EXTERNAL 0 << B_SC_SOURCE
        .DEFINE SC_INTERNAL 1 << B_SC_SOURCE

; -- $FF03 is unused ----------------------------------------------------------

; -- DIV ($FF04) --------------------------------------------------------------
; Divider register [r/w]
.DEFINE rDIV $FF04

; -- TIMA ($FF05) -------------------------------------------------------------
; Timer counter [r/w]
.DEFINE rTIMA $FF05

; -- TMA ($FF06) --------------------------------------------------------------
; Timer modulo [r/w]
.DEFINE rTMA $FF06

; -- TAC ($FF07) --------------------------------------------------------------
; Timer control
.DEFINE rTAC $FF07

.DEFINE B_TAC_START 2 ; enable incrementing TIMA [r/w]
    .DEFINE TAC_STOP 0 << B_TAC_START
    .DEFINE TAC_START 1 << B_TAC_START

.DEFINE TAC_CLOCK %00000011 ; the frequency at which TIMA increments [r/w]
    .DEFINE TAC_4KHZ %00000000 ; every 256 M-cycles = ~4 KHz on DMG
    .DEFINE TAC_262KHZ %00000001 ; every 4 M-cycles = ~262 KHz on DMG
    .DEFINE TAC_65KHZ %00000010 ; every 16 M-cycles = ~65 KHz on DMG
    .DEFINE TAC_16KHZ %00000011 ; every 64 M-cycles = ~16 KHz on DMG

; -- $FF08-$FF0E are unused ---------------------------------------------------

; -- IF ($FF0F) ---------------------------------------------------------------
; Pending interrupts
.DEFINE rIF $FF0F

.DEFINE B_IF_JOYPAD 4 ; 1 = joypad interrupt is pending [r/w]
.DEFINE B_IF_SERIAL 3 ; 1 = serial interrupt is pending [r/w]
.DEFINE B_IF_TIMER 2 ; 1 = timer  interrupt is pending [r/w]
.DEFINE B_IF_STAT 1 ; 1 = STAT   interrupt is pending [r/w]
.DEFINE B_IF_VBLANK 0 ; 1 = VBlank interrupt is pending [r/w]
    .DEFINE IF_JOYPAD 1 << B_IF_JOYPAD
    .DEFINE IF_SERIAL 1 << B_IF_SERIAL
    .DEFINE IF_TIMER 1 << B_IF_TIMER
    .DEFINE IF_STAT 1 << B_IF_STAT
    .DEFINE IF_VBLANK 1 << B_IF_VBLANK

; -- AUD1SWEEP / NR10 ($FF10) -------------------------------------------------
; Audio channel 1 sweep
.DEFINE rAUD1SWEEP $FF10

.DEFINE AUD1SWEEP_TIME %01110000 ; how long between sweep iterations
                                   ; (in 128 Hz ticks, ~7.8 ms apart) [r/w]

.DEFINE B_AUD1SWEEP_DIR 3 ; sweep direction [r/w]
    .DEFINE AUD1SWEEP_DIR 1 << B_AUD1SWEEP_DIR
        .DEFINE AUD1SWEEP_UP 0 << B_AUD1SWEEP_DIR
        .DEFINE AUD1SWEEP_DOWN 1 << B_AUD1SWEEP_DIR

.DEFINE AUD1SWEEP_SHIFT %00000111 ; how much the period increases/decreases per iteration [r/w]

; -- AUD1LEN / NR11 ($FF11) ---------------------------------------------------
; Audio channel 1 length timer and duty cycle
.DEFINE rAUD1LEN $FF11

.DEFINE AUD1LEN_DUTY %11000000 ; ratio of time spent high vs. time spent low [r/w]
    .DEFINE AUD1LEN_DUTY_12_5 %00000000 ; 12.5%
    .DEFINE AUD1LEN_DUTY_25 %01000000 ; 25%
    .DEFINE AUD1LEN_DUTY_50 %10000000 ; 50%
    .DEFINE AUD1LEN_DUTY_75 %11000000 ; 75%

.DEFINE AUD1LEN_TIMER %00111111 ; initial length timer (0-63) [wo]

; -- AUD1ENV / NR12 ($FF12) ---------------------------------------------------
; Audio channel 1 volume and envelope
.DEFINE rAUD1ENV $FF12

.DEFINE AUD1ENV_INIT_VOLUME %11110000 ; initial volume [r/w]

.DEFINE B_AUD1ENV_DIR 3 ; direction of volume envelope [r/w]
    .DEFINE AUD1ENV_DIR 1 << B_AUD1ENV_DIR
        .DEFINE AUD1ENV_DOWN 0 << B_AUD1ENV_DIR
        .DEFINE AUD1ENV_UP 1 << B_AUD1ENV_DIR

.DEFINE AUD1ENV_PACE %00000111 ; how long between envelope iterations
                                ; (in 64 Hz ticks, ~15.6 ms apart) [r/w]

; -- AUD1LOW / NR13 ($FF13) ---------------------------------------------------
; Audio channel 1 period (low 8 bits) [wo]
.DEFINE rAUD1LOW $FF13

; -- AUD1HIGH / NR14 ($FF14) --------------------------------------------------
; Audio channel 1 period (high 3 bits) and control
.DEFINE rAUD1HIGH $FF14

.DEFINE B_AUD1HIGH_RESTART 7 ; 1 = restart the channel [wo]
.DEFINE B_AUD1HIGH_LEN_ENABLE 6 ; 1 = reset the channel after the length timer expires [r/w]
    .DEFINE AUD1HIGH_RESTART 1 << B_AUD1HIGH_RESTART
    .DEFINE AUD1HIGH_LENGTH_OFF 0 << B_AUD1HIGH_LEN_ENABLE
    .DEFINE AUD1HIGH_LENGTH_ON 1 << B_AUD1HIGH_LEN_ENABLE

.DEFINE AUD1HIGH_PERIOD_HIGH %00000111 ; upper 3 bits of the channel's period [r/w]

; -- $FF15 is unused ----------------------------------------------------------

; -- AUD2LEN / NR21 ($FF16) ---------------------------------------------------
; Audio channel 2 length timer and duty cycle
.DEFINE rAUD2LEN $FF16

.DEFINE AUD2LEN_DUTY %11000000 ; ratio of time spent high vs. time spent low [r/w]
    .DEFINE AUD2LEN_DUTY_12_5 %00000000 ; 12.5%
    .DEFINE AUD2LEN_DUTY_25 %01000000 ; 25%
    .DEFINE AUD2LEN_DUTY_50 %10000000 ; 50%
    .DEFINE AUD2LEN_DUTY_75 %11000000 ; 75%

.DEFINE AUD2LEN_TIMER %00111111 ; initial length timer (0-63) [wo]

; -- AUD2ENV / NR22 ($FF17) ---------------------------------------------------
; Audio channel 2 volume and envelope
.DEFINE rAUD2ENV $FF17

.DEFINE AUD2ENV_INIT_VOLUME %11110000 ; initial volume [r/w]

.DEFINE B_AUD2ENV_DIR 3 ; direction of volume envelope [r/w]
    .DEFINE AUD2ENV_DIR 1 << B_AUD2ENV_DIR
        .DEFINE AUD2ENV_DOWN 0 << B_AUD2ENV_DIR
        .DEFINE AUD2ENV_UP 1 << B_AUD2ENV_DIR

.DEFINE AUD2ENV_PACE %00000111 ; how long between envelope iterations
                                ; (in 64 Hz ticks, ~15.6 ms apart) [r/w]

; -- AUD2LOW / NR23 ($FF18) ---------------------------------------------------
; Audio channel 2 period (low 8 bits) [wo]
.DEFINE rAUD2LOW $FF18

; -- AUD2HIGH / NR24 ($FF19) --------------------------------------------------
; Audio channel 2 period (high 3 bits) and control
.DEFINE rAUD2HIGH $FF19

.DEFINE B_AUD2HIGH_RESTART 7 ; 1 = restart the channel [wo]
.DEFINE B_AUD2HIGH_LEN_ENABLE 6 ; 1 = reset the channel after the length timer expires [r/w]
    .DEFINE AUD2HIGH_RESTART 1 << B_AUD2HIGH_RESTART
    .DEFINE AUD2HIGH_LENGTH_OFF 0 << B_AUD2HIGH_LEN_ENABLE
    .DEFINE AUD2HIGH_LENGTH_ON 1 << B_AUD2HIGH_LEN_ENABLE

.DEFINE AUD2HIGH_PERIOD_HIGH %00000111 ; upper 3 bits of the channel's period [r/w]

; -- AUD3ENA / NR30 ($FF1A) ---------------------------------------------------
; Audio channel 3 enable
.DEFINE rAUD3ENA $FF1A

.DEFINE B_AUD3ENA_ENABLE 7 ; 1 = channel is active [r/w]
    .DEFINE AUD3ENA_OFF 0 << B_AUD3ENA_ENABLE
    .DEFINE AUD3ENA_ON 1 << B_AUD3ENA_ENABLE

; -- AUD3LEN / NR31 ($FF1B) ---------------------------------------------------
; Audio channel 3 length timer [wo]
.DEFINE rAUD3LEN $FF1B

; -- AUD3LEVEL / NR32 ($FF1C) -------------------------------------------------
; Audio channel 3 volume
.DEFINE rAUD3LEVEL $FF1C

.DEFINE AUD3LEVEL_VOLUME %01100000 ; volume level [r/w]
    .DEFINE AUD3LEVEL_MUTE %00000000 ; 0% (muted)
    .DEFINE AUD3LEVEL_100 %00100000 ; 100%
    .DEFINE AUD3LEVEL_50 %01000000 ; 50%
    .DEFINE AUD3LEVEL_25 %01100000 ; 25%

; -- AUD3LOW / NR33 ($FF1D) ---------------------------------------------------
; Audio channel 3 period (low 8 bits) [wo]
.DEFINE rAUD3LOW $FF1D

; -- AUD3HIGH / NR34 ($FF1E) --------------------------------------------------
; Audio channel 3 period (high 3 bits) and control
.DEFINE rAUD3HIGH $FF1E

.DEFINE B_AUD3HIGH_RESTART 7 ; 1 = restart the channel [wo]
.DEFINE B_AUD3HIGH_LEN_ENABLE 6 ; 1 = reset the channel after the length timer expires [r/w]
    .DEFINE AUD3HIGH_RESTART 1 << B_AUD3HIGH_RESTART
    .DEFINE AUD3HIGH_LENGTH_OFF 0 << B_AUD3HIGH_LEN_ENABLE
    .DEFINE AUD3HIGH_LENGTH_ON 1 << B_AUD3HIGH_LEN_ENABLE

.DEFINE AUD3HIGH_PERIOD_HIGH %00000111 ; upper 3 bits of the channel's period [r/w]

; -- $FF1F is unused ----------------------------------------------------------

; -- AUD4LEN / NR41 ($FF20) ---------------------------------------------------
; Audio channel 4 length timer
.DEFINE rAUD4LEN $FF20

.DEFINE AUD4LEN_TIMER %00111111 ; initial length timer (0-63) [wo]

; -- AUD4ENV / NR42 ($FF21) ---------------------------------------------------
; Audio channel 4 volume and envelope
.DEFINE rAUD4ENV $FF21

.DEFINE AUD4ENV_INIT_VOLUME %11110000 ; initial volume [r/w]

.DEFINE B_AUD4ENV_DIR 3 ; direction of volume envelope [r/w]
    .DEFINE AUD4ENV_DIR 1 << B_AUD4ENV_DIR
        .DEFINE AUD4ENV_DOWN 0 << B_AUD4ENV_DIR
        .DEFINE AUD4ENV_UP 1 << B_AUD4ENV_DIR

.DEFINE AUD4ENV_PACE %00000111 ; how long between envelope iterations
                                ; (in 64 Hz ticks, ~15.6 ms apart) [r/w]

; -- AUD4POLY / NR43 ($FF22) --------------------------------------------------
; Audio channel 4 period and randomness
.DEFINE rAUD4POLY $FF22

.DEFINE AUD4POLY_SHIFT %11110000 ; coarse control of the channel's period [r/w]

.DEFINE B_AUD4POLY_WIDTH 3 ; controls the noise generator (LFSR)'s step width [r/w]
    .DEFINE AUD4POLY_15STEP 0 << B_AUD4POLY_WIDTH
    .DEFINE AUD4POLY_7STEP 1 << B_AUD4POLY_WIDTH

.DEFINE AUD4POLY_DIV %00000111 ; fine control of the channel's period [r/w]

; -- AUD4GO / NR44 ($FF23) ----------------------------------------------------
; Audio channel 4 control
.DEFINE rAUD4GO $FF23

.DEFINE B_AUD4GO_RESTART 7 ; 1 = restart the channel [wo]
.DEFINE B_AUD4GO_LEN_ENABLE 6 ; 1 = reset the channel after the length timer expires [r/w]
    .DEFINE AUD4GO_RESTART 1 << B_AUD4GO_RESTART
    .DEFINE AUD4GO_LENGTH_OFF 0 << B_AUD4GO_LEN_ENABLE
    .DEFINE AUD4GO_LENGTH_ON 1 << B_AUD4GO_LEN_ENABLE

; -- AUDVOL / NR50 ($FF24) ----------------------------------------------------
; Audio master volume and VIN mixer
.DEFINE rAUDVOL $FF24

.DEFINE B_AUDVOL_VIN_LEFT 7 ; 1 = output VIN to left ear (SO2, speaker 2) [r/w]
    .DEFINE AUDVOL_VIN_LEFT 1 << B_AUDVOL_VIN_LEFT

.DEFINE AUDVOL_LEFT %01110000 ; 0 = barely audible, 7 = full volume [r/w]

.DEFINE B_AUDVOL_VIN_RIGHT 3 ; 1 = output VIN to right ear (SO1, speaker 1) [r/w]
    .DEFINE AUDVOL_VIN_RIGHT 1 << B_AUDVOL_VIN_RIGHT

.DEFINE AUDVOL_RIGHT %00000111 ; 0 = barely audible, 7 = full volume [r/w]

; -- AUDTERM / NR51 ($FF25) ---------------------------------------------------
; Audio channel mixer
.DEFINE rAUDTERM $FF25

.DEFINE B_AUDTERM_4_LEFT 7 ; 1 = output channel 4 to left  ear [r/w]
.DEFINE B_AUDTERM_3_LEFT 6 ; 1 = output channel 3 to left  ear [r/w]
.DEFINE B_AUDTERM_2_LEFT 5 ; 1 = output channel 2 to left  ear [r/w]
.DEFINE B_AUDTERM_1_LEFT 4 ; 1 = output channel 1 to left  ear [r/w]
.DEFINE B_AUDTERM_4_RIGHT 3 ; 1 = output channel 4 to right ear [r/w]
.DEFINE B_AUDTERM_3_RIGHT 2 ; 1 = output channel 3 to right ear [r/w]
.DEFINE B_AUDTERM_2_RIGHT 1 ; 1 = output channel 2 to right ear [r/w]
.DEFINE B_AUDTERM_1_RIGHT 0 ; 1 = output channel 1 to right ear [r/w]
    .DEFINE AUDTERM_4_LEFT 1 << B_AUDTERM_4_LEFT
    .DEFINE AUDTERM_3_LEFT 1 << B_AUDTERM_3_LEFT
    .DEFINE AUDTERM_2_LEFT 1 << B_AUDTERM_2_LEFT
    .DEFINE AUDTERM_1_LEFT 1 << B_AUDTERM_1_LEFT
    .DEFINE AUDTERM_4_RIGHT 1 << B_AUDTERM_4_RIGHT
    .DEFINE AUDTERM_3_RIGHT 1 << B_AUDTERM_3_RIGHT
    .DEFINE AUDTERM_2_RIGHT 1 << B_AUDTERM_2_RIGHT
    .DEFINE AUDTERM_1_RIGHT 1 << B_AUDTERM_1_RIGHT

; -- AUDENA / NR52 ($FF26) ----------------------------------------------------
; Audio master enable
.DEFINE rAUDENA $FF26

.DEFINE B_AUDENA_ENABLE 7 ; 0 = disable the APU (resets all audio registers to 0!) [r/w]
.DEFINE B_AUDENA_ENABLE_CH4 3 ; 1 = channel 4 is running [ro]
.DEFINE B_AUDENA_ENABLE_CH3 2 ; 1 = channel 3 is running [ro]
.DEFINE B_AUDENA_ENABLE_CH2 1 ; 1 = channel 2 is running [ro]
.DEFINE B_AUDENA_ENABLE_CH1 0 ; 1 = channel 1 is running [ro]
    .DEFINE AUDENA_OFF 0 << B_AUDENA_ENABLE
    .DEFINE AUDENA_ON 1 << B_AUDENA_ENABLE
    .DEFINE AUDENA_CH4_OFF 0 << B_AUDENA_ENABLE_CH4
    .DEFINE AUDENA_CH4_ON 1 << B_AUDENA_ENABLE_CH4
    .DEFINE AUDENA_CH3_OFF 0 << B_AUDENA_ENABLE_CH3
    .DEFINE AUDENA_CH3_ON 1 << B_AUDENA_ENABLE_CH3
    .DEFINE AUDENA_CH2_OFF 0 << B_AUDENA_ENABLE_CH2
    .DEFINE AUDENA_CH2_ON 1 << B_AUDENA_ENABLE_CH2
    .DEFINE AUDENA_CH1_OFF 0 << B_AUDENA_ENABLE_CH1
    .DEFINE AUDENA_CH1_ON 1 << B_AUDENA_ENABLE_CH1

; -- $FF27-$FF2F are unused ---------------------------------------------------

; -- AUD3WAVE ($FF30-$FF3F) ---------------------------------------------------
; Audio channel 3 wave pattern RAM [r/w]
.DEFINE rAUD3WAVE_0 $FF30
.DEFINE rAUD3WAVE_1 $FF31
.DEFINE rAUD3WAVE_2 $FF32
.DEFINE rAUD3WAVE_3 $FF33
.DEFINE rAUD3WAVE_4 $FF34
.DEFINE rAUD3WAVE_5 $FF35
.DEFINE rAUD3WAVE_6 $FF36
.DEFINE rAUD3WAVE_7 $FF37
.DEFINE rAUD3WAVE_8 $FF38
.DEFINE rAUD3WAVE_9 $FF39
.DEFINE rAUD3WAVE_A $FF3A
.DEFINE rAUD3WAVE_B $FF3B
.DEFINE rAUD3WAVE_C $FF3C
.DEFINE rAUD3WAVE_D $FF3D
.DEFINE rAUD3WAVE_E $FF3E
.DEFINE rAUD3WAVE_F $FF3F

; -- LCDC ($FF40) -------------------------------------------------------------
; PPU graphics control
.DEFINE rLCDC $FF40

.DEFINE B_LCDC_ENABLE 7 ; whether the PPU (and LCD) are turned on          [r/w]
.DEFINE B_LCDC_WIN_MAP 6 ; which tilemap the Window reads from              [r/w]
.DEFINE B_LCDC_WINDOW 5 ; whether the Window is enabled                    [r/w]
.DEFINE B_LCDC_BLOCKS 4 ; which "tile blocks" the BG and Window use        [r/w]
.DEFINE B_LCDC_BG_MAP 3 ; which tilemap the BG reads from                  [r/w]
.DEFINE B_LCDC_OBJ_SIZE 2 ; how many pixels tall each OBJ is                 [r/w]
.DEFINE B_LCDC_OBJS 1 ; whether OBJs are enabled                         [r/w]
.DEFINE B_LCDC_BG 0 ; (DMG only) whether the BG is enabled             [r/w]
.DEFINE B_LCDC_PRIO 0 ; (CGB only) whether OBJ priority bits are enabled [r/w]
    .DEFINE LCDC_ENABLE 1 << B_LCDC_ENABLE
        .DEFINE LCDC_OFF 0 << B_LCDC_ENABLE
        .DEFINE LCDC_ON 1 << B_LCDC_ENABLE
    .DEFINE LCDC_WIN_MAP 1 << B_LCDC_WIN_MAP
        .DEFINE LCDC_WIN_9800 0 << B_LCDC_WIN_MAP
        .DEFINE LCDC_WIN_9C00 1 << B_LCDC_WIN_MAP
    .DEFINE LCDC_WINDOW 1 << B_LCDC_WINDOW
        .DEFINE LCDC_WIN_OFF 0 << B_LCDC_WINDOW
        .DEFINE LCDC_WIN_ON 1 << B_LCDC_WINDOW
    .DEFINE LCDC_BLOCKS 1 << B_LCDC_BLOCKS
        .DEFINE LCDC_BLOCK21 0 << B_LCDC_BLOCKS
        .DEFINE LCDC_BLOCK01 1 << B_LCDC_BLOCKS
    .DEFINE LCDC_BG_MAP 1 << B_LCDC_BG_MAP
        .DEFINE LCDC_BG_9800 0 << B_LCDC_BG_MAP
        .DEFINE LCDC_BG_9C00 1 << B_LCDC_BG_MAP
    .DEFINE LCDC_OBJ_SIZE 1 << B_LCDC_OBJ_SIZE
        .DEFINE LCDC_OBJ_8 0 << B_LCDC_OBJ_SIZE
        .DEFINE LCDC_OBJ_16 1 << B_LCDC_OBJ_SIZE
    .DEFINE LCDC_OBJS 1 << B_LCDC_OBJS
        .DEFINE LCDC_OBJ_OFF 0 << B_LCDC_OBJS
        .DEFINE LCDC_OBJ_ON 1 << B_LCDC_OBJS
    .DEFINE LCDC_BG 1 << B_LCDC_BG
        .DEFINE LCDC_BG_OFF 0 << B_LCDC_BG
        .DEFINE LCDC_BG_ON 1 << B_LCDC_BG
    .DEFINE LCDC_PRIO 1 << B_LCDC_PRIO
        .DEFINE LCDC_PRIO_OFF 0 << B_LCDC_PRIO
        .DEFINE LCDC_PRIO_ON 1 << B_LCDC_PRIO

; -- STAT ($FF41) -------------------------------------------------------------
; Graphics status and interrupt control
.DEFINE rSTAT $FF41

.DEFINE B_STAT_LYC 6 ; 1 = LY match triggers the STAT interrupt [r/w]
.DEFINE B_STAT_MODE_2 5 ; 1 = OAM Scan triggers the PPU interrupt  [r/w]
.DEFINE B_STAT_MODE_1 4 ; 1 = VBlank triggers the PPU interrupt    [r/w]
.DEFINE B_STAT_MODE_0 3 ; 1 = HBlank triggers the PPU interrupt    [r/w]
.DEFINE B_STAT_LYCF 2 ; 1 = LY is currently equal to LYC         [ro]
.DEFINE B_STAT_BUSY 1 ; 1 = the PPU is currently accessing VRAM  [ro]
    .DEFINE STAT_LYC 1 << B_STAT_LYC
    .DEFINE STAT_MODE_2 1 << B_STAT_MODE_2
    .DEFINE STAT_MODE_1 1 << B_STAT_MODE_1
    .DEFINE STAT_MODE_0 1 << B_STAT_MODE_0
    .DEFINE STAT_LYCF 1 << B_STAT_LYCF
    .DEFINE STAT_BUSY 1 << B_STAT_BUSY

.DEFINE STAT_MODE %00000011 ; PPU's current status [ro]
    .DEFINE STAT_HBLANK %00000000 ; waiting after a line's rendering (HBlank)
    .DEFINE STAT_VBLANK %00000001 ; waiting between frames (VBlank)
    .DEFINE STAT_OAM %00000010 ; checking which OBJs will be rendered on this line (OAM scan)
    .DEFINE STAT_LCD %00000011 ; pushing pixels to the LCD

; -- SCY ($FF42) --------------------------------------------------------------
; Background Y scroll offset (in pixels) [r/w]
.DEFINE rSCY $FF42

; -- SCX ($FF43) --------------------------------------------------------------
; Background X scroll offset (in pixels) [r/w]
.DEFINE rSCX $FF43

; -- LY ($FF44) ---------------------------------------------------------------
; Y coordinate of the line currently processed by the PPU (0-153) [ro]
.DEFINE rLY $FF44

.DEFINE LY_VBLANK 144 ; 144-153 is the VBlank period

; -- LYC ($FF45) --------------------------------------------------------------
; Value that LY is constantly compared to [r/w]
.DEFINE rLYC $FF45

; -- DMA ($FF46) --------------------------------------------------------------
; OAM DMA start address (high 8 bits) and start [wo]
.DEFINE rDMA $FF46

; -- BGP ($FF47) --------------------------------------------------------------
; (DMG only) Background color mapping [r/w]
.DEFINE rBGP $FF47

.DEFINE BGP_SGB_TRANSFER %11100100 ; set BGP to this value before SGB VRAM transfer

; -- OBP0 ($FF48) -------------------------------------------------------------
; (DMG only) OBJ color mapping #0 [r/w]
.DEFINE rOBP0 $FF48

; -- OBP1 ($FF49) -------------------------------------------------------------
; (DMG only) OBJ color mapping #1 [r/w]
.DEFINE rOBP1 $FF49

; -- WY ($FF4A) ---------------------------------------------------------------
; Y coordinate of the Window's top-left pixel (0-143) [r/w]
.DEFINE rWY $FF4A

; -- WX ($FF4B) ---------------------------------------------------------------
; X coordinate of the Window's top-left pixel, plus 7 (7-166) [r/w]
.DEFINE rWX $FF4B

.DEFINE WX_OFS 7 ; subtract this to get the actual Window X coordinate

; -- SYS / KEY0 ($FF4C) -------------------------------------------------------
; (CGB boot ROM only) CPU mode select
.DEFINE rSYS $FF4C

; This is known as the "CPU mode register" in Fig. 11 of this patent:
; https://patents.google.com/patent/US6322447B1/en?oq=US6322447bi
; "OBJ priority mode designating register" in the same patent
; Credit to @mattcurrie for this finding!

.DEFINE SYS_MODE %00001100 ; current system mode [r/w]
    .DEFINE SYS_CGB %00000000 ; CGB mode
    .DEFINE SYS_DMG %00000100 ; DMG compatibility mode
    .DEFINE SYS_PGB1 %00001000 ; LCD is driven externally, CPU is stopped
    .DEFINE SYS_PGB2 %00001100 ; LCD is driven externally, CPU is running

; -- SPD / KEY1 ($FF4D) -------------------------------------------------------
; (CGB only) Double-speed mode control
.DEFINE rSPD $FF4D

.DEFINE B_SPD_DOUBLE 7 ; current clock speed                                  [ro]
.DEFINE B_SPD_PREPARE 0 ; 1 = next `stop` instruction will switch clock speeds [r/w]
    .DEFINE SPD_SINGLE 0 << B_SPD_DOUBLE
    .DEFINE SPD_DOUBLE 1 << B_SPD_DOUBLE
    .DEFINE SPD_PREPARE 1 << B_SPD_PREPARE

; -- $FF4E is unused ----------------------------------------------------------

; -- VBK ($FF4F) --------------------------------------------------------------
; (CGB only) VRAM bank number (0 or 1)
.DEFINE rVBK $FF4F

.DEFINE VBK_BANK %00000001 ; mapped VRAM bank [r/w]

; -- BANK ($FF50) -------------------------------------------------------------
; (boot ROM only) Boot ROM mapping control
.DEFINE rBANK $FF50

.DEFINE B_BANK_ON 0 ; whether the boot ROM is mapped [wo]
    .DEFINE BANK_ON 0 << B_BANK_ON
    .DEFINE BANK_OFF 1 << B_BANK_ON

; -- VDMA_SRC_HIGH / HDMA1 ($FF51) --------------------------------------------
; (CGB only) VRAM DMA source address (high 8 bits) [wo]
.DEFINE rVDMA_SRC_HIGH $FF51

; -- VDMA_SRC_LOW / HDMA2 ($FF52) ---------------------------------------------
; (CGB only) VRAM DMA source address (low 8 bits) [wo]
.DEFINE rVDMA_SRC_LOW $FF52

; -- VDMA_DEST_HIGH / HDMA3 ($FF53) -------------------------------------------
; (CGB only) VRAM DMA destination address (high 8 bits) [wo]
.DEFINE rVDMA_DEST_HIGH $FF53

; -- VDMA_DEST_LOW / HDMA4 ($FF54) --------------------------------------------
; (CGB only) VRAM DMA destination address (low 8 bits) [wo]
.DEFINE rVDMA_DEST_LOW $FF54

; -- VDMA_LEN / HDMA5 ($FF55) -------------------------------------------------
; (CGB only) VRAM DMA length, mode, and start
.DEFINE rVDMA_LEN $FF55

.DEFINE B_VDMA_LEN_MODE 7 ; on write: VRAM DMA mode [wo]
    .DEFINE VDMA_LEN_MODE 1 << B_VDMA_LEN_MODE
        .DEFINE VDMA_LEN_MODE_GENERAL 0 << B_VDMA_LEN_MODE ; GDMA (general-purpose)
        .DEFINE VDMA_LEN_MODE_HBLANK 1 << B_VDMA_LEN_MODE ; HDMA (HBlank)

.DEFINE B_VDMA_LEN_BUSY 7 ; on read: is a VRAM DMA active?
    .DEFINE VDMA_LEN_BUSY 1 << B_VDMA_LEN_BUSY
        .DEFINE VDMA_LEN_NO 0 << B_VDMA_LEN_BUSY
        .DEFINE VDMA_LEN_YES 1 << B_VDMA_LEN_BUSY

.DEFINE VDMA_LEN_SIZE %01111111 ; how many 16-byte blocks (minus 1) to transfer [r/w]

; -- RP ($FF56) ---------------------------------------------------------------
; (CGB only) Infrared communications port
.DEFINE rRP $FF56

.DEFINE RP_READ %11000000 ; whether the IR read is enabled [r/w]
    .DEFINE RP_DISABLE %00000000
    .DEFINE RP_ENABLE %11000000

.DEFINE B_RP_DATA_IN 1 ; 0 = IR light is being received [ro]
.DEFINE B_RP_LED_ON 0 ; 1 = IR light is being sent     [r/w]
    .DEFINE RP_DATA_IN 1 << B_RP_DATA_IN
    .DEFINE RP_LED_ON 1 << B_RP_LED_ON
        .DEFINE RP_WRITE_LOW 0 << B_RP_LED_ON
        .DEFINE RP_WRITE_HIGH 1 << B_RP_LED_ON

; -- $FF57-$FF67 are unused ---------------------------------------------------

; -- BGPI / BCPS ($FF68) ------------------------------------------------------
; (CGB only) Background palette I/O index
.DEFINE rBGPI $FF68

.DEFINE B_BGPI_AUTOINC 7 ; whether the index field is incremented after each write to BCPD [r/w]
    .DEFINE BGPI_AUTOINC 1 << B_BGPI_AUTOINC

.DEFINE BGPI_INDEX %00111111 ; the index within Palette RAM accessed via BCPD [r/w]

; -- BGPD / BCPD ($FF69) ------------------------------------------------------
; (CGB only) Background palette I/O access [r/w]
.DEFINE rBGPD $FF69

; -- OBPI / OCPS ($FF6A) ------------------------------------------------------
; (CGB only) OBJ palette I/O index
.DEFINE rOBPI $FF6A

.DEFINE B_OBPI_AUTOINC 7 ; whether the index field is incremented after each write to OBPD [r/w]
    .DEFINE OBPI_AUTOINC 1 << B_OBPI_AUTOINC

.DEFINE OBPI_INDEX %00111111 ; the index within Palette RAM accessed via OBPD [r/w]

; -- OBPD / OCPD ($FF6B) ------------------------------------------------------
; (CGB only) OBJ palette I/O access [r/w]
.DEFINE rOBPD $FF6B

; -- OPRI ($FF6C) -------------------------------------------------------------
; (CGB boot ROM only) OBJ draw priority mode
.DEFINE rOPRI $FF6C

.DEFINE B_OPRI_PRIORITY 0 ; which drawing priority is used for OBJs [r/w]
    .DEFINE OPRI_PRIORITY 1 << B_OPRI_PRIORITY
        .DEFINE OPRI_OAM 0 << B_OPRI_PRIORITY ; CGB mode default: earliest OBJ in OAM wins
        .DEFINE OPRI_COORD 1 << B_OPRI_PRIORITY ; DMG mode default: leftmost OBJ wins

; -- $FF6D-$FF6F are unused ---------------------------------------------------

; -- WBK / SVBK ($FF70) -------------------------------------------------------
; (CGB only) WRAM bank number
.DEFINE rWBK $FF70

.DEFINE WBK_BANK %00000111 ; mapped WRAM bank (0-7) [r/w]

; -- $FF71-$FF75 are unused ---------------------------------------------------

; -- PCM12 ($FF76) ------------------------------------------------------------
; Audio channels 1 and 2 output
.DEFINE rPCM12 $FF76

.DEFINE PCM12_CH2 %11110000 ; audio channel 2 output [ro]
.DEFINE PCM12_CH1 %00001111 ; audio channel 1 output [ro]

; -- PCM34 ($FF77) ------------------------------------------------------------
; Audio channels 3 and 4 output
.DEFINE rPCM34 $FF77

.DEFINE PCM34_CH4 %11110000 ; audio channel 4 output [ro]
.DEFINE PCM34_CH3 %00001111 ; audio channel 3 output [ro]

; -- $FF78-$FF7F are unused ---------------------------------------------------

; -- IE ($FFFF) ---------------------------------------------------------------
; Interrupt enable
.DEFINE rIE $FFFF

.DEFINE B_IE_JOYPAD 4 ; 1 = joypad interrupt is enabled [r/w]
.DEFINE B_IE_SERIAL 3 ; 1 = serial interrupt is enabled [r/w]
.DEFINE B_IE_TIMER 2 ; 1 = timer  interrupt is enabled [r/w]
.DEFINE B_IE_STAT 1 ; 1 = STAT   interrupt is enabled [r/w]
.DEFINE B_IE_VBLANK 0 ; 1 = VBlank interrupt is enabled [r/w]
    .DEFINE IE_JOYPAD 1 << B_IE_JOYPAD
    .DEFINE IE_SERIAL 1 << B_IE_SERIAL
    .DEFINE IE_TIMER 1 << B_IE_TIMER
    .DEFINE IE_STAT 1 << B_IE_STAT
    .DEFINE IE_VBLANK 1 << B_IE_VBLANK


;******************************************************************************
; Cartridge registers (MBC)
;******************************************************************************

; Note that these "registers" are each actually accessible at an entire address range;
; however, one address for each of these ranges is considered the "canonical" one, and
; these addresses are what's provided here.


; ** Common to most MBCs ******************************************************

; -- RAMG ($0000-$1FFF) -------------------------------------------------------
; Whether SRAM can be accessed [wo]
.DEFINE rRAMG $0000

; Common values (not for HuC1 or HuC-3)
.DEFINE RAMG_SRAM_DISABLE $00
.DEFINE RAMG_SRAM_ENABLE $0A ; some MBCs accept any value whose low nybble is $A

; (HuC-3 only) switch SRAM to map cartridge RAM, RTC, or IR
.DEFINE RAMG_CART_RAM_RO $00 ; select cartridge RAM [ro]
.DEFINE RAMG_CART_RAM $0A ; select cartridge RAM [r/w]
.DEFINE RAMG_RTC_IN $0B ; select RTC command/argument [wo]
    .DEFINE RAMG_RTC_IN_CMD %01110000 ; command
    .DEFINE RAMG_RTC_IN_ARG %00001111 ; argument
.DEFINE RAMG_RTC_OUT $0C ; select RTC command/response [ro]
    .DEFINE RAMG_RTC_OUT_CMD %01110000 ; command
    .DEFINE RAMG_RTC_OUT_RESULT %00001111 ; result
.DEFINE RAMG_RTC_SEMAPHORE $0D ; select RTC semaphore [r/w]
.DEFINE RAMG_IR $0E ; (HuC1 and HuC-3 only) select IR [r/w]

; -- ROMB ($2000-$3FFF) -------------------------------------------------------
; ROM bank number (not for MBC5 or MBC6) [wo]
.DEFINE rROMB $2000

; -- RAMB ($4000-$5FFF) -------------------------------------------------------
; SRAM bank number (not for MBC2, MBC6, or MBC7) [wo]
.DEFINE rRAMB $4000

; (MBC3 only) Special RAM bank numbers that actually map values into RTCREG
.DEFINE RAMB_RTC_S $08 ; seconds counter (0-59)
.DEFINE RAMB_RTC_M $09 ; minutes counter (0-59)
.DEFINE RAMB_RTC_H $0A ; hours counter (0-23)
.DEFINE RAMB_RTC_DL $0B ; days counter, low byte (0-255)
.DEFINE RAMB_RTC_DH $0C ; days counter, high bit and other flags
    .DEFINE B_RAMB_RTC_DH_CARRY 7 ; 1 = days counter overflowed    [wo]
    .DEFINE B_RAMB_RTC_DH_HALT 6 ; 0 = run timer, 1 = stop timer  [wo]
    .DEFINE B_RAMB_RTC_DH_HIGH 0 ; days counter, high bit (bit 8) [wo]
        .DEFINE RAMB_RTC_DH_CARRY 1 << B_RAMB_RTC_DH_CARRY
        .DEFINE RAMB_RTC_DH_HALT 1 << B_RAMB_RTC_DH_HALT
        .DEFINE RAMB_RTC_DH_HIGH 1 << B_RAMB_RTC_DH_HIGH

.DEFINE B_RAMB_RUMBLE 3 ; (MBC5 and MBC7 only) enable the rumble motor (if any)
    .DEFINE RAMB_RUMBLE 1 << B_RAMB_RUMBLE
        .DEFINE RAMB_RUMBLE_OFF 0 << B_RAMB_RUMBLE
        .DEFINE RAMB_RUMBLE_ON 1 << B_RAMB_RUMBLE


; ** MBC1 and MMM01 only ******************************************************

; -- BMODE ($6000-$7FFF) ------------------------------------------------------
; Banking mode select [wo]
.DEFINE rBMODE $6000

.DEFINE BMODE_SIMPLE $00 ; locks ROMB and RAMB to bank 0
.DEFINE BMODE_ADVANCED $01 ; allows bank-switching with RAMB


; ** MBC2 only ****************************************************************

; -- ROM2B ($0000-$3FFF with bit 8 set) ---------------------------------------
; ROM bank number [wo]
.DEFINE rROM2B $2100


; ** MBC3 only ****************************************************************

; -- RTCLATCH ($6000-$7FFF) ---------------------------------------------------
; RTC latch clock data [wo]
.DEFINE rRTCLATCH $6000

; Write $00 then $01 to latch the current time into RTCREG
.DEFINE RTCLATCH_START $00
.DEFINE RTCLATCH_FINISH $01

; -- RTCREG ($A000-$BFFF) -----------------------------------------------------
; RTC register [r/w]
.DEFINE rRTCREG $A000


; ** MBC5 only ****************************************************************

; -- ROMB0 ($2000-$2FFF) ------------------------------------------------------
; ROM bank number low byte (bits 0-7) [wo]
.DEFINE rROMB0 $2000

; -- ROMB1 ($3000-$3FFF) ------------------------------------------------------
; ROM bank number high bit (bit 8) [wo]
.DEFINE rROMB1 $3000


; ** MBC6 only ****************************************************************

; -- RAMBA ($0400-$07FF) ------------------------------------------------------
; RAM bank A number [wo]
.DEFINE rRAMBA $0400

; -- RAMBB ($0800-$0BFF) ------------------------------------------------------
; RAM bank B number [wo]
.DEFINE rRAMBB $0800

; -- FLASH ($0C00-$0FFF) ------------------------------------------------------
; Whether the flash chip can be accessed [wo]
.DEFINE rFLASH $0C00

; -- FMODE ($1000) ------------------------------------------------------------
; Write mode select for the flash chip
.DEFINE rFMODE $1000

; -- ROMBA ($2000-$27FF) ------------------------------------------------------
; ROM/Flash bank A number [wo]
.DEFINE rROMBA $2000

; -- FLASHA ($2800-$2FFF) -----------------------------------------------------
; ROM/Flash bank A select [wo]
.DEFINE rFLASHA $2800

; -- ROMBB ($3000-$37FF) ------------------------------------------------------
; ROM/Flash bank B number [wo]
.DEFINE rROMBB $3000

; -- FLASHB ($3800-$3FFF) -----------------------------------------------------
; ROM/Flash bank B select [wo]
.DEFINE rFLASHB $3800


; ** MBC7 only ****************************************************************

; -- RAMREG ($4000-$5FFF) -----------------------------------------------------
; Enable RAM register access [wo]
.DEFINE rRAMREG $4000

.DEFINE RAMREG_ENABLE $40

; -- ACCLATCH0 ($Ax0x) --------------------------------------------------------
; Latch accelerometer start [wo]
.DEFINE rACCLATCH0 $A000

; Write $55 to ACCLATCH0 to erase the latched data
.DEFINE ACCLATCH0_START $55

; -- ACCLATCH1 ($Ax1x) --------------------------------------------------------
; Latch accelerometer finish [wo]
.DEFINE rACCLATCH1 $A010

; Write $AA to ACCLATCH1 to latch the accelerometer and update ACCEL*
.DEFINE ACCLATCH1_FINISH $AA

; -- ACCELX0 ($Ax2x) ----------------------------------------------------------
; Accelerometer X value low byte [ro]
.DEFINE rACCELX0 $A020

; -- ACCELX1 ($Ax3x) ----------------------------------------------------------
; Accelerometer X value high byte [ro]
.DEFINE rACCELX1 $A030

; -- ACCELY0 ($Ax4x) ----------------------------------------------------------
; Accelerometer Y value low byte [ro]
.DEFINE rACCELY0 $A040

; -- ACCELY1 ($Ax5x) ----------------------------------------------------------
; Accelerometer Y value high byte [ro]
.DEFINE rACCELY1 $A050

; -- EEPROM ($Ax8x) -----------------------------------------------------------
; EEPROM access [r/w]
.DEFINE rEEPROM $A080


; ** HuC1 only ****************************************************************

; -- IRREG ($A000-$BFFF) ------------------------------------------------------
; IR register [r/w]
.DEFINE rIRREG $A000

; whether the IR transmitter sees light
.DEFINE IR_LED_OFF $C0
.DEFINE IR_LED_ON $C1


;******************************************************************************
; Screen-related constants
;******************************************************************************

.DEFINE SCREEN_WIDTH_PX 160 ; width of screen in pixels
.DEFINE SCREEN_HEIGHT_PX 144 ; height of screen in pixels
.DEFINE SCREEN_WIDTH 20 ; width of screen in bytes
.DEFINE SCREEN_HEIGHT 18 ; height of screen in bytes
.DEFINE SCREEN_AREA SCREEN_WIDTH * SCREEN_HEIGHT ; size of screen in bytes

.DEFINE TILEMAP_WIDTH_PX 256 ; width of tilemap in pixels
.DEFINE TILEMAP_HEIGHT_PX 256 ; height of tilemap in pixels
.DEFINE TILEMAP_WIDTH 32 ; width of tilemap in bytes
.DEFINE TILEMAP_HEIGHT 32 ; height of tilemap in bytes
.DEFINE TILEMAP_AREA TILEMAP_WIDTH * TILEMAP_HEIGHT ; size of tilemap in bytes

.DEFINE TILE_WIDTH 8 ; width of tile in pixels
.DEFINE TILE_HEIGHT 8 ; height of tile in pixels
.DEFINE TILE_SIZE 16 ; size of tile in bytes (2 bits/pixel)

.DEFINE COLOR_SIZE 2 ; size of color in bytes (little-endian BGR555)
.DEFINE PAL_COLORS 4 ; colors per palette
.DEFINE PAL_SIZE COLOR_SIZE * PAL_COLORS ; size of palette in bytes

.DEFINE COLOR_CH_WIDTH 5 ; bits per RGB color channel
.DEFINE COLOR_CH_MAX (1 << COLOR_CH_WIDTH) - 1
    .DEFINE B_COLOR_RED COLOR_CH_WIDTH * 0 ; bits 4-0
    .DEFINE B_COLOR_GREEN COLOR_CH_WIDTH * 1 ; bits 9-5
    .DEFINE B_COLOR_BLUE COLOR_CH_WIDTH * 2 ; bits 14-10
        .DEFINE COLOR_RED %00011111  ; for the low byte
        .DEFINE COLOR_GREEN_LOW %11100000  ; for the low byte
        .DEFINE COLOR_GREEN_HIGH %00000011 ; for the high byte
        .DEFINE COLOR_BLUE %01111100 ; for the high byte

; (DMG only) grayscale shade indexes for BGP, OBP0, and OBP1
.DEFINE SHADE_WHITE %00
.DEFINE SHADE_LIGHT %01
.DEFINE SHADE_DARK %10
.DEFINE SHADE_BLACK %11

; Tilemaps the BG or Window can read from (controlled by LCDC)
.DEFINE TILEMAP0 $9800 ; $9800-$9BFF
.DEFINE TILEMAP1 $9C00 ; $9C00-$9FFF

; (CGB only) BG tile attribute fields
.DEFINE B_BG_PRIO 7 ; whether the BG tile colors 1-3 are drawn above OBJs
.DEFINE B_BG_YFLIP 6 ; whether the whole BG tile is flipped vertically
.DEFINE B_BG_XFLIP 5 ; whether the whole BG tile is flipped horizontally
.DEFINE B_BG_BANK1 3 ; which VRAM bank the BG tile is taken from
.DEFINE BG_PALETTE %00000111 ; which palette the BG tile uses
    .DEFINE BG_PRIO 1 << B_BG_PRIO
    .DEFINE BG_YFLIP 1 << B_BG_YFLIP
    .DEFINE BG_XFLIP 1 << B_BG_XFLIP
    .DEFINE BG_BANK0 0 << B_BG_BANK1
    .DEFINE BG_BANK1 1 << B_BG_BANK1


;******************************************************************************
; OBJ-related constants
;******************************************************************************

; OAM attribute field offsets
.DEFINE OAMA_Y 0
    .DEFINE OAM_Y_OFS 16 ; subtract 16 from what's written to OAM to get the real Y position
.DEFINE OAMA_X 1
    .DEFINE OAM_X_OFS 8 ; subtract 8 from what's written to OAM to get the real X position
.DEFINE OAMA_TILEID 2
.DEFINE OAMA_FLAGS 3
    .DEFINE B_OAM_PRIO 7 ; whether the OBJ is drawn below BG colors 1-3
    .DEFINE B_OAM_YFLIP 6 ; whether the whole OBJ is flipped vertically
    .DEFINE B_OAM_XFLIP 5 ; whether the whole OBJ is flipped horizontally
    .DEFINE B_OAM_PAL1 4 ; (DMG only) which of the two palettes the OBJ uses
    .DEFINE B_OAM_BANK1 3 ; (CGB only) which VRAM bank the OBJ takes its tile(s) from
    .DEFINE OAM_PALETTE %00000111 ; (CGB only) which palette the OBJ uses
        .DEFINE OAM_PRIO 1 << B_OAM_PRIO
        .DEFINE OAM_YFLIP 1 << B_OAM_YFLIP
        .DEFINE OAM_XFLIP 1 << B_OAM_XFLIP
        .DEFINE OAM_PAL0 0 << B_OAM_PAL1
        .DEFINE OAM_PAL1 1 << B_OAM_PAL1
        .DEFINE OAM_BANK0 0 << B_OAM_BANK1
        .DEFINE OAM_BANK1 1 << B_OAM_BANK1
.DEFINE OBJ_SIZE 4

.DEFINE OAM_COUNT 40 ; how many OBJs there are room for in OAM
.DEFINE OAM_SIZE OBJ_SIZE * OAM_COUNT


;******************************************************************************
; Audio channel RAM addresses
;******************************************************************************

.DEFINE AUD1RAM $FF10 ; $FF10-$FF14
.DEFINE AUD2RAM $FF15 ; $FF15-$FF19
.DEFINE AUD3RAM $FF1A ; $FF1A-$FF1E
.DEFINE AUD4RAM $FF1F ; $FF1F-$FF23
.DEFINE AUDRAM_SIZE 5 ; size of each audio channel RAM in bytes

.DEFINE _AUD3WAVERAM $FF30 ; $FF30-$FF3F
.DEFINE AUD3WAVE_SIZE 16 ; size of wave pattern RAM in bytes


;******************************************************************************
; Interrupt vector addresses
;******************************************************************************

.DEFINE INT_HANDLER_VBLANK $0040 ; VBlank interrupt handler address
.DEFINE INT_HANDLER_STAT $0048 ; STAT   interrupt handler address
.DEFINE INT_HANDLER_TIMER $0050 ; timer  interrupt handler address
.DEFINE INT_HANDLER_SERIAL $0058 ; serial interrupt handler address
.DEFINE INT_HANDLER_JOYPAD $0060 ; joypad interrupt handler address


;******************************************************************************
; Boot-up register values
;******************************************************************************

; Register A = CPU type
.DEFINE BOOTUP_A_DMG $01
.DEFINE BOOTUP_A_CGB $11 ; CGB or AGB
.DEFINE BOOTUP_A_MGB $FF
    .DEFINE BOOTUP_A_SGB BOOTUP_A_DMG
    .DEFINE BOOTUP_A_SGB2 BOOTUP_A_MGB

; Register B = CPU qualifier (if A is BOOTUP_A_CGB)
.DEFINE B_BOOTUP_B_AGB 0
    .DEFINE BOOTUP_B_CGB 0 << B_BOOTUP_B_AGB
    .DEFINE BOOTUP_B_AGB 1 << B_BOOTUP_B_AGB

; Register C = CPU qualifier
.DEFINE BOOTUP_C_DMG $13
.DEFINE BOOTUP_C_SGB $14
.DEFINE BOOTUP_C_CGB $00 ; CGB or AGB

; Register D = color qualifier
.DEFINE BOOTUP_D_MONO $00 ; DMG, MGB, SGB, or CGB or AGB in DMG mode
.DEFINE BOOTUP_D_COLOR $FF ; CGB or AGB

; Register E = CPU qualifier (distinguishes DMG variants)
.DEFINE BOOTUP_E_DMG0 $C1
.DEFINE BOOTUP_E_DMG $C8
.DEFINE BOOTUP_E_SGB $00
.DEFINE BOOTUP_E_CGB_DMGMODE $08 ; CGB or AGB in DMG mode
.DEFINE BOOTUP_E_CGB $56 ; CGB or AGB


;******************************************************************************
; Aliases
;******************************************************************************

; Prefer the standard names to these aliases, which may be official but are
; less directly meaningful or human-readable.

.DEFINE rP1 rJOYP

.DEFINE rNR10 rAUD1SWEEP
.DEFINE rNR11 rAUD1LEN
.DEFINE rNR12 rAUD1ENV
.DEFINE rNR13 rAUD1LOW
.DEFINE rNR14 rAUD1HIGH
.DEFINE rNR21 rAUD2LEN
.DEFINE rNR22 rAUD2ENV
.DEFINE rNR23 rAUD2LOW
.DEFINE rNR24 rAUD2HIGH
.DEFINE rNR30 rAUD3ENA
.DEFINE rNR31 rAUD3LEN
.DEFINE rNR32 rAUD3LEVEL
.DEFINE rNR33 rAUD3LOW
.DEFINE rNR34 rAUD3HIGH
.DEFINE rNR41 rAUD4LEN
.DEFINE rNR42 rAUD4ENV
.DEFINE rNR43 rAUD4POLY
.DEFINE rNR44 rAUD4GO
.DEFINE rNR50 rAUDVOL
.DEFINE rNR51 rAUDTERM
.DEFINE rNR52 rAUDENA

.DEFINE rKEY0 rSYS
.DEFINE rKEY1 rSPD

.DEFINE rHDMA1 rVDMA_SRC_HIGH
.DEFINE rHDMA2 rVDMA_SRC_LOW
.DEFINE rHDMA3 rVDMA_DEST_HIGH
.DEFINE rHDMA4 rVDMA_DEST_LOW
.DEFINE rHDMA5 rVDMA_LEN

.DEFINE rBCPS rBGPI
.DEFINE rBCPD rBGPD

.DEFINE rOCPS rOBPI
.DEFINE rOCPD rOBPD

.DEFINE rSVBK rWBK

.ENDIF ; HARDWARE_INC
