Music_Routes1_Ch1:
	tempo 152
	volume 7, 7
	vibrato 4, 2, 3
	duty_cycle 2
	toggle_perfect_pitch
Music_Routes1_Ch1.mainloop:
	note_type 12, 10, 1
	rest 4
	octave 4
	note D_, 2
	note D_, 6
	note D_, 2
	note D_, 6
	note D_, 2
	note D_, 1
	note C_SHARP, 1
	octave 3
	note B_, 1
	octave 4
	note C_SHARP, 1
	octave 3
	note A_, 2
	note A_, 2
	note A_, 6
	octave 4
	note C_SHARP, 2
	note C_SHARP, 6
	note C_SHARP, 2
	note C_SHARP, 4
	octave 3
	note A_, 2
	octave 4
	note C_SHARP, 2
	octave 3
	note B_, 2
	octave 4
	note C_SHARP, 4
	octave 3
	note A_, 2
	note A_, 6
	octave 4
	note D_, 2
	note D_, 6
	note D_, 2
	note D_, 6
	note D_, 2
	note D_, 1
	note E_, 1
	note D_, 1
	note C_SHARP, 1
	octave 3
	note B_, 2
	note A_, 2
	note A_, 6
	octave 4
	note C_SHARP, 2
	note C_SHARP, 6
	octave 3
	note A_, 2
	octave 4
	note E_, 2
	octave 3
	note A_, 2
	note_type 12, 10, 2
	octave 4
	note G_, 4
	note E_, 4
	note F_SHARP, 2
	note_type 12, 10, 1
	octave 3
	note A_, 2
	note A_, 6
	note A_, 2
	note F_SHARP, 2
	note A_, 4
	note B_, 2
	octave 4
	note C_SHARP, 2
	octave 3
	note B_, 4
	note A_, 2
	note F_SHARP, 2
	note A_, 4
	note G_, 2
	note E_, 2
	note C_SHARP, 4
	note A_, 2
	octave 4
	note D_, 2
	octave 3
	note A_, 4
	note B_, 2
	note G_, 2
	note B_, 4
	octave 4
	note D_, 2
	note E_, 2
	note C_SHARP, 2
	note D_, 2
	octave 3
	note A_, 2
	note A_, 2
	sound_loop 0, Music_Routes1_Ch1.mainloop

	sound_ret ; unused

Music_Routes1_Ch2:
	duty_cycle 2
Music_Routes1_Ch2.mainloop:
	note_type 12, 13, 1
	sound_call Music_Routes1_Ch2.sub1
	sound_call Music_Routes1_Ch2.sub2
	sound_call Music_Routes1_Ch2.sub1
	sound_call Music_Routes1_Ch2.sub3
	sound_loop 0, Music_Routes1_Ch2.mainloop

Music_Routes1_Ch2.sub1:
	octave 4
	note D_, 1
	note E_, 1
	note F_SHARP, 2
	note F_SHARP, 2
	note F_SHARP, 2
	note D_, 1
	note E_, 1
	note F_SHARP, 2
	note F_SHARP, 2
	note F_SHARP, 2
	note D_, 1
	note E_, 1
	note F_SHARP, 2
	note F_SHARP, 2
	note G_, 3
	note F_SHARP, 1
	note E_, 6
	sound_ret

Music_Routes1_Ch2.sub2:
	note C_SHARP, 1
	note D_, 1
	note E_, 2
	note E_, 2
	note E_, 2
	note C_SHARP, 1
	note D_, 1
	note E_, 2
	note E_, 2
	note E_, 2
	note C_SHARP, 1
	note D_, 1
	note E_, 2
	note E_, 2
	note F_SHARP, 1
	note E_, 1
	note E_, 1
	note F_SHARP, 1
	note D_, 4
	note F_SHARP, 2
	sound_ret

