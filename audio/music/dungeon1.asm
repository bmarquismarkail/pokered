Music_Dungeon1_Ch1:
	tempo 144
	volume 7, 7
	duty_cycle 3
	toggle_perfect_pitch
	vibrato 10, 1, 4
	note_type 12, 4, -5
	rest 8
	stereo_panning %1110, %1101
	octave 4
	note F_SHARP, 8
	stereo_panning %1111, %1111
Music_Dungeon1_Ch1.mainloop:
	note_type 12, 11, 2
	octave 3
Music_Dungeon1_Ch1.loop1:
	sound_call Music_Dungeon1_Ch1.sub1
	sound_loop 3, Music_Dungeon1_Ch1.loop1
	note E_, 1
	note D_SHARP, 1
	note B_, 1
	note A_SHARP, 1
	note G_, 1
	note G_SHARP, 1
	rest 1
	note A_SHARP, 1
	note E_, 1
	note D_SHARP, 1
	note B_, 1
	note A_SHARP, 1
	note G_, 1
	note G_SHARP, 1
	note A_, 1
	note A_SHARP, 1
Music_Dungeon1_Ch1.loop2:
	sound_call Music_Dungeon1_Ch1.sub1
	sound_loop 4, Music_Dungeon1_Ch1.loop2
	sound_call Music_Dungeon1_Ch1.sub4
	octave 3
	note G_, 1
	note F_SHARP, 1
	note E_, 1
	note G_, 1
	sound_call Music_Dungeon1_Ch1.sub4
	octave 3
	note A_, 1
	note G_, 1
	note E_, 1
	note A_, 1
	sound_call Music_Dungeon1_Ch1.sub4
	octave 3
	note B_, 1
	note A_, 1
	note G_, 1
	note F_SHARP, 1
	note_type 12, 12, 3
	note G_, 4
	note F_SHARP, 4
	note E_, 4
	note D_SHARP, 4
	note_type 12, 12, 2
	sound_call Music_Dungeon1_Ch1.sub3
	octave 3
	note B_, 3
	sound_call Music_Dungeon1_Ch1.sub3
	note C_, 3
	sound_call Music_Dungeon1_Ch1.sub3
	note C_SHARP, 3
	note_type 12, 12, 3
	octave 3
	note G_, 4
	note F_SHARP, 4
	note E_, 4
	note D_SHARP, 4
	note E_, 4
	note D_SHARP, 4
	note C_, 4
	octave 2
	note B_, 4
	note_type 12, 12, 2
	note B_, 1
	note A_SHARP, 1
	note G_, 1
	note A_SHARP, 1
	note B_, 1
	note A_SHARP, 1
	note G_, 1
	note A_SHARP, 1
	octave 3
	note C_, 1
	octave 2
	note B_, 1
	note G_SHARP, 1
	note B_, 1
	octave 3
	note C_, 1
	octave 2
	note B_, 1
	note G_SHARP, 1
	note B_, 1
	octave 3
	note C_SHARP, 1
	note C_, 1
	octave 2
	note A_, 1
	octave 3
	note C_, 1
	note C_SHARP, 1
	note C_, 1
	octave 2
	note A_, 1
	octave 3
	note C_, 1
	note D_, 1
	note C_SHARP, 1
	octave 2
	note A_SHARP, 1
	octave 3
	note C_SHARP, 1
	note D_, 1
	note C_SHARP, 1
	octave 2
	note A_SHARP, 1
	octave 3
	note C_SHARP, 1
Music_Dungeon1_Ch1.loop3:
	rest 16
	sound_loop 8, Music_Dungeon1_Ch1.loop3
	note_type 12, 12, 3
	sound_call Music_Dungeon1_Ch1.sub2
	note B_, 2
	note G_, 2
	octave 3
	note C_SHARP, 4
	octave 2
	note G_, 2
	note A_, 4
	note F_SHARP, 2
	sound_call Music_Dungeon1_Ch1.sub2
	note A_SHARP, 2
	note G_, 2
	note B_, 4
	note G_, 2
	note F_SHARP, 2
	note G_, 2
	note D_SHARP, 2
	note_type 12, 12, 2
	sound_call Music_Dungeon1_Ch1.sub3
	octave 3
	note B_, 3
	sound_call Music_Dungeon1_Ch1.sub3
	note C_, 3
	sound_call Music_Dungeon1_Ch1.sub3
	note C_SHARP, 3
	note_type 12, 12, 7
	octave 3
	note F_SHARP, 8
	note D_SHARP, 8
	note_type 12, 12, 2
	sound_call Music_Dungeon1_Ch1.sub1
	sound_call Music_Dungeon1_Ch1.sub1
	sound_loop 0, Music_Dungeon1_Ch1.mainloop

