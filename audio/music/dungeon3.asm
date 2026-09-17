Music_Dungeon3_Ch1:
	tempo 160
	volume 7, 7
	duty_cycle 3
	toggle_perfect_pitch
	vibrato 8, 1, 4
Music_Dungeon3_Ch1.mainloop:
	note_type 12, 12, 3
Music_Dungeon3_Ch1.loop1:
	sound_call Music_Dungeon3_Ch1.sub1
	sound_loop 3, Music_Dungeon3_Ch1.loop1
	octave 2
	note B_, 2
	octave 3
	note D_SHARP, 2
	note G_, 2
	octave 2
	note B_, 2
	octave 3
	note D_SHARP, 2
	note G_, 2
	note D_SHARP, 2
	note E_, 2
Music_Dungeon3_Ch1.loop2:
	sound_call Music_Dungeon3_Ch1.sub2
	sound_loop 4, Music_Dungeon3_Ch1.loop2
Music_Dungeon3_Ch1.loop3:
	sound_call Music_Dungeon3_Ch1.sub1
	sound_loop 4, Music_Dungeon3_Ch1.loop3
	octave 4
	note F_, 2
	note F_, 2
	rest 2
	note F_, 2
	note E_, 2
	note E_, 2
	note D_SHARP, 2
	note D_SHARP, 2
	rest 2
	note D_SHARP, 2
	note D_, 2
	note D_, 2
	sound_call Music_Dungeon3_Ch1.sub7
	octave 4
	note D_, 2
	note D_, 2
	rest 2
	note D_, 2
	note D_SHARP, 2
	note D_SHARP, 2
	note E_, 2
	note E_, 2
	rest 2
	note E_, 2
	note F_, 2
	note F_, 2
Music_Dungeon3_Ch1.loop4:
	sound_call Music_Dungeon3_Ch1.sub3
	sound_loop 4, Music_Dungeon3_Ch1.loop4
Music_Dungeon3_Ch1.loop5:
	sound_call Music_Dungeon3_Ch1.sub4
	sound_loop 3, Music_Dungeon3_Ch1.loop5
	octave 3
	note C_SHARP, 2
	octave 2
	note A_, 2
	note F_, 2
	octave 3
	note C_SHARP, 2
	octave 2
	note A_, 2
	note F_, 2
	octave 3
	note A_, 2
	note F_, 2
	octave 4
	note C_SHARP, 2
	octave 3
	note A_, 2
	note F_, 2
	octave 4
	note C_SHARP, 2
	octave 3
	note A_, 2
	note F_, 2
	note A_, 2
	note F_, 2
	octave 4
	note C_SHARP, 2
	octave 3
	note A_, 2
	note F_, 2
	octave 4
	note C_SHARP, 2
	octave 3
	note A_, 2
	note F_, 2
	octave 4
	note C_SHARP, 2
	octave 3
	note A_, 2
	note F_, 2
	octave 4
	note C_SHARP, 2
	octave 3
	note A_, 2
	note F_, 2
	octave 4
	note C_SHARP, 2
	octave 3
	note A_, 2
	note F_, 2
	octave 4
	note C_SHARP, 2
	octave 3
	note A_, 2
	note F_, 2
	note G_SHARP, 2
	note E_, 2
	octave 4
	note C_, 2
	octave 3
	note G_SHARP, 2
	note E_, 2
	octave 4
	note C_, 2
	sound_call Music_Dungeon3_Ch1.sub5
	sound_call Music_Dungeon3_Ch1.sub5
	octave 3
	note G_SHARP, 2
	note E_, 2
	octave 4
	note C_, 2
	octave 3
	note G_SHARP, 2
	note E_, 2
	octave 4
	note C_, 2
	octave 3
	note G_SHARP, 2
	note E_, 2
	rest 16
	rest 8
	sound_call Music_Dungeon3_Ch1.sub6
	sound_call Music_Dungeon3_Ch1.sub6
	sound_call Music_Dungeon3_Ch1.sub6
	sound_call Music_Dungeon3_Ch1.sub6
	note D_SHARP, 2
	rest 16
	rest 16
	sound_loop 0, Music_Dungeon3_Ch1.mainloop

