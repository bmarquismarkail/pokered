roms := \
	pokered.gbc \
	pokeblue.gbc \
	pokeblue_debug.gbc
patches := \
	pokered.patch \
	pokeblue.patch

rom_obj := \
	audio.o \
	home.o \
	main.o \
	maps.o \
	ram.o \
	text.o \
	gfx/pics.o \
	gfx/sprites.o \
	gfx/tilesets.o

pokered_obj        := $(rom_obj:.o=_red.o)
pokeblue_obj       := $(rom_obj:.o=_blue.o)
pokeblue_debug_obj := $(rom_obj:.o=_blue_debug.o)
pokered_vc_obj     := $(rom_obj:.o=_red_vc.o)
pokeblue_vc_obj    := $(rom_obj:.o=_blue_vc.o)


### Build tools

ifeq (,$(shell command -v sha1sum 2>/dev/null))
SHA1 := shasum
else
SHA1 := sha1sum
endif

RGBDS ?=
RGBASM  ?= $(RGBDS)rgbasm
RGBFIX  ?= $(RGBDS)rgbfix
RGBGFX  ?= $(RGBDS)rgbgfx
RGBLINK ?= $(RGBDS)rgblink

RGBASMFLAGS  ?= -Weverything -Wtruncation=1
RGBLINKFLAGS ?= -Weverything -Wtruncation=1
RGBFIXFLAGS  ?= -Weverything
RGBGFXFLAGS  ?= -Weverything


### Build targets

.SUFFIXES:
.SECONDEXPANSION:
.PRECIOUS:
.SECONDARY:
.PHONY: \
	all \
	red \
	blue \
	blue_debug \
	red_vc \
	blue_vc \
	wla-poc \
	wla-unit-poc \
	wla-red \
	rgbds-red \
	wla-check \
	wla-rom \
	wla-compare \
	wla-audit \
	wla-index-monolith \
	wla-check-split \
	wla-report \
	wla-reference \
	clean \
	tidy \
	compare \
	tools

all: $(roms)
red:        pokered.gbc
blue:       pokeblue.gbc
blue_debug: pokeblue_debug.gbc
red_vc:     pokered.patch
blue_vc:    pokeblue.patch

clean: tidy
	find gfx \
	     \( -iname '*.1bpp' \
	        -o -iname '*.2bpp' \
	        -o -iname '*.pic' \) \
	     -delete

tidy:
	$(RM) $(roms) \
	      $(roms:.gbc=.sym) \
	      $(roms:.gbc=.map) \
	      $(patches) \
	      $(patches:.patch=_vc.gbc) \
	      $(patches:.patch=_vc.sym) \
	      $(patches:.patch=_vc.map) \
	      $(patches:%.patch=vc/%.constants.sym) \
	      $(pokered_obj) \
	      $(pokeblue_obj) \
	      $(pokered_vc_obj) \
	      $(pokeblue_vc_obj) \
	      $(pokeblue_debug_obj) \
	      rgbdscheck.o
	$(MAKE) clean -C tools/

compare: $(roms) $(patches)
	@$(SHA1) -c roms.sha1

tools:
	$(MAKE) -C tools/


RGBASMFLAGS += -Q8 -P includes.asm
# Create a sym/map for debug purposes if `make` run with `DEBUG=1`
ifeq ($(DEBUG),1)
RGBASMFLAGS += -E
endif

$(pokered_obj):        RGBASMFLAGS += -D _RED
$(pokeblue_obj):       RGBASMFLAGS += -D _BLUE
$(pokeblue_debug_obj): RGBASMFLAGS += -D _BLUE -D _DEBUG
$(pokered_vc_obj):     RGBASMFLAGS += -D _RED -D _RED_VC
$(pokeblue_vc_obj):    RGBASMFLAGS += -D _BLUE -D _BLUE_VC

%.patch: %_vc.gbc %.gbc vc/%.patch.template
	tools/make_patch $*_vc.sym $^ $@

rgbdscheck.o: rgbdscheck.asm
	$(RGBASM) -o $@ $<

# Build tools when building the rom.
# This has to happen before the rules are processed, since that's when scan_includes is run.
ifeq (,$(filter clean tidy tools,$(MAKECMDGOALS)))

$(info $(shell $(MAKE) -C tools))