Music_Dungeon1_Ch1.sub1:
	note E_, 1
	note D_SHARP, 1
	note B_, 1
	note A_SHARP, 1
	note G_, 1
	note G_SHARP, 1
	rest 1
	note A_SHARP, 1
	note E_, 1
	note D_SHARP, 1
	note B_, 1
	note A_SHARP, 1
	note G_, 1
	note G_SHARP, 1
	rest 1
	note A_SHARP, 1
	sound_ret

Music_Dungeon1_Ch1.sub2:
	octave 2
	note G_, 2
	note A_SHARP, 4
	note G_, 2
	octave 3
	note C_SHARP, 4
	octave 2
	note G_, 2
	note A_SHARP, 2
	sound_ret

Music_Dungeon1_Ch1.sub3:
	octave 3
	note E_, 1
	note E_, 1
	note F_, 1
	note E_, 1
	note G_, 1
	note E_, 1
	note A_, 1
	note E_, 1
	note A_SHARP, 1
	note E_, 1
	note B_, 1
	note E_, 1
	octave 4
	note C_, 1
	sound_ret

Music_Dungeon1_Ch1.sub4:
	note E_, 1
	note E_, 1
	rest 4
	octave 1
	note E_, 1
	rest 3
	note E_, 1
	rest 1
	sound_ret

Music_Dungeon1_Ch2:
	vibrato 11, 1, 5
	duty_cycle 3
	note_type 12, 0, -7
	octave 4
	note G_SHARP, 8
	note_type 12, 4, -5
	octave 5
	note D_, 8
Music_Dungeon1_Ch2.mainloop:
	note_type 12, 12, 2
Music_Dungeon1_Ch2.loop1:
	sound_call Music_Dungeon1_Ch2.sub1
	sound_loop 3, Music_Dungeon1_Ch2.loop1
	octave 2
	note E_, 1
	note E_, 1
	note B_, 1
	octave 3
	note C_, 1
	rest 2
	note C_, 1
	octave 2
	note B_, 1
	note E_, 1
	note E_, 1
	note A_, 1
	note G_, 1
	note F_, 1
	note F_SHARP, 1
	note G_, 1
	note D_SHARP, 1
Music_Dungeon1_Ch2.loop2:
	sound_call Music_Dungeon1_Ch2.sub1
	sound_loop 4, Music_Dungeon1_Ch2.loop2
	rest 2
	sound_call Music_Dungeon1_Ch2.sub2
	octave 3
	note C_, 4
	sound_call Music_Dungeon1_Ch2.sub2
	octave 3
	note C_SHARP, 4
	sound_call Music_Dungeon1_Ch2.sub2
	octave 3
	note D_SHARP, 4
	note_type 12, 13, 3
	octave 4
	note E_, 4
	note D_SHARP, 4
	note C_, 4
	octave 3
	note B_, 4
	note_type 12, 13, 2
	sound_call Music_Dungeon1_Ch2.sub3
	octave 3
	note F_SHARP, 4
	sound_call Music_Dungeon1_Ch2.sub3
	octave 3
	note G_, 4
	sound_call Music_Dungeon1_Ch2.sub3
	octave 3
	note A_SHARP, 4
	note_type 12, 13, 3
	octave 4
	note E_, 4
	note D_SHARP, 4
	note C_, 4
	octave 3
	note B_, 4
	octave 4
	note C_, 4
	octave 3
	note B_, 4
	note G_, 4
	note F_SHARP, 2
	note_type 12, 13, 6
	note E_, 8
	note F_, 8
	note F_SHARP, 8
	note G_, 8
	note_type 12, 13, 2
	sound_call Music_Dungeon1_Ch2.sub4
	rest 10
	note E_, 1
	rest 1
	sound_call Music_Dungeon1_Ch2.sub4
	rest 12
	sound_call Music_Dungeon1_Ch2.sub4
	rest 12
	sound_call Music_Dungeon1_Ch2.sub4
	rest 14
	note_type 12, 13, 3
	sound_call Music_Dungeon1_Ch2.sub6
	note D_SHARP, 4
	sound_call Music_Dungeon1_Ch2.sub6
	note D_SHARP, 2
	rest 2
	note_type 12, 13, 2
	sound_call Music_Dungeon1_Ch2.sub5
	rest 2
	octave 3
	note F_SHARP, 4
	octave 2
	note E_, 1
	note E_, 1
	octave 3
	note B_, 1
	rest 1
	octave 4
	note C_, 1
	rest 1
	note C_SHARP, 1
	rest 1
	note D_, 1
	note C_SHARP, 1
	rest 2
	octave 3
	note G_, 4
	sound_call Music_Dungeon1_Ch2.sub5
	octave 3
	note A_SHARP, 4
	note_type 12, 13, 6
	note B_, 8
	octave 4
	note D_SHARP, 8
	note_type 12, 13, 2
	sound_call Music_Dungeon1_Ch2.sub1
	sound_call Music_Dungeon1_Ch2.sub1
	sound_loop 0, Music_Dungeon1_Ch2.mainloop

