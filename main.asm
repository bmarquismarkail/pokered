.INCLUDE "wla/native/config.asm"
.INCLUDE "includes.asm"

.SECTION "bank1" FORCE BANK $01 SLOT 1 ORG $0000

.INCLUDE "data/sprites/facings.asm"
.INCLUDE "engine/events/black_out.asm"
.INCLUDE "data/pokemon/mew.asm"
.INCLUDE "engine/battle/safari_zone.asm"
.INCLUDE "engine/movie/title.asm"
.INCLUDE "engine/pokemon/load_mon_data.asm"
.INCLUDE "data/items/prices.asm"
.INCLUDE "data/items/names.asm"
.INCLUDE "data/text/unused_names.asm"
.INCLUDE "engine/gfx/sprite_oam.asm"
.INCLUDE "engine/gfx/oam_dma.asm"
.INCLUDE "engine/link/print_waiting_text.asm"
.INCLUDE "engine/overworld/sprite_collisions.asm"
.INCLUDE "engine/debug/debug_menu.asm"
.INCLUDE "engine/events/pick_up_item.asm"
.INCLUDE "engine/overworld/movement.asm"
.INCLUDE "engine/link/cable_club.asm"
.INCLUDE "engine/menus/main_menu.asm"
.INCLUDE "engine/movie/oak_speech/oak_speech.asm"
.INCLUDE "engine/overworld/special_warps.asm"
.INCLUDE "engine/debug/debug_party.asm"
.INCLUDE "engine/menus/naming_screen.asm"
.INCLUDE "engine/movie/oak_speech/oak_speech2.asm"
.INCLUDE "engine/items/subtract_paid_money.asm"
.INCLUDE "engine/menus/swap_items.asm"
.INCLUDE "engine/events/pokemart.asm"
.INCLUDE "engine/pokemon/learn_move.asm"
.INCLUDE "engine/events/pokecenter.asm"
.INCLUDE "engine/events/set_blackout_map.asm"
.INCLUDE "engine/menus/display_text_id_init.asm"
.INCLUDE "engine/menus/draw_start_menu.asm"
.INCLUDE "engine/link/cable_club_npc.asm"
.INCLUDE "engine/menus/text_box.asm"
.INCLUDE "engine/battle/move_effects/drain_hp.asm"
.INCLUDE "engine/menus/players_pc.asm"
.INCLUDE "engine/pokemon/remove_mon.asm"
.INCLUDE "engine/events/display_pokedex.asm"



.ENDS

.SECTION "bank3" FORCE BANK $03 SLOT 1 ORG $0000

.INCLUDE "engine/joypad.asm"
.INCLUDE "data/maps/songs.asm"
.INCLUDE "data/maps/map_header_banks.asm"
.INCLUDE "engine/overworld/clear_variables.asm"
.INCLUDE "engine/overworld/player_state.asm"
.INCLUDE "engine/events/poison.asm"
.INCLUDE "engine/overworld/tilesets.asm"
.INCLUDE "engine/overworld/daycare_exp.asm"
.INCLUDE "data/maps/toggleable_objects.asm"
.INCLUDE "engine/overworld/field_move_messages.asm"
.INCLUDE "engine/items/inventory.asm"
.INCLUDE "engine/overworld/wild_mons.asm"
.INCLUDE "engine/items/item_effects.asm"
.INCLUDE "engine/menus/draw_badges.asm"
.INCLUDE "engine/overworld/update_map.asm"
.INCLUDE "engine/overworld/cut.asm"
.INCLUDE "engine/overworld/toggleable_objects.asm"
.INCLUDE "engine/overworld/push_boulder.asm"
.INCLUDE "engine/pokemon/add_mon.asm"
.INCLUDE "engine/flag_action.asm"
.INCLUDE "engine/events/heal_party.asm"
.INCLUDE "engine/math/bcd.asm"
.INCLUDE "engine/movie/oak_speech/init_player_data.asm"
.INCLUDE "engine/items/get_bag_item_quantity.asm"
.INCLUDE "engine/overworld/pathfinding.asm"
.INCLUDE "engine/gfx/hp_bar.asm"
.INCLUDE "engine/events/hidden_events/bookshelves.asm"
.INCLUDE "engine/events/hidden_events/indigo_plateau_statues.asm"
.INCLUDE "engine/events/hidden_events/book_or_sculpture.asm"
.INCLUDE "engine/events/hidden_events/elevator.asm"
.INCLUDE "engine/events/hidden_events/town_map.asm"
.INCLUDE "engine/events/hidden_events/pokemon_stuff.asm"



.ENDS

.SECTION "Font Graphics" FORCE BANK $04 SLOT 1 ORG $1380

.INCLUDE "gfx/font.asm"



.ENDS

.SECTION "Battle Engine 1" FORCE BANK $04 SLOT 1 ORG $28d8

.INCLUDE "engine/overworld/is_player_just_outside_map.asm"
.INCLUDE "engine/pokemon/status_screen.asm"
.INCLUDE "engine/menus/party_menu.asm"
.INCLUDE "gfx/player.asm"
.INCLUDE "engine/overworld/turn_sprite.asm"
.INCLUDE "engine/menus/start_sub_menus.asm"
.INCLUDE "engine/items/tms.asm"
.INCLUDE "engine/battle/end_of_battle.asm"
.INCLUDE "engine/battle/wild_encounters.asm"
.INCLUDE "engine/battle/move_effects/recoil.asm"
.INCLUDE "engine/battle/move_effects/conversion.asm"
.INCLUDE "engine/battle/move_effects/haze.asm"
.INCLUDE "engine/battle/get_trainer_name.asm"
.INCLUDE "engine/math/random.asm"



.ENDS

.SECTION "Battle Engine 2" FORCE BANK $05 SLOT 1 ORG $3840

.INCLUDE "engine/gfx/load_pokedex_tiles.asm"
.INCLUDE "engine/overworld/map_sprites.asm"
.INCLUDE "engine/overworld/emotion_bubbles.asm"
.INCLUDE "engine/events/evolve_trade.asm"
.INCLUDE "engine/battle/move_effects/substitute.asm"
.INCLUDE "engine/menus/pc.asm"



.ENDS

.SECTION "Play Time" FORCE BANK $06 SLOT 1 ORG $0dee

.INCLUDE "engine/play_time.asm"



.ENDS

.SECTION "Doors and Ledges" FORCE BANK $06 SLOT 1 ORG $23e0

.INCLUDE "engine/overworld/auto_movement.asm"
.INCLUDE "engine/overworld/doors.asm"
.INCLUDE "engine/overworld/ledges.asm"



.ENDS

.SECTION "Pokémon Names" FORCE BANK $07 SLOT 1 ORG $021e

.INCLUDE "data/pokemon/names.asm"
.INCLUDE "engine/movie/oak_speech/clear_save.asm"
.INCLUDE "engine/events/elevator.asm"



.ENDS

.SECTION "Hidden Events 1" FORCE BANK $07 SLOT 1 ORG $2915

.INCLUDE "engine/menus/oaks_pc.asm"
.INCLUDE "engine/events/hidden_events/new_bike.asm"
.INCLUDE "engine/events/hidden_events/oaks_lab_posters.asm"
.INCLUDE "engine/events/hidden_events/safari_game.asm"
.INCLUDE "engine/events/hidden_events/cinnabar_gym_quiz.asm"
.INCLUDE "engine/events/hidden_events/magazines.asm"
.INCLUDE "engine/events/hidden_events/bills_house_pc.asm"
.INCLUDE "engine/events/hidden_events/oaks_lab_email.asm"



.ENDS

.SECTION "Bill's PC" FORCE BANK $08 SLOT 1 ORG $13c8

.INCLUDE "engine/pokemon/bills_pc.asm"



.ENDS

.SECTION "Battle Engine 3" FORCE BANK $09 SLOT 1 ORG $3d6b

.INCLUDE "engine/battle/print_type.asm"
.INCLUDE "engine/battle/save_trainer_name.asm"
.INCLUDE "engine/battle/move_effects/focus_energy.asm"



.ENDS

.SECTION "Battle Engine 4" FORCE BANK $0a SLOT 1 ORG $3ea9

.INCLUDE "engine/battle/move_effects/leech_seed.asm"



.ENDS

.SECTION "Battle Engine 5" FORCE BANK $0b SLOT 1 ORG $3b7b

.INCLUDE "engine/battle/display_effectiveness.asm"
.INCLUDE "gfx/trainer_card.asm"
.INCLUDE "engine/items/tmhm.asm"
.INCLUDE "engine/battle/scale_sprites.asm"
.INCLUDE "engine/battle/move_effects/pay_day.asm"
.INCLUDE "engine/slots/game_corner_slots2.asm"



.ENDS

.SECTION "Battle Engine 6" FORCE BANK $0c SLOT 1 ORG $3f2b

.INCLUDE "engine/battle/move_effects/mist.asm"
.INCLUDE "engine/battle/move_effects/one_hit_ko.asm"



.ENDS

.SECTION "Slot Machines" FORCE BANK $0d SLOT 1 ORG $3244

.INCLUDE "engine/movie/title2.asm"
.INCLUDE "engine/battle/link_battle_versus_text.asm"
.INCLUDE "engine/slots/slot_machine.asm"
.INCLUDE "engine/events/pewter_guys.asm"
.INCLUDE "engine/math/multiply_divide.asm"
.INCLUDE "engine/slots/game_corner_slots.asm"



.ENDS

.SECTION "Battle Engine 7" FORCE BANK $0e SLOT 1 ORG $0000

.INCLUDE "data/moves/moves.asm"
.INCLUDE "data/pokemon/base_stats.asm"
.INCLUDE "data/pokemon/cries.asm"
.INCLUDE "engine/battle/unused_stats_functions.asm"
.INCLUDE "engine/battle/scroll_draw_trainer_pic.asm"
.INCLUDE "engine/battle/trainer_ai.asm"
.INCLUDE "engine/battle/draw_hud_pokeball_gfx.asm"
.INCLUDE "gfx/trade.asm"
.INCLUDE "engine/pokemon/evos_moves.asm"
.INCLUDE "engine/battle/move_effects/heal.asm"
.INCLUDE "engine/battle/move_effects/transform.asm"
.INCLUDE "engine/battle/move_effects/reflect_light_screen.asm"



.ENDS

.SECTION "Battle Core" FORCE BANK $0f SLOT 1 ORG $0000

.INCLUDE "engine/battle/core.asm"
.INCLUDE "engine/battle/effects.asm"



.ENDS

.SECTION "bank10" FORCE BANK $10 SLOT 1 ORG $0000

.INCLUDE "engine/menus/pokedex.asm"
.INCLUDE "engine/movie/trade.asm"
.INCLUDE "engine/movie/intro.asm"
.INCLUDE "engine/movie/trade2.asm"



.ENDS

.SECTION "Pokédex Rating" FORCE BANK $11 SLOT 1 ORG $0169

.INCLUDE "engine/events/pokedex_rating.asm"



.ENDS

.SECTION "Hidden Events Core" FORCE BANK $11 SLOT 1 ORG $2981

.INCLUDE "engine/overworld/hidden_events.asm"



.ENDS

.SECTION "Screen Effects" FORCE BANK $12 SLOT 1 ORG $00eb

.INCLUDE "engine/gfx/screen_effects.asm"



.ENDS

.SECTION "Predefs" FORCE BANK $13 SLOT 1 ORG $3da5

.INCLUDE "engine/events/give_pokemon.asm"
.INCLUDE "engine/predefs.asm"



.ENDS

.SECTION "Battle Engine 8" FORCE BANK $14 SLOT 1 ORG $25af

.INCLUDE "engine/battle/init_battle_variables.asm"
.INCLUDE "engine/battle/move_effects/paralyze.asm"



.ENDS

.SECTION "Hidden Events 2" FORCE BANK $14 SLOT 1 ORG $2673

.INCLUDE "engine/events/card_key.asm"
.INCLUDE "engine/events/prize_menu.asm"
.INCLUDE "engine/events/hidden_events/school_notebooks.asm"
.INCLUDE "engine/events/hidden_events/fighting_dojo.asm"
.INCLUDE "engine/events/hidden_events/indigo_plateau_hq.asm"



.ENDS

.SECTION "Battle Engine 9" FORCE BANK $15 SLOT 1 ORG $124f

.INCLUDE "engine/battle/experience.asm"



.ENDS

.SECTION "Diploma" FORCE BANK $15 SLOT 1 ORG $26e2

.INCLUDE "engine/events/diploma.asm"



.ENDS

.SECTION "Trainer Sight" FORCE BANK $15 SLOT 1 ORG $27f9