# The dep rules have to be explicit or else missing files won't be reported.
# As a side effect, they're evaluated immediately instead of when the rule is invoked.
# It doesn't look like $(shell) can be deferred so there might not be a better way.
preinclude_deps := includes.asm $(shell tools/scan_includes includes.asm)
define DEP
$1: $2 $$(shell tools/scan_includes $2) $(preinclude_deps) | rgbdscheck.o
	$$(RGBASM) $$(RGBASMFLAGS) -o $$@ $$<
endef

# Dependencies for objects (drop _red and _blue from asm file basenames)
$(foreach obj, $(pokered_obj), $(eval $(call DEP,$(obj),$(obj:_red.o=.asm))))
$(foreach obj, $(pokeblue_obj), $(eval $(call DEP,$(obj),$(obj:_blue.o=.asm))))
$(foreach obj, $(pokeblue_debug_obj), $(eval $(call DEP,$(obj),$(obj:_blue_debug.o=.asm))))
$(foreach obj, $(pokered_vc_obj), $(eval $(call DEP,$(obj),$(obj:_red_vc.o=.asm))))
$(foreach obj, $(pokeblue_vc_obj), $(eval $(call DEP,$(obj),$(obj:_blue_vc.o=.asm))))

endif


RGBLINKFLAGS += -d
pokered.gbc:        RGBLINKFLAGS += -p 0x00
pokeblue.gbc:       RGBLINKFLAGS += -p 0x00
pokeblue_debug.gbc: RGBLINKFLAGS += -p 0xff
pokered_vc.gbc:     RGBLINKFLAGS += -p 0x00
pokeblue_vc.gbc:    RGBLINKFLAGS += -p 0x00

RGBFIXFLAGS += -jsv -n 0 -k 01 -l 0x33 -m MBC3+RAM+BATTERY -r 03
pokered.gbc:        RGBFIXFLAGS += -p 0x00 -t "POKEMON RED"
pokeblue.gbc:       RGBFIXFLAGS += -p 0x00 -t "POKEMON BLUE"
pokeblue_debug.gbc: RGBFIXFLAGS += -p 0xff -t "POKEMON BLUE"
pokered_vc.gbc:     RGBFIXFLAGS += -p 0x00 -t "POKEMON RED"
pokeblue_vc.gbc:    RGBFIXFLAGS += -p 0x00 -t "POKEMON BLUE"

%.gbc: $$(%_obj) layout.link
	$(RGBLINK) $(RGBLINKFLAGS) -l layout.link -m $*.map -n $*.sym -o $@ $(filter %.o,$^)
	$(RGBFIX) $(RGBFIXFLAGS) $@


### Misc file-specific graphics rules

gfx/battle/move_anim_0.2bpp: tools/gfx += --trim-whitespace
gfx/battle/move_anim_1.2bpp: tools/gfx += --trim-whitespace

gfx/intro/blue_jigglypuff_1.2bpp: RGBGFXFLAGS += --columns
gfx/intro/blue_jigglypuff_2.2bpp: RGBGFXFLAGS += --columns
gfx/intro/blue_jigglypuff_3.2bpp: RGBGFXFLAGS += --columns
gfx/intro/red_nidorino_1.2bpp: RGBGFXFLAGS += --columns
gfx/intro/red_nidorino_2.2bpp: RGBGFXFLAGS += --columns
gfx/intro/red_nidorino_3.2bpp: RGBGFXFLAGS += --columns
gfx/intro/gengar.2bpp: RGBGFXFLAGS += --columns
gfx/intro/gengar.2bpp: tools/gfx += --remove-duplicates --preserve=0x19,0x76

gfx/credits/the_end.2bpp: tools/gfx += --interleave --png=$<

gfx/slots/red_slots_1.2bpp: tools/gfx += --trim-whitespace
gfx/slots/blue_slots_1.2bpp: tools/gfx += --trim-whitespace

gfx/tilesets/%.2bpp: tools/gfx += --trim-whitespace
gfx/tilesets/reds_house.2bpp: tools/gfx += --preserve=0x48

gfx/trade/game_boy.2bpp: tools/gfx += --remove-duplicates


### Catch-all graphics rules

%.2bpp: %.png
	$(RGBGFX) --colors dmg $(RGBGFXFLAGS) -o $@ $<
	$(if $(tools/gfx),\
		tools/gfx $(tools/gfx) -o $@ $@ || $$($(RM) $@ && false))

%.1bpp: %.png
	$(RGBGFX) --colors dmg $(RGBGFXFLAGS) --depth 1 -o $@ $<
	$(if $(tools/gfx),\
		tools/gfx $(tools/gfx) --depth 1 -o $@ $@ || $$($(RM) $@ && false))

%.pic: %.2bpp
	tools/pkmncompress $< $@


### File extensions that are never generated and should be manually created

%.asm: ;
%.inc: ;
%.png: ;
%.pal: ;
%.bin: ;
%.blk: ;
%.bst: ;
%.rle: ;

### WLA-DX structured migration and reconciliation

WLA ?= wla-gb
WLALINK ?= wlalink
PYTHON ?= python3
PKRD_MONOLITH ?= /data/pkrd/pkrd-noanon-hram-fixed.asm

wla-build-dir := wla/build
wla-reference-dir := wla/reference

wla/banks/bank31_music_headers_3.asm: audio/headers/musicheaders3.asm pokered.sym wla/tools/convert_music_headers.py
	$(PYTHON) wla/tools/convert_music_headers.py $< pokered.sym $@ MusicHeaders3End

wla/banks/bank31_sfx_headers_3.asm: audio/headers/sfxheaders3.asm pokered.sym wla/tools/convert_music_headers.py
	$(PYTHON) wla/tools/convert_music_headers.py $< pokered.sym $@ SfxHeaders3End

wla/banks/bank02_music_headers_1.asm: audio/headers/musicheaders1.asm pokered.sym wla/tools/convert_music_headers.py
	$(PYTHON) wla/tools/convert_music_headers.py $< pokered.sym $@ MusicHeaders1End

wla/banks/bank02_sfx_headers_1.asm: audio/headers/sfxheaders1.asm pokered.sym wla/tools/convert_music_headers.py
	$(PYTHON) wla/tools/convert_music_headers.py $< pokered.sym $@ SfxHeaders1End

wla/banks/bank08_sfx_headers_2.asm: audio/headers/sfxheaders2.asm pokered.sym wla/tools/convert_music_headers.py
	$(PYTHON) wla/tools/convert_music_headers.py $< pokered.sym $@ SfxHeaders2End

wla/build/bank02_sound_effects_1.asm: audio.asm pokered.sym wla/tools/convert_audio_section.py wla/tools/convert_rgbds_code.py
	mkdir -p $(wla-build-dir)
	$(PYTHON) wla/tools/convert_audio_section.py audio.asm "Sound Effects 1" $@

wla/build/bank08_sound_effects_2.asm: audio.asm pokered.sym wla/tools/convert_audio_section.py wla/tools/convert_rgbds_code.py
	mkdir -p $(wla-build-dir)
	$(PYTHON) wla/tools/convert_audio_section.py audio.asm "Sound Effects 2" $@

wla/build/bank31_sound_effects_3.asm: audio.asm pokered.sym wla/tools/convert_audio_section.py wla/tools/convert_rgbds_code.py
	mkdir -p $(wla-build-dir)
	$(PYTHON) wla/tools/convert_audio_section.py audio.asm "Sound Effects 3" $@


bank32-text-sources := \
	data/text/text_1.asm text/ViridianForest.asm text/MtMoon1F.asm \
	text/MtMoonB1F.asm text/MtMoonB2F.asm text/SSAnne1F.asm \
	text/SSAnne2F.asm text/SSAnne3F.asm text/SSAnneBow.asm \
	text/SSAnneKitchen.asm text/SSAnneCaptainsRoom.asm \
	text/SSAnne1FRooms.asm text/SSAnne2FRooms.asm text/SSAnneB1FRooms.asm \
	text/VictoryRoad3F.asm text/RocketHideoutB1F.asm \
	text/RocketHideoutB2F.asm text/RocketHideoutB3F.asm \
	text/RocketHideoutB4F.asm text/RocketHideoutElevator.asm \
	text/SilphCo2F.asm text/SilphCo3F.asm text/SilphCo4F.asm text/SilphCo5F.asm

wla/banks/bank32_text.asm: $(bank32-text-sources) wla/tools/convert_text_bank.py
	$(PYTHON) wla/tools/convert_text_bank.py $@ $(bank32-text-sources)