Music_Dungeon1_Ch2.sub1:
	octave 2
	note E_, 1
	note E_, 1
	note B_, 1
	octave 3
	note C_, 1
	rest 2
	note C_, 1
	octave 2
	note B_, 1
	note E_, 1
	note E_, 1
	note B_, 1
	octave 3
	note C_, 1
	rest 2
	note C_, 1
	octave 2
	note B_, 1
	sound_ret

Music_Dungeon1_Ch2.sub2:
	octave 2
	note E_, 1
	note E_, 1
	rest 2
	octave 1
	note E_, 1
	rest 3
	note E_, 1
	rest 3
	sound_ret

Music_Dungeon1_Ch2.sub3:
	octave 2
	note E_, 1
	note E_, 1
	rest 10
	sound_ret

Music_Dungeon1_Ch2.sub4:
	octave 1
	note E_, 1
	note G_, 1
	note E_, 1
	note D_SHARP, 1
	sound_ret

Music_Dungeon1_Ch2.sub5:
	octave 2
	note E_, 1
	note E_, 1
	octave 4
	note E_, 1
	rest 1
	note D_SHARP, 1
	rest 1
	note D_, 1
	rest 1
	note C_SHARP, 1
	note C_, 1
	sound_ret

Music_Dungeon1_Ch2.sub6:
	octave 3
	note E_, 6
	note G_, 6
	note E_, 4
	note A_, 6
	octave 4
	note C_, 6
	octave 3
	note B_, 4
	note G_, 6
	note A_SHARP, 6
	note F_SHARP, 4
	note E_, 6
	note F_SHARP, 6
	sound_ret

Music_Dungeon1_Ch3:
	note_type 12, 1, 1
	vibrato 8, 2, 6
	rest 14
	octave 4
	note D_, 1
	note D_SHARP, 1
Music_Dungeon1_Ch3.mainloop:
	sound_call Music_Dungeon1_Ch3.sub1
	sound_call Music_Dungeon1_Ch3.sub1
	octave 5
	note E_, 2
	rest 4
	octave 3
	note E_, 1
	rest 3
	note E_, 1
	rest 1
	octave 4
	note F_SHARP, 4
	sound_call Music_Dungeon1_Ch3.sub2
	octave 4
	note G_, 4
	sound_call Music_Dungeon1_Ch3.sub2
	octave 4
	note A_, 4
	note B_, 4
	note A_SHARP, 4
	note G_, 4
	note F_SHARP, 4
	rest 6
	sound_call Music_Dungeon1_Ch3.sub5
	note B_, 4
	note A_SHARP, 4
	note G_, 4
	note F_SHARP, 4
	note G_, 4
	note F_SHARP, 4
	note E_, 4
	note D_SHARP, 4
	sound_call Music_Dungeon1_Ch3.sub3
	rest 12
	sound_call Music_Dungeon1_Ch3.sub3
	rest 12
	sound_call Music_Dungeon1_Ch3.sub3
	rest 10
	note E_, 1
	rest 1
	sound_call Music_Dungeon1_Ch3.sub3
	rest 12
	sound_call Music_Dungeon1_Ch3.sub3
	rest 12
	sound_call Music_Dungeon1_Ch3.sub3
	rest 10
	note D_, 1
	note D_SHARP, 1
	sound_call Music_Dungeon1_Ch3.sub4
	sound_call Music_Dungeon1_Ch3.sub4
	note E_, 2
	rest 4
	sound_call Music_Dungeon1_Ch3.sub5
	note B_, 8
	note F_SHARP, 6
	note D_, 1
	note D_SHARP, 1
	rest 16
	rest 16
	sound_loop 0, Music_Dungeon1_Ch3.mainloop

