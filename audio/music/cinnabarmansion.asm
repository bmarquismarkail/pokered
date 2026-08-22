Music_CinnabarMansion_Ch1:
	tempo 144
	volume 7, 7
	vibrato 11, 2, 5
	duty_cycle 2
Music_CinnabarMansion_Ch1.mainloop:
Music_CinnabarMansion_Ch1.loop1:
	note_type 12, 6, 2
	octave 5
	note E_, 1
	note E_, 1
	octave 4
	note B_, 1
	note B_, 1
	note C_, 1
	rest 2
	octave 5
	note B_, 2
	note E_, 2
	octave 4
	note C_, 2
	note B_, 2
	note E_, 2
	note C_, 1
	octave 5
	note B_, 1
	rest 2
	sound_loop 14, Music_CinnabarMansion_Ch1.loop1
	note_type 12, 10, 5
	rest 16
	rest 16
	rest 15
	octave 4
	note C_, 1
	octave 5
	note B_, 1
	note B_, 2
	sound_loop 0, Music_CinnabarMansion_Ch1.mainloop

Music_CinnabarMansion_Ch2:
	duty_cycle 2
	toggle_perfect_pitch
	vibrato 10, 2, 4
	note_type 12, 12, 2
Music_CinnabarMansion_Ch2.introloop:
	rest 16
	rest 16
	sound_loop 4, Music_CinnabarMansion_Ch2.introloop
Music_CinnabarMansion_Ch2.mainloop:
	note_type 12, 12, 2
Music_CinnabarMansion_Ch2.loop1:
	sound_call Music_CinnabarMansion_Ch2.sub1
	sound_loop 3, Music_CinnabarMansion_Ch2.loop1
	octave 3
	note E_, 4
	note D_SHARP, 4
	note B_, 4
	note A_SHARP, 4
	note G_, 4
	note G_SHARP, 4
	rest 4
	note A_SHARP, 4
	note E_, 4
	note D_SHARP, 4
	note B_, 4
	note A_SHARP, 4
	note G_, 4
	note G_SHARP, 4
	note G_, 4
	note D_SHARP, 4
	sound_loop 0, Music_CinnabarMansion_Ch2.mainloop

Music_CinnabarMansion_Ch2.sub1:
	octave 3
	note E_, 4
	note D_SHARP, 4
	note B_, 4
	note A_SHARP, 4
	note G_, 4
	note G_SHARP, 4
	note A_, 4
	note A_SHARP, 4
	note E_, 4
	note D_SHARP, 4
	note B_, 4
	note A_SHARP, 4
	note G_, 4
	note G_SHARP, 4
	rest 4
	note A_SHARP, 4
	sound_ret

Music_CinnabarMansion_Ch3:
	note_type 12, 1, 1
Music_CinnabarMansion_Ch3.mainloop:
Music_CinnabarMansion_Ch3.loop1:
	octave 2
	note B_, 2
	rest 2
	octave 3
	note E_, 2
	rest 2
	note E_, 2
	rest 2
	note E_, 2
	rest 2
	note E_, 2
	rest 2
	note E_, 2
	rest 2
	note E_, 2
	rest 2
	note E_, 2
	rest 2
	note C_, 2
	rest 2
	octave 3
	note D_SHARP, 2
	rest 2
	note D_SHARP, 2
	rest 2
	note D_SHARP, 2
	rest 2
	note D_SHARP, 2
	rest 2
	note D_SHARP, 2
	rest 2
	note D_SHARP, 2
	rest 2
	note D_SHARP, 2
	rest 2
	sound_loop 8, Music_CinnabarMansion_Ch3.loop1
	note E_, 16
	note D_SHARP, 16
	note G_, 16
	note G_SHARP, 8
	note D_SHARP, 8
	sound_loop 0, Music_CinnabarMansion_Ch3.mainloop

Music_CinnabarMansion_Ch4:
	drum_speed 6
	rest 16
	rest 16
	rest 16
	rest 16
Music_CinnabarMansion_Ch4.mainloop:
	drum_note 12, 2
	drum_note 12, 2
	drum_note 13, 4
	drum_note 12, 2
	drum_note 12, 2
	drum_note 13, 4
	drum_note 12, 2
	drum_note 12, 2
	drum_note 13, 4
	drum_note 12, 2
	drum_note 12, 2
	drum_note 14, 4
	drum_note 12, 2
	drum_note 12, 2
	rest 2
	rest 10
	rest 8
	drum_note 14, 8
	sound_loop 0, Music_CinnabarMansion_Ch4.mainloop