bank33-text-sources := \
	text/SilphCo5F_2.asm text/SilphCo6F.asm text/SilphCo7F.asm \
	text/SilphCo8F.asm text/SilphCo9F.asm text/SilphCo10F.asm \
	text/SilphCo11F.asm text/PokemonMansion2F.asm \
	text/PokemonMansion3F.asm text/PokemonMansionB1F.asm \
	text/SafariZoneEast.asm text/SafariZoneNorth.asm text/SafariZoneWest.asm \
	text/SafariZoneCenter.asm text/SafariZoneCenterRestHouse.asm \
	text/SafariZoneSecretHouse.asm text/SafariZoneWestRestHouse.asm \
	text/SafariZoneEastRestHouse.asm text/SafariZoneNorthRestHouse.asm \
	text/CeruleanCaveB1F.asm text/VictoryRoad1F.asm text/LancesRoom.asm \
	text/HallOfFame.asm text/ChampionsRoom.asm text/LoreleisRoom.asm \
	text/BrunosRoom.asm text/AgathasRoom.asm text/RockTunnelB1F.asm

wla/banks/bank33_text.asm: $(bank33-text-sources) wla/tools/convert_text_bank.py
	$(PYTHON) wla/tools/convert_text_bank.py $@ $(bank33-text-sources)

bank34-text-sources := \
	text/RockTunnelB1F_2.asm text/SeafoamIslandsB4F.asm \
	data/text/text_2.asm text/DiglettsCaveRoute2.asm \
	text/ViridianForestNorthGate.asm text/Route2TradeHouse.asm \
	text/Route2Gate.asm text/ViridianForestSouthGate.asm \
	text/MtMoonPokecenter.asm text/SaffronGates.asm text/Daycare.asm

wla/banks/bank34_text.asm: $(bank34-text-sources) wla/tools/convert_text_bank.py
	$(PYTHON) wla/tools/convert_text_bank.py $@ $(bank34-text-sources)

bank35-text-sources := \
	text/Daycare_2.asm text/UndergroundPathRoute6.asm \
	text/UndergroundPathRoute7.asm text/UndergroundPathRoute7Copy.asm \
	text/UndergroundPathRoute8.asm text/RockTunnelPokecenter.asm \
	text/RockTunnel1F.asm text/PowerPlant.asm text/Route11Gate1F.asm \
	text/Route11Gate2F.asm text/DiglettsCaveRoute11.asm \
	text/Route12Gate1F.asm text/Route12Gate2F.asm \
	text/Route12SuperRodHouse.asm text/Route15Gate1F.asm \
	text/Route15Gate2F.asm text/Route16Gate1F.asm text/Route16Gate2F.asm \
	text/Route16FlyHouse.asm text/Route18Gate1F.asm text/Route18Gate2F.asm \
	text/Route22Gate.asm text/VictoryRoad2F.asm text/BillsHouse.asm \
	text/Route1.asm text/Route2.asm text/Route3.asm text/Route4.asm \
	text/Route5.asm text/Route6.asm text/Route7.asm text/Route8.asm \
	text/Route9.asm text/Route10.asm text/Route11.asm

wla/banks/bank35_text.asm: $(bank35-text-sources) wla/tools/convert_text_bank.py
	$(PYTHON) wla/tools/convert_text_bank.py $@ $(bank35-text-sources)

bank36-text-sources := \
	text/Route11_2.asm text/Route12.asm text/Route13.asm text/Route14.asm \
	text/Route15.asm text/Route16.asm text/Route17.asm text/Route18.asm \
	text/Route19.asm text/Route20.asm text/Route21.asm text/Route22.asm \
	text/Route23.asm text/Route24.asm

wla/banks/bank36_text.asm: $(bank36-text-sources) wla/tools/convert_text_bank.py
	$(PYTHON) wla/tools/convert_text_bank.py $@ $(bank36-text-sources)

bank37-text-sources := \
	text/Route24_2.asm text/Route25.asm data/text/text_3.asm \
	text/RedsHouse1F.asm text/BluesHouse.asm text/OaksLab.asm \
	text/pokedex_ratings.asm text/ViridianPokecenter.asm \
	text/ViridianMart.asm text/ViridianSchoolHouse.asm \
	text/ViridianNicknameHouse.asm text/ViridianGym.asm \
	text/Museum1F.asm text/Museum2F.asm text/PewterGym.asm

wla/banks/bank37_text.asm: $(bank37-text-sources) wla/tools/convert_text_bank.py
	$(PYTHON) wla/tools/convert_text_bank.py $@ $(bank37-text-sources)

bank38-text-sources := \
	text/PewterGym_2.asm text/PewterNidoranHouse.asm text/PewterMart.asm \
	text/PewterSpeechHouse.asm text/PewterPokecenter.asm \
	text/CeruleanTrashedHouse.asm text/CeruleanTradeHouse.asm \
	text/CeruleanPokecenter.asm text/CeruleanGym.asm text/BikeShop.asm \
	text/CeruleanMart.asm text/CeruleanBadgeHouse.asm \
	text/LavenderPokecenter.asm text/PokemonTower1F.asm \
	text/PokemonTower2F.asm text/PokemonTower3F.asm text/PokemonTower4F.asm \
	text/PokemonTower5F.asm text/PokemonTower6F.asm text/PokemonTower7F.asm \
	text/MrFujisHouse.asm text/LavenderMart.asm text/LavenderCuboneHouse.asm \
	text/NameRatersHouse.asm text/VermilionPokecenter.asm \
	text/PokemonFanClub.asm text/VermilionMart.asm text/VermilionGym.asm

wla/banks/bank38_text.asm: $(bank38-text-sources) wla/tools/convert_text_bank.py
	$(PYTHON) wla/tools/convert_text_bank.py $@ $(bank38-text-sources)

bank39-text-sources := \
	text/VermilionGym_2.asm text/VermilionPidgeyHouse.asm \
	text/VermilionDock.asm text/VermilionOldRodHouse.asm \
	text/CeladonMart1F.asm text/CeladonMart2F.asm \
	text/CeladonMart3F.asm text/CeladonMart4F.asm \
	text/CeladonMartRoof.asm text/CeladonMansion1F.asm \
	text/CeladonMansion2F.asm text/CeladonMansion3F.asm \
	text/CeladonMansionRoof.asm text/CeladonMansionRoofHouse.asm \
	text/CeladonPokecenter.asm text/CeladonGym.asm text/GameCorner.asm \
	text/CeladonMart5F.asm text/GameCornerPrizeRoom.asm \
	text/CeladonDiner.asm text/CeladonChiefHouse.asm text/CeladonHotel.asm \
	text/FuchsiaMart.asm text/FuchsiaBillsGrandpasHouse.asm \
	text/FuchsiaPokecenter.asm text/WardensHouse.asm \
	text/SafariZoneGate.asm text/FuchsiaGym.asm

wla/banks/bank39_text.asm: $(bank39-text-sources) wla/tools/convert_text_bank.py
	$(PYTHON) wla/tools/convert_text_bank.py $@ $(bank39-text-sources)

bank40-text-sources := \
	text/FuchsiaGym_2.asm text/FuchsiaMeetingRoom.asm \
	text/FuchsiaGoodRodHouse.asm text/PokemonMansion1F.asm \
	text/CinnabarGym.asm text/CinnabarLab.asm \
	text/CinnabarLabTradeRoom.asm text/CinnabarLabMetronomeRoom.asm \
	text/CinnabarLabFossilRoom.asm text/CinnabarPokecenter.asm \
	text/CinnabarMart.asm text/IndigoPlateauLobby.asm \
	text/CopycatsHouse1F.asm text/CopycatsHouse2F.asm \
	text/FightingDojo.asm text/SaffronGym.asm \
	text/SaffronPidgeyHouse.asm text/SaffronMart.asm \
	text/SilphCo1F.asm text/SaffronPokecenter.asm \
	text/MrPsychicsHouse.asm data/text/text_4.asm

wla/banks/bank40_text.asm: $(bank40-text-sources) wla/tools/convert_text_bank.py
	$(PYTHON) wla/tools/convert_text_bank.py $@ $(bank40-text-sources)

bank41-text-sources := \
	data/text/text_5.asm \
	text/PalletTown.asm \
	text/ViridianCity.asm \
	text/PewterCity.asm \
	text/CeruleanCity.asm \
	text/LavenderTown.asm \
	text/VermilionCity.asm \
	text/CeladonCity.asm \
	text/FuchsiaCity.asm \
	text/CinnabarIsland.asm \
	text/SaffronCity.asm \
	data/text/text_6.asm

wla/banks/bank41_text.asm: $(bank41-text-sources) wla/tools/convert_text_bank.py
	$(PYTHON) wla/tools/convert_text_bank.py $@ $(bank41-text-sources)

wla/banks/bank43_dex_text.asm: data/pokemon/dex_text.asm wla/tools/convert_dex_text.py
	$(PYTHON) wla/tools/convert_dex_text.py $< $@

wla/banks/bank44_move_names.asm: data/moves/names.asm wla/tools/convert_move_names.py
	$(PYTHON) wla/tools/convert_move_names.py $< $@

