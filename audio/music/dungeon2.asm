Music_Dungeon2_Ch1:
	tempo 144
	volume 7, 7
	duty_cycle 3
	toggle_perfect_pitch
	vibrato 10, 1, 4
Music_Dungeon2_Ch1.mainloop:
Music_Dungeon2_Ch1.loop1:
	note_type 12, 11, 2
	octave 4
	note E_, 4
	note E_, 4
	note E_, 4
	note E_, 4
	note A_SHARP, 4
	note A_SHARP, 4
	note A_SHARP, 4
	note A_SHARP, 4
	note E_, 4
	note E_, 4
	note E_, 4
	note E_, 4
	octave 5
	note C_SHARP, 4
	note C_SHARP, 4
	note C_SHARP, 4
	note C_SHARP, 4
	octave 3
	note E_, 4
	note E_, 4
	note E_, 4
	note E_, 4
	note A_SHARP, 4
	note A_SHARP, 4
	note A_SHARP, 4
	note A_SHARP, 4
	octave 2
	note G_, 2
	note A_SHARP, 4
	note G_, 2
	octave 3
	note C_SHARP, 4
	octave 2
	note G_, 2
	note A_SHARP, 2
	note B_, 2
	note G_, 2
	octave 3
	note C_SHARP, 4
	octave 2
	note G_, 2
	note A_, 4
	note F_SHARP, 2
	sound_loop 2, Music_Dungeon2_Ch1.loop1
	note_type 12, 1, -7
	octave 3
	note E_, 16
	note C_, 16
	note D_, 16
	octave 2
	note A_SHARP, 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	sound_loop 0, Music_Dungeon2_Ch1.mainloop

Music_Dungeon2_Ch2:
	vibrato 11, 1, 5
Music_Dungeon2_Ch2.mainloop:
Music_Dungeon2_Ch2.loop1:
	duty_cycle 3
	note_type 12, 12, 2
	octave 3
	note E_, 4
	note E_, 4
	note E_, 4
	note E_, 4
	note C_, 4
	note C_, 4
	note C_, 4
	note C_, 4
	note E_, 4
	note E_, 4
	note E_, 4
	note E_, 4
	note C_, 4
	note C_, 4
	note C_, 4
	note C_, 4
	note B_, 4
	note B_, 4
	note B_, 4
	note B_, 4
	octave 4
	note F_SHARP, 4
	note F_SHARP, 4
	note F_SHARP, 4
	note F_SHARP, 4
	note D_, 4
	note D_, 4
	note D_, 4
	note D_, 4
	note G_, 4
	note G_, 4
	note G_, 4
	note F_SHARP, 4
	sound_loop 2, Music_Dungeon2_Ch2.loop1
	octave 3
	note E_, 2
	note G_, 2
	note E_, 2
	note D_SHARP, 2
	note E_, 2
	note E_, 2
	octave 5
	note E_, 2
	rest 2
	note D_SHARP, 2
	rest 2
	note D_, 2
	rest 2
	note C_SHARP, 2
	note C_, 2
	octave 4
	note E_, 2
	note G_, 2
	octave 3
	note A_SHARP, 2
	note C_SHARP, 2
	note A_SHARP, 2
	note A_, 2
	note A_SHARP, 2
	note G_, 2
	octave 5
	note G_, 2
	rest 2
	note F_SHARP, 2
	rest 2
	note F_, 2
	rest 2
	note E_, 2
	note D_SHARP, 2
	note D_, 2
	note C_SHARP, 2
	rest 16
	rest 16
	rest 16
	rest 16
	note_type 12, 12, 7
	duty_cycle 1
	octave 4
	note E_, 16
	note D_, 16
	note C_, 16
	note D_, 16
	sound_loop 0, Music_Dungeon2_Ch2.mainloop

Music_Dungeon2_Ch3:
	note_type 12, 1, 3
	vibrato 8, 2, 6
Music_Dungeon2_Ch3.mainloop:
Music_Dungeon2_Ch3.loop1:
	sound_call Music_Dungeon2_Ch3.sub2
	sound_loop 16, Music_Dungeon2_Ch3.loop1
	note E_, 4
	rest 4
	rest 4
	note E_, 4
	note C_, 4
	rest 4
	rest 4
	note C_, 4
	note D_, 4
	rest 4
	rest 4
	note D_, 4
	octave 3
	note A_SHARP, 4
	rest 4
	rest 4
	note A_SHARP, 4
Music_Dungeon2_Ch3.loop2:
	octave 5
	note E_, 2
	rest 2
	note B_, 2
	rest 2
	note A_SHARP, 2
	rest 2
	octave 6
	note D_, 2
	rest 2
	note C_SHARP, 2
	rest 2
	octave 5
	note G_SHARP, 2
	rest 2
	note G_, 2
	rest 2
	note B_, 2
	rest 2
	note A_SHARP, 2
	rest 2
	note E_, 2
	rest 2
	note D_SHARP, 2
	rest 2
	note A_, 2
	rest 2
	note G_SHARP, 2
	rest 2
	note E_, 2
	rest 2
	note F_SHARP, 2
	rest 2
	note D_SHARP, 2
	rest 2
	sound_loop 3, Music_Dungeon2_Ch3.loop2
	octave 4
	note E_, 4
	note B_, 4
	note A_SHARP, 4
	octave 5
	note D_, 4
	note C_SHARP, 4
	octave 4
	note G_SHARP, 4
	note G_, 4
	note B_, 4
	note A_SHARP, 4
	note E_, 4
	note D_SHARP, 4
	note A_, 4
	note G_SHARP, 4
	note E_, 4
	note F_SHARP, 4
	note D_SHARP, 4
	octave 3
	note E_, 16
	note C_, 16
	note D_, 16
	octave 2
	note A_SHARP, 16
	octave 3
	note E_, 16
	note F_, 16
	note G_, 16
	octave 3
	note B_, 16
	rest 16
	rest 16
	rest 16
	rest 16
	sound_call Music_Dungeon2_Ch3.sub2
	sound_call Music_Dungeon2_Ch3.sub2
	sound_call Music_Dungeon2_Ch3.sub2
	sound_call Music_Dungeon2_Ch3.sub2
	sound_call Music_Dungeon2_Ch3.sub2
	sound_call Music_Dungeon2_Ch3.sub2
	sound_call Music_Dungeon2_Ch3.sub2
	sound_call Music_Dungeon2_Ch3.sub2
	sound_loop 0, Music_Dungeon2_Ch3.mainloop

Music_Dungeon2_Ch3.sub1: ; unreferenced
	octave 2
	note G_, 2
	note A_SHARP, 4
	note G_, 2
	octave 3
	note C_SHARP, 4
	octave 2
	note G_, 2
	note A_, 2
	note A_SHARP, 2
	note G_, 2
	octave 3
	note C_SHARP, 4
	octave 2
	note G_, 2
	note A_SHARP, 2
	note G_, 2
	rest 2
	sound_ret

Music_Dungeon2_Ch3.sub2:
	octave 4
	note E_, 2
	rest 4
	octave 3
	note E_, 1
	rest 3
	note E_, 1
	rest 1
	octave 4
	note F_SHARP, 4
	sound_ret

Music_Dungeon2_Ch4:
	drum_speed 12
Music_Dungeon2_Ch4.mainloop:
	drum_note 12, 4
	drum_note 13, 4
	drum_note 12, 4
	drum_note 10, 4
	drum_note 12, 4
	drum_note 13, 4
	drum_note 11, 4
	drum_note 9, 4
	sound_loop 0, Music_Dungeon2_Ch4.mainloop