.INCLUDE "engine/overworld/trainer_sight.asm"



.ENDS

.SECTION "Battle Engine 10" FORCE BANK $16 SLOT 1 ORG $0d99

.INCLUDE "engine/battle/common_text.asm"
.INCLUDE "engine/pokemon/experience.asm"
.INCLUDE "engine/events/oaks_aide.asm"



.ENDS

.SECTION "Saffron Guards" FORCE BANK $16 SLOT 1 ORG $259f

.INCLUDE "engine/events/saffron_guards.asm"



.ENDS

.SECTION "Starter Dex" FORCE BANK $17 SLOT 1 ORG $00dc

.INCLUDE "engine/events/starter_dex.asm"



.ENDS

.SECTION "Hidden Events 3" FORCE BANK $17 SLOT 1 ORG $1b5e

.INCLUDE "engine/pokemon/set_types.asm"
.INCLUDE "engine/events/hidden_events/reds_room.asm"
.INCLUDE "engine/events/hidden_events/route_15_binoculars.asm"
.INCLUDE "engine/events/hidden_events/museum_fossils.asm"
.INCLUDE "engine/events/hidden_events/school_blackboard.asm"
.INCLUDE "engine/events/hidden_events/vermilion_gym_trash.asm"



.ENDS

.SECTION "Cinnabar Lab Fossils" FORCE BANK $18 SLOT 1 ORG $1006

.INCLUDE "engine/events/cinnabar_lab.asm"



.ENDS

.SECTION "Hidden Events 4" FORCE BANK $18 SLOT 1 ORG $2419

.INCLUDE "engine/events/hidden_events/gym_statues.asm"
.INCLUDE "engine/events/hidden_events/bench_guys.asm"
.INCLUDE "engine/events/hidden_events/blues_room.asm"
.INCLUDE "engine/events/hidden_events/pokecenter_pc.asm"



.ENDS

.SECTION "Battle Engine 11" FORCE BANK $1a SLOT 1 ORG $0000

.INCLUDE "engine/battle/decrement_pp.asm"
.INCLUDE "gfx/version.asm"



.ENDS

.SECTION "bank1C" FORCE BANK $1c SLOT 1 ORG $0000

.INCLUDE "engine/movie/splash.asm"
.INCLUDE "engine/movie/hall_of_fame.asm"
.INCLUDE "engine/overworld/healing_machine.asm"
.INCLUDE "engine/overworld/player_animations.asm"
.INCLUDE "engine/battle/ghost_marowak_anim.asm"
.INCLUDE "engine/battle/battle_transitions.asm"
.INCLUDE "engine/items/town_map.asm"
.INCLUDE "engine/gfx/mon_icons.asm"
.INCLUDE "engine/events/in_game_trades.asm"
.INCLUDE "engine/gfx/palettes.asm"
.INCLUDE "engine/menus/save.asm"



.ENDS

.SECTION "Itemfinder 1" FORCE BANK $1d SLOT 1 ORG $005c

.INCLUDE "engine/movie/credits.asm"
.INCLUDE "engine/pokemon/status_ailments.asm"
.INCLUDE "engine/items/itemfinder.asm"



.ENDS

.SECTION "Vending Machine" FORCE BANK $1d SLOT 1 ORG $0ee0

.INCLUDE "engine/events/vending_machine.asm"



.ENDS

.SECTION "Itemfinder 2" FORCE BANK $1d SLOT 1 ORG $257e

.INCLUDE "engine/menus/league_pc.asm"
.INCLUDE "engine/events/hidden_items.asm"



.ENDS

.SECTION "bank1E" FORCE BANK $1e SLOT 1 ORG $0000

.INCLUDE "engine/battle/animations.asm"
.INCLUDE "engine/overworld/cut2.asm"
.INCLUDE "engine/overworld/dust_smoke.asm"
.INCLUDE "gfx/fishing.asm"
.INCLUDE "data/moves/animations.asm"
.INCLUDE "data/battle_anims/subanimations.asm"
.INCLUDE "data/battle_anims/frame_blocks.asm"
.INCLUDE "engine/movie/evolution.asm"
.INCLUDE "engine/overworld/elevator.asm"
.INCLUDE "engine/items/tm_prices.asm"

.ENDS