Music_Dungeon3_Ch1.sub1:
	octave 2
	note B_, 2
	octave 3
	note D_SHARP, 2
	note G_, 2
	octave 2
	note B_, 2
	octave 3
	note D_SHARP, 2
	note G_, 2
	octave 2
	note B_, 2
	octave 3
	note D_SHARP, 2
	sound_ret

Music_Dungeon3_Ch1.sub2:
	note E_, 2
	note G_SHARP, 2
	octave 4
	note C_, 2
	octave 3
	note E_, 2
	note G_SHARP, 2
	octave 4
	note C_, 2
	octave 3
	note E_, 2
	note G_SHARP, 2
	sound_ret

Music_Dungeon3_Ch1.sub3:
	octave 3
	note D_SHARP, 2
	octave 2
	note B_, 2
	octave 3
	note G_, 2
	note D_SHARP, 2
	octave 2
	note B_, 2
	octave 3
	note G_, 2
	note D_SHARP, 2
	octave 2
	note B_, 2
	sound_ret

Music_Dungeon3_Ch1.sub4:
	note A_, 2
	note F_, 2
	octave 3
	note C_SHARP, 2
	octave 2
	note A_, 2
	note F_, 2
	octave 3
	note C_SHARP, 2
	octave 2
	note A_, 2
	note F_, 2
	sound_ret

Music_Dungeon3_Ch1.sub5:
	octave 3
	note G_SHARP, 2
	note E_, 2
	note G_SHARP, 2
	note E_, 2
	octave 4
	note C_, 2
	octave 3
	note G_SHARP, 2
	note E_, 2
	octave 4
	note C_, 2
	sound_ret

Music_Dungeon3_Ch1.sub6:
	note D_SHARP, 2
	note G_, 2
	note D_SHARP, 2
	note C_SHARP, 6
	sound_ret

Music_Dungeon3_Ch1.sub7:
	tempo 168
	octave 1
	note A_SHARP, 1
	note B_, 1
	octave 2
	note C_, 1
	note C_SHARP, 1
	note D_, 1
	note D_SHARP, 1
	note E_, 1
	note F_, 1
	tempo 176
	octave 1
	note A_SHARP, 1
	note B_, 1
	octave 2
	note C_, 1
	note C_SHARP, 1
	note D_, 1
	note D_SHARP, 1
	note E_, 1
	note F_, 1
	tempo 184
	octave 1
	note A_SHARP, 1
	note B_, 1
	octave 2
	note C_, 1
	note C_SHARP, 1
	note D_, 1
	note D_SHARP, 1
	note E_, 1
	note F_, 1
	tempo 192
	octave 1
	note A_, 1
	note A_SHARP, 1
	note B_, 1
	octave 2
	note C_, 1
	note C_SHARP, 1
	note D_, 1
	note D_SHARP, 1
	note E_, 1
	tempo 200
	octave 1
	note G_SHARP, 1
	note A_, 1
	note A_SHARP, 1
	note B_, 1
	octave 2
	note C_, 1
	note C_SHARP, 1
	note D_, 1
	note D_SHARP, 1
	tempo 208
	octave 1
	note G_, 1
	note G_SHARP, 1
	note A_, 1
	note A_SHARP, 1
	note B_, 1
	octave 2
	note C_, 1
	note C_SHARP, 1
	note D_, 1
	tempo 216
	octave 1
	note F_SHARP, 1
	note G_, 1
	note G_SHARP, 1
	note A_, 1
	note A_SHARP, 1
	note B_, 1
	octave 2
	note C_, 1
	note C_SHARP, 1
	tempo 224
	octave 1
	note F_, 1
	note F_SHARP, 1
	note G_, 1
	note G_SHARP, 1
	note A_, 1
	note A_SHARP, 1
	note B_, 1
	octave 2
	note C_, 1
	tempo 160
	sound_ret

Music_Dungeon3_Ch2:
	vibrato 11, 1, 5
	duty_cycle 3
Music_Dungeon3_Ch2.mainloop:
	note_type 12, 13, 3
	octave 4
	note D_SHARP, 6
	note C_SHARP, 6
	octave 3
	note B_, 2
	octave 4
	note C_SHARP, 2
	note D_SHARP, 2
	note G_, 2
	note D_SHARP, 2
	note C_SHARP, 6
	octave 3
	note B_, 2
	octave 4
	note C_SHARP, 2
	note D_SHARP, 2
	note G_, 2
	note D_SHARP, 2
	note C_SHARP, 6
	octave 3
	note B_, 2
	note A_SHARP, 2
	note B_, 6
	octave 4
	note C_SHARP, 8
	rest 2
	note G_SHARP, 6
	note F_SHARP, 6
	note E_, 2
	note F_SHARP, 2
	note G_SHARP, 2
	octave 5
	note C_, 2
	octave 4
	note G_SHARP, 2
	note F_SHARP, 6
	note E_, 2
	note F_SHARP, 2
	note G_SHARP, 2
	octave 5
	note C_, 2
	octave 4
	note G_SHARP, 2
	note F_SHARP, 6
	note E_, 2
	note D_SHARP, 2
	note E_, 6
	note F_SHARP, 6
	note E_, 4
	note D_SHARP, 6
	note C_SHARP, 6
	octave 3
	note B_, 2
	octave 4
	note C_SHARP, 2
	note D_SHARP, 2
	note G_, 2
	note D_SHARP, 2
	note C_SHARP, 6
	octave 3
	note B_, 2
	octave 4
	note C_SHARP, 2
	note D_SHARP, 2
	note G_, 2
	note D_SHARP, 2
	note C_SHARP, 6
	octave 3
	note B_, 2
	note A_SHARP, 2
	note B_, 6
	octave 4
	note C_SHARP, 8
	rest 2
	note G_SHARP, 2
	note G_SHARP, 2
	rest 2
	note G_SHARP, 2
	note A_, 2
	note A_, 2
	note A_SHARP, 2
	note A_SHARP, 2
	rest 2
	note A_SHARP, 2
	note B_, 2
	note B_, 2
	rest 8
	rest 8
	rest 8
	rest 8
	rest 8
	rest 8
	rest 8
	rest 8
	octave 4
	note B_, 2
	note B_, 2
	rest 2
	note B_, 2
	note A_SHARP, 2
	note A_SHARP, 2
	note A_, 2
	note A_, 2
	rest 2
	note A_, 2
	note G_SHARP, 2
	note G_SHARP, 2
	note C_SHARP, 8
	rest 2
	octave 3
	note B_, 6
	note A_SHARP, 2
	note B_, 2
	octave 4
	note D_SHARP, 2
	note G_, 2
	note D_SHARP, 2
	note C_SHARP, 6
	octave 3
	note B_, 2
	octave 4
	note C_SHARP, 2
	note D_SHARP, 2
	note G_, 2
	note D_SHARP, 2
	note C_SHARP, 6
	octave 3
	note B_, 2
	octave 4
	note C_SHARP, 2
	note D_SHARP, 6
	note G_, 6
	octave 3
	note G_, 8
	rest 2
	note F_, 6
	note E_, 2
	note F_, 2
	note A_, 2
	octave 4
	note C_SHARP, 2
	octave 3
	note A_, 2
	note G_, 6
	note F_, 2
	note G_, 2
	note A_, 2
	octave 4
	note C_SHARP, 2
	octave 3
	note A_, 2
	note G_, 6
	note A_, 6
	octave 4
	note C_SHARP, 6
	note G_, 8
	rest 2
	note F_, 6
	note E_, 2
	note F_, 2
	note A_, 2
	octave 5
	note C_SHARP, 2
	octave 4
	note A_, 2
	note G_, 6
	note A_, 2
	octave 5
	note C_SHARP, 2
	octave 4
	note A_, 2
	note G_, 6
	note A_, 6
	octave 5
	note C_SHARP, 6
	octave 4
	note F_SHARP, 8
	rest 2
	note E_, 6
	note D_SHARP, 2
	note E_, 2
	note G_SHARP, 2
	octave 5
	note C_, 2
	octave 4
	note G_SHARP, 2
	note F_SHARP, 6
	note E_, 2
	note F_SHARP, 2
	note G_SHARP, 2
	octave 5
	note C_, 2
	octave 4
	note G_SHARP, 2
	note F_SHARP, 6
	note G_SHARP, 6
	octave 5
	note C_, 6
	octave 3
	note D_SHARP, 2
	note G_, 2
	note D_SHARP, 2
	note C_SHARP, 6
	note D_SHARP, 2
	note G_, 2
	note D_SHARP, 2
	note C_SHARP, 6
	octave 2
	note E_, 2
	note G_SHARP, 2
	octave 3
	note C_, 2
	note E_, 2
	note G_SHARP, 2
	octave 4
	note C_, 2
	note E_, 2
	note G_SHARP, 2
	note C_, 2
	note E_, 2
	note G_SHARP, 2
	note C_, 2
	note E_, 2
	note G_SHARP, 2
	note C_, 2
	note E_, 2
	note G_SHARP, 2
	note C_, 2
	note E_, 2
	note G_SHARP, 2
	note C_, 2
	note E_, 2
	note G_SHARP, 2
	note C_, 2
	note D_SHARP, 2
	octave 2
	note B_, 2
	octave 3
	note D_SHARP, 2
	note G_, 2
	octave 2
	note B_, 2
	octave 3
	note D_SHARP, 2
	note G_, 2
	octave 2
	note B_, 2
	octave 3
	note D_SHARP, 2
	octave 2
	note B_, 2
	octave 3
	note D_SHARP, 2
	note G_, 2
	octave 2
	note B_, 2
	octave 3
	note D_SHARP, 2
	note G_, 2
	octave 2
	note B_, 2
	octave 3
	note D_SHARP, 2
	sound_loop 0, Music_Dungeon3_Ch2.mainloop

Music_Dungeon3_Ch3:
Music_Dungeon3_Ch3.mainloop:
	note_type 12, 1, 2
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 12
	note_type 6, 1, 0
	octave 3
	note B_, 1
	octave 4
	note C_, 1
	note C_SHARP, 1
	note D_, 1
	note D_SHARP, 1
	note E_, 1
	rest 2
	note C_, 1
	note C_SHARP, 1
	note D_, 1
	note D_SHARP, 1
	note E_, 1
	note F_, 1
	rest 16
	rest 16
	rest 10
	octave 5
	note E_, 8
	octave 4
	note B_, 8
	octave 5
	note D_SHARP, 8
	octave 4
	note A_SHARP, 8
	octave 5
	note D_, 8
	octave 4
	note A_, 8
	octave 5
	note C_SHARP, 8
	octave 4
	note G_SHARP, 8
	octave 5
	note C_, 8
	octave 4
	note G_, 8
	note B_, 8
	note F_SHARP, 8
	note A_SHARP, 8
	note F_, 8
	note A_, 8
	note E_, 8
	rest 16
	rest 16
	rest 8
	note F_, 1
	note E_, 1
	note D_SHARP, 1
	note D_, 1
	note C_SHARP, 1
	note C_, 1
	rest 2
	note E_, 1
	note D_SHARP, 1
	note D_, 1
	note C_SHARP, 1
	note C_, 1
	octave 3
	note B_, 1
	rest 10
	rest 16
	note_type 12, 1, 0
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 10
	sound_loop 0, Music_Dungeon3_Ch3.mainloop

Music_Dungeon3_Ch4:
	drum_speed 12
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 10
	sound_ret