wla-poc:
	mkdir -p $(wla-build-dir)
	$(WLA) -v -o $(wla-build-dir)/home_start_poc.o wla/poc/home_start_poc_driver.asm
	$(WLALINK) -v -s wla/layout.link $(wla-build-dir)/home_start_poc.gb

wla-unit-poc:
	mkdir -p $(wla-build-dir)
	$(WLA) -v -o $(wla-build-dir)/field_move_names_poc.o wla/poc/field_move_names_poc_driver.asm
	$(WLALINK) -v -s wla/unit_poc.link $(wla-build-dir)/field_move_names_poc.gb

# Build the complete WLA-DX split. Structured bank includes are substituted
# only after their linked boundaries and full-ROM parity have been verified.
wla-red wla-rom: wla/build/bank02_sound_effects_1.asm wla/build/bank08_sound_effects_2.asm wla/build/bank31_sound_effects_3.asm wla/banks/bank02_sfx_headers_1.asm wla/banks/bank02_music_headers_1.asm wla/banks/bank08_sfx_headers_2.asm wla/banks/bank31_sfx_headers_3.asm wla/banks/bank31_music_headers_3.asm wla/banks/bank32_text.asm wla/banks/bank33_text.asm wla/banks/bank34_text.asm wla/banks/bank35_text.asm wla/banks/bank36_text.asm wla/banks/bank37_text.asm wla/banks/bank38_text.asm wla/banks/bank39_text.asm wla/banks/bank40_text.asm wla/banks/bank41_text.asm wla/banks/bank43_dex_text.asm wla/banks/bank44_move_names.asm wla/banks/bank13_pewter_guys.asm wla/banks/bank13_multiply.asm
wla-red wla-rom: wla/banks/bank13_start_slot_machine.asm
wla-red wla-rom: wla/banks/bank13_title2.asm
wla-red wla-rom: wla/banks/bank13_link_versus.asm
wla-red wla-rom: wla/banks/bank13_slot_machine_tiles.asm
wla-red wla-rom: wla/banks/bank30_slot_machine_tiles2.asm
wla-red wla-rom: wla/banks/bank13_slot_machine_wheels.asm
wla-red wla-rom: wla/banks/bank13_slot_machine_map.asm
wla-red wla-rom: wla/banks/bank13_load_slot_machine_tiles.asm
	mkdir -p $(wla-build-dir)
	$(WLA) -o $(wla-build-dir)/pkrd.o wla/pkrd/main.asm
	$(WLALINK) -S wla/pkrd.link $(wla-build-dir)/pkrd.gb

rgbds-red: pokered.gbc

wla-compare: rgbds-red wla-red
	$(PYTHON) wla/tools/check_linked_boundaries.py $(wla-build-dir)/pkrd.sym
	cmp pokered.gbc $(wla-build-dir)/pkrd.gb
	@echo "WLA-DX ROM matches the verified RGBDS Pokemon Red ROM byte-for-byte."

# One gate for every invariant currently required of the Red migration.
wla-check: wla/build/bank02_sound_effects_1.asm wla/build/bank08_sound_effects_2.asm wla/build/bank31_sound_effects_3.asm wla-audit wla-check-split wla-report wla-compare
	@echo "WLA-DX Pokemon Red migration checks passed."

wla-index-monolith:
	mkdir -p $(wla-reference-dir)
	$(PYTHON) wla/tools/index_monolith.py $(PKRD_MONOLITH) > $(wla-reference-dir)/MONOLITH_INDEX.md

wla-check-split:
	$(PYTHON) wla/tools/check_split_against_monolith.py $(PKRD_MONOLITH)

wla-audit:
	$(PYTHON) wla/tools/reconcile_audit.py

wla-report:
	$(PYTHON) wla/tools/report_split_status.py --monolith $(PKRD_MONOLITH)

wla-verify-type-matchups:
	$(PYTHON) wla/tools/verify_type_matchups.py

wla-reference:
	mkdir -p $(wla-reference-dir)
	cp $(PKRD_MONOLITH) $(wla-reference-dir)/pkrd-noanon-hram-fixed.asm
	test -f $(wla-reference-dir)/pkrd-noanon-hram-fixed.asm

.SECONDARY: $(wla-build-dir)/home_start_poc.gb $(wla-build-dir)/field_move_names_poc.gb
.PRECIOUS: $(wla-build-dir)/%.o