Music_Routes1_Ch2.sub3:
	note C_SHARP, 1
	note D_, 1
	note E_, 2
	note G_, 2
	note F_SHARP, 2
	note E_, 2
	note D_, 2
	note C_SHARP, 2
	octave 3
	note B_, 2
	octave 4
	note C_SHARP, 2
	note_type 12, 13, 2
	note B_, 4
	note_type 6, 13, 1
	octave 3
	note B_, 1
	octave 4
	note C_SHARP, 1
	note_type 12, 13, 1
	octave 3
	note B_, 1
	note A_, 1
	octave 4
	note C_SHARP, 1
	note D_, 6
	note_type 12, 13, 2
	note F_SHARP, 1
	note G_, 1
	note A_, 2
	note A_, 2
	note F_SHARP, 2
	note D_, 2
	octave 5
	note D_, 2
	note C_SHARP, 2
	octave 4
	note B_, 2
	octave 5
	note C_SHARP, 2
	octave 4
	note A_, 2
	note F_SHARP, 2
	note D_, 3
	note F_SHARP, 1
	note E_, 6
	note F_SHARP, 1
	note G_, 1
	note A_, 2
	note A_, 2
	note F_SHARP, 2
	note A_, 2
	octave 5
	note D_, 2
	note C_SHARP, 2
	octave 4
	note B_, 3
	note G_, 1
	note A_, 2
	octave 5
	note D_, 2
	note C_SHARP, 2
	note E_, 2
	note D_, 2
	note_type 12, 13, 1
	octave 4
	note D_, 2
	note D_, 2
	sound_ret

	sound_ret ; unused

Music_Routes1_Ch3:
	vibrato 8, 2, 5
	note_type 12, 1, 3
Music_Routes1_Ch3.mainloop:
	rest 2
	octave 4
	note D_, 4
	note C_SHARP, 4
	octave 3
	note B_, 4
	note A_, 4
	octave 4
	note D_, 4
	octave 3
	note A_, 4
	note B_, 4
	note A_, 4
	octave 4
	note C_SHARP, 4
	octave 3
	note A_, 4
	note B_, 4
	octave 4
	note C_, 4
	note C_SHARP, 4
	octave 3
	note A_, 4
	octave 4
	note D_, 4
	octave 3
	note A_, 4
	octave 4
	note D_, 4
	note C_SHARP, 4
	octave 3
	note B_, 4
	note A_, 4
	octave 4
	note D_, 4
	octave 3
	note A_, 4
	note B_, 4
	note A_, 4
	octave 4
	note C_SHARP, 4
	octave 3
	note B_, 4
	note A_, 4
	note B_, 4
	octave 4
	note C_SHARP, 4
	octave 3
	note A_, 4
	octave 4
	note D_, 4
	octave 3
	note A_, 4
	octave 4
	note D_, 8
	octave 3
	note G_, 8
	note A_, 8
	octave 4
	note C_SHARP, 8
	note D_, 8
	octave 3
	note G_, 8
	note A_, 8
	octave 4
	note D_, 6
	sound_loop 0, Music_Routes1_Ch3.mainloop

	sound_ret ; unused

Music_Routes1_Ch4:
Music_Routes1_Ch4.mainloop:
	drum_speed 12
	rest 4
	drum_note 15, 2
	rest 2
	drum_note 15, 2
	rest 2
	drum_note 15, 2
	rest 2
	drum_note 15, 2
	rest 2
	drum_note 15, 2
	rest 2
	drum_note 15, 2
	rest 2
	drum_note 15, 2
	drum_note 15, 2
	rest 4
	drum_note 15, 2
	rest 2
	drum_note 15, 2
	rest 2
	drum_note 15, 2
	rest 2
	drum_note 15, 2
	rest 2
	drum_note 15, 2
	rest 2
	drum_note 15, 2
	drum_note 15, 2
	drum_note 15, 2
	drum_note 15, 2
	rest 4
	drum_note 15, 2
	rest 2
	drum_note 15, 2
	rest 2
	drum_note 15, 2
	rest 2
	drum_note 15, 2
	rest 2
	drum_note 15, 2
	rest 2
	drum_note 15, 2
	rest 2
	drum_note 15, 2
	drum_note 15, 2
	rest 4
	drum_note 15, 2
	rest 2
	drum_note 15, 2
	rest 2
	drum_note 15, 2
	rest 2
	drum_note 15, 2
	rest 2
	drum_note 15, 2
	rest 2
	drum_note 15, 2
	rest 2
	drum_note 15, 2
	drum_note 15, 2
	drum_note 15, 2
	rest 2
	drum_note 15, 2
	drum_note 15, 2
	rest 4
	drum_note 15, 2
	drum_note 15, 2
	drum_note 15, 2
	rest 2
	drum_note 15, 2
	drum_note 15, 2
	rest 4
	drum_note 15, 2
	drum_note 15, 2
	drum_note 15, 2
	rest 2
	drum_note 15, 2
	drum_note 15, 2
	rest 4
	drum_note 15, 2
	drum_note 15, 2
	drum_note 15, 2
	rest 2
	drum_note 15, 2
	drum_note 15, 2
	drum_note 15, 2
	rest 2
	drum_note 15, 2
	drum_note 15, 2
	sound_loop 0, Music_Routes1_Ch4.mainloop

	sound_ret ; unused