Music_Dungeon1_Ch3.sub1:
	octave 5
	note E_, 4
	note B_, 4
	note A_SHARP, 4
	octave 6
	note D_, 4
	note C_SHARP, 4
	octave 5
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
	sound_ret

Music_Dungeon1_Ch3.sub2:
	octave 6
	note E_, 1
	note E_, 1
	rest 4
	octave 3
	note E_, 1
	rest 3
	note E_, 1
	rest 1
	sound_ret

Music_Dungeon1_Ch3.sub3:
	octave 3
	note E_, 1
	note G_, 1
	note E_, 1
	note D_SHARP, 1
	sound_ret

Music_Dungeon1_Ch3.sub4:
	note E_, 4
	note B_, 4
	note A_SHARP, 4
	octave 4
	note D_, 4
	note C_SHARP, 4
	octave 3
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
	sound_ret

Music_Dungeon1_Ch3.sub5:
	octave 4
	note E_, 1
	rest 3
	note E_, 1
	rest 1
	note F_SHARP, 4
	rest 6
	note E_, 1
	rest 3
	note E_, 1
	rest 1
	note G_, 4
	rest 6
	note E_, 1
	rest 3
	note E_, 1
	note E_, 1
	note A_SHARP, 4
	sound_ret

Music_Dungeon1_Ch4:
	drum_speed 12
	rest 14
	drum_note 12, 1
	drum_note 12, 1
Music_Dungeon1_Ch4.mainloop:
Music_Dungeon1_Ch4.loop1:
	sound_call Music_Dungeon1_Ch4.sub1
	sound_loop 3, Music_Dungeon1_Ch4.loop1
	drum_note 13, 4
	drum_note 12, 4
	drum_note 13, 4
	drum_note 12, 2
	drum_note 12, 2
Music_Dungeon1_Ch4.loop2:
	sound_call Music_Dungeon1_Ch4.sub1
	sound_loop 3, Music_Dungeon1_Ch4.loop2
	drum_note 13, 4
	drum_note 12, 4
	drum_note 13, 4
	drum_note 13, 4
Music_Dungeon1_Ch4.loop3:
	sound_call Music_Dungeon1_Ch4.sub2
	sound_loop 3, Music_Dungeon1_Ch4.loop3
	sound_call Music_Dungeon1_Ch4.sub3
Music_Dungeon1_Ch4.loop4:
	sound_call Music_Dungeon1_Ch4.sub2
	sound_loop 3, Music_Dungeon1_Ch4.loop4
	sound_call Music_Dungeon1_Ch4.sub3
	drum_note 9, 4
	drum_note 10, 4
	drum_note 10, 4
	rest 2
	drum_note 9, 2
	drum_note 13, 4
Music_Dungeon1_Ch4.loop5:
	rest 16
	sound_loop 13, Music_Dungeon1_Ch4.loop5
	rest 12
Music_Dungeon1_Ch4.loop6:
	sound_call Music_Dungeon1_Ch4.sub2
	sound_loop 3, Music_Dungeon1_Ch4.loop6
	drum_note 12, 4
	drum_note 12, 4
	drum_note 12, 4
	rest 2
	drum_note 12, 1
	drum_note 12, 1
	sound_call Music_Dungeon1_Ch4.sub1
	sound_call Music_Dungeon1_Ch4.sub1
	sound_loop 0, Music_Dungeon1_Ch4.mainloop

Music_Dungeon1_Ch4.sub1:
	drum_note 13, 4
	drum_note 12, 4
	drum_note 13, 4
	drum_note 12, 4
	sound_ret

Music_Dungeon1_Ch4.sub2:
	drum_note 12, 1
	drum_note 12, 1
	rest 10
	drum_note 14, 4
	sound_ret

Music_Dungeon1_Ch4.sub3:
	drum_note 9, 4
	drum_note 10, 4
	drum_note 10, 4
	drum_note 11, 4
	sound_ret
