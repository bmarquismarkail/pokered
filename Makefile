WLA ?= wla-gb
WLALINK ?= wlalink
PYTHON ?= python3
SHA1 ?= sha1sum

ROM := pokered.gbc
RAW_SYMBOLS := wla/build/pokered.wla.sym
LINKFILE := wla/native/pokered.link
EXPECTED_SHA1 := ea9bcae617fdf159b045185467ae58b2e4a48b9a

root_sources := \
	home.asm \
	main.asm \
	maps.asm \
	audio.asm \
	text.asm \
	gfx/pics.asm \
	gfx/sprites.asm \
	gfx/tilesets.asm \
	ram.asm
root_names := home main maps audio text gfx-pics gfx-sprites gfx-tilesets ram
root_objects := $(addprefix wla/build/native-,$(addsuffix .o,$(root_names)))
root_deps := $(root_objects:.o=.d)

# A clean checkout contains only PNG sources. Build one planar conversion for
# every PNG (all 668), then every compressed picture consumed by the sources.
png_sources := $(shell find gfx -type f -name '*.png' -print | sort)
one_bpp_assets := $(shell rg --no-filename -o '\.INCBIN\s+"gfx/[^"]+\.1bpp"' \
	--glob '*.asm' --glob '!wla/**' | sed -E 's/^[^"]*"([^"]+)"/\1/' | sort -u)
one_bpp_pngs := $(one_bpp_assets:.1bpp=.png)
two_bpp_pngs := $(filter-out $(one_bpp_pngs),$(png_sources))
two_bpp_assets := $(two_bpp_pngs:.png=.2bpp)
pic_assets := $(shell rg --no-filename -o '\.INCBIN\s+"gfx/[^"]+\.pic"' \
	--glob '*.asm' --glob '!wla/**' | sed -E 's/^[^"]*"([^"]+)"/\1/' | sort -u)
generated_graphics := $(one_bpp_assets) $(two_bpp_assets) $(pic_assets)

.DEFAULT_GOAL := red
.SUFFIXES:
.SECONDARY:
.PHONY: all red check check-rom check-banks check-symbols check-layout \
	check-native-sources check-native-gfx clean tools

all: red
red: $(ROM)

$(ROM): $(root_objects) $(LINKFILE) wla/tools/canonicalize_symbols.py
	$(WLALINK) -C -S $(LINKFILE) $@
	mv pokered.sym $(RAW_SYMBOLS)
	$(PYTHON) wla/tools/canonicalize_symbols.py $(RAW_SYMBOLS) pokered.sym

pokered.sym: $(ROM)
	@test -f $@

$(RAW_SYMBOLS): $(ROM)
	@test -f $@

wla/build:
	mkdir -p $@

define assemble_root
wla/build/native-$(1).o: $(2) $(generated_graphics) | wla/build
	$$(WLA) -k -I . -M -MD -MF wla/build/native-$(1).d -o $$@ $$<
endef

$(eval $(call assemble_root,home,home.asm))
$(eval $(call assemble_root,main,main.asm))
$(eval $(call assemble_root,maps,maps.asm))
$(eval $(call assemble_root,audio,audio.asm))
$(eval $(call assemble_root,text,text.asm))
$(eval $(call assemble_root,gfx-pics,gfx/pics.asm))
$(eval $(call assemble_root,gfx-sprites,gfx/sprites.asm))
$(eval $(call assemble_root,gfx-tilesets,gfx/tilesets.asm))
$(eval $(call assemble_root,ram,ram.asm))

-include $(root_deps)

### Deterministic graphics conversion

PNG2GB := $(PYTHON) tools/png2gb.py

gfx/battle/move_anim_0.2bpp: tools/gfx_flags += --trim-whitespace
gfx/battle/move_anim_1.2bpp: tools/gfx_flags += --trim-whitespace

gfx/intro/blue_jigglypuff_1.2bpp: png2gb_flags += --columns
gfx/intro/blue_jigglypuff_2.2bpp: png2gb_flags += --columns
gfx/intro/blue_jigglypuff_3.2bpp: png2gb_flags += --columns
gfx/intro/red_nidorino_1.2bpp: png2gb_flags += --columns
gfx/intro/red_nidorino_2.2bpp: png2gb_flags += --columns
gfx/intro/red_nidorino_3.2bpp: png2gb_flags += --columns
gfx/intro/gengar.2bpp: png2gb_flags += --columns
gfx/intro/gengar.2bpp: tools/gfx_flags += --remove-duplicates --preserve=0x19,0x76

gfx/credits/the_end.2bpp: tools/gfx_flags += --interleave --png=$<
gfx/slots/red_slots_1.2bpp: tools/gfx_flags += --trim-whitespace
gfx/slots/blue_slots_1.2bpp: tools/gfx_flags += --trim-whitespace
gfx/tilesets/%.2bpp: tools/gfx_flags += --trim-whitespace
gfx/tilesets/reds_house.2bpp: tools/gfx_flags += --preserve=0x48
gfx/trade/game_boy.2bpp: tools/gfx_flags += --remove-duplicates

%.2bpp: %.png tools/png2gb.py | tools/gfx
	$(PNG2GB) --colors dmg $(png2gb_flags) -o $@ $<
	$(if $(tools/gfx_flags),tools/gfx $(tools/gfx_flags) -o $@ $@ || ($(RM) $@ && false))

%.1bpp: %.png tools/png2gb.py | tools/gfx
	$(PNG2GB) --colors dmg $(png2gb_flags) --depth 1 -o $@ $<
	$(if $(tools/gfx_flags),tools/gfx $(tools/gfx_flags) --depth 1 -o $@ $@ || ($(RM) $@ && false))

%.pic: %.2bpp | tools/pkmncompress
	tools/pkmncompress $< $@

tools/gfx tools/pkmncompress:
	$(MAKE) -C tools/ $(notdir $@)

### Validation

check: clean
	$(MAKE) red
	$(MAKE) check-rom check-banks check-layout check-symbols check-native-gfx check-native-sources
	git diff --check

check-rom: $(ROM)
	test "$$(stat -c %s $(ROM))" = 1048576
	printf '%s  %s\n' $(EXPECTED_SHA1) $(ROM) | $(SHA1) -c -

check-banks: $(ROM)
	$(PYTHON) wla/tools/check_rom_banks.py $(ROM)

check-symbols: pokered.sym wla/reference/pokered.sym
	$(PYTHON) wla/tools/check_linked_symbols.py pokered.sym wla/reference/pokered.sym

check-layout: $(ROM) wla/native/section_layout.tsv
	$(PYTHON) wla/tools/check_section_layout.py $(RAW_SYMBOLS) wla/native/section_layout.tsv

check-native-sources:
	$(PYTHON) wla/tools/check_native_sources.py .

check-native-gfx: $(generated_graphics)
	test "$$(find gfx -type f -name '*.png' | wc -l)" = 668
	@echo "all 668 PNG sources have deterministic planar output"

tools:
	$(MAKE) -C tools/

clean:
	$(RM) $(ROM) pokered.sym pokered.map
	$(RM) -r wla/build
	find . -not -path './.git/*' -type f \( -name '*.o' -o -name '*.lst' \) -delete
	find gfx -type f \( -name '*.1bpp' -o -name '*.2bpp' -o -name '*.pic' \) -delete
	find . -path './.git' -prune -o -type d -name '__pycache__' -exec $(RM) -r {} +
	$(MAKE) clean -C tools/

%.asm %.inc %.png %.pal %.bin %.blk %.bst %.rle:
