Music_MuseumGuy_Ch1:
	tempo 128
	volume 7, 7
	duty_cycle 2
	toggle_perfect_pitch
	note_type 12, 11, 1
	octave 3
	note B_, 2
	note A_, 2
	note G_SHARP, 2
	note A_, 2
	note G_SHARP, 2
	note F_SHARP, 2
	note E_, 2
	note D_SHARP, 2
	octave 2
	note B_, 4
	note B_, 1
	octave 3
	note D_SHARP, 1
	note E_, 1
	note G_SHARP, 1
	note B_, 10
	sound_call Music_MuseumGuy_Ch1.sub1
	sound_call Music_MuseumGuy_Ch1.sub2
	sound_call Music_MuseumGuy_Ch1.sub1
	note E_, 4
	note E_, 4
	note E_, 2
	note E_, 6
Music_MuseumGuy_Ch1.mainloop:
	sound_call Music_MuseumGuy_Ch1.sub1
	sound_call Music_MuseumGuy_Ch1.sub2
	sound_call Music_MuseumGuy_Ch1.sub1
	note E_, 4
	note E_, 4
	note E_, 2
	note E_, 6
	sound_loop 0, Music_MuseumGuy_Ch1.mainloop

Music_MuseumGuy_Ch1.sub1:
	note E_, 2
	note E_, 6
	note F_SHARP, 2
	note F_SHARP, 6
	sound_ret

Music_MuseumGuy_Ch1.sub2:
	note E_, 2
	note E_, 6
	note D_, 2
	note D_, 6
	sound_ret

Music_MuseumGuy_Ch2:
	duty_cycle 2
	note_type 12, 12, 1
	octave 4
	note E_, 2
	note D_, 2
	note C_SHARP, 2
	note D_, 2
	note C_SHARP, 2
	octave 3
	note B_, 2
	note A_, 2
	note G_SHARP, 2
	note E_, 4
	note E_, 1
	note G_SHARP, 1
	note B_, 1
	octave 4
	note D_SHARP, 1
	note E_, 8
	octave 3
	note A_, 2
	octave 4
	note C_SHARP, 2
	note E_, 4
	note D_, 2
	note F_SHARP, 2
	note A_, 4
	octave 3
	note A_, 2
	octave 4
	note C_SHARP, 2
	note E_, 4
	note D_, 2
	note C_SHARP, 2
	octave 3
	note B_, 4
	note A_, 2
	octave 4
	note C_SHARP, 2
	note E_, 4
	note D_, 2
	note F_SHARP, 2
	note A_, 2
	note A_, 2
	note G_SHARP, 2
	note E_, 2
	note F_SHARP, 2
	note G_SHARP, 2
	note A_, 2
	note A_, 2
	note A_, 4
Music_MuseumGuy_Ch2.mainloop:
	octave 3
	note A_, 2
	octave 4
	note C_SHARP, 2
	note E_, 3
	note_type 12, 8, 1
	note E_, 1
	note_type 12, 12, 1
	note D_, 2
	note F_SHARP, 2
	note A_, 3
	note_type 12, 9, 1
	note A_, 1
	note_type 12, 12, 1
	octave 3
	note A_, 2
	octave 4
	note C_SHARP, 2
	note E_, 4
	note D_, 1
	note C_SHARP, 1
	note C_, 1
	octave 3
	note B_, 1
	note B_, 3
	note_type 12, 10, 1
	note G_SHARP, 1
	note_type 12, 12, 1
	note A_, 2
	octave 4
	note C_SHARP, 2
	note E_, 3
	note_type 12, 9, 1
	note E_, 1
	note_type 12, 12, 1
	note D_, 2
	note F_SHARP, 2
	note A_, 3
	note_type 12, 8, 1
	note A_, 1
	note_type 12, 12, 1
	note G_SHARP, 2
	note E_, 1
	note_type 12, 8, 1
	note E_, 1
	note_type 12, 12, 1
	note F_SHARP, 2
	note_type 12, 8, 1
	note F_SHARP, 1
	note_type 12, 12, 1
	note G_SHARP, 1
	note A_, 2
	note A_, 2
	note A_, 4
	sound_loop 0, Music_MuseumGuy_Ch2.mainloop

Music_MuseumGuy_Ch3:
	note_type 12, 1, 0
	rest 16
	octave 4
	note E_, 1
	rest 3
	note E_, 1
	rest 3
	note E_, 1
	rest 9
	sound_call Music_MuseumGuy_Ch3.sub1
	note A_, 1
	rest 1
	note A_, 1
	rest 5
	note G_SHARP, 1
	rest 1
	note G_SHARP, 1
	rest 5
	sound_call Music_MuseumGuy_Ch3.sub1
	note B_, 1
	rest 3
	note G_SHARP, 1
	rest 3
	note A_, 1
	rest 1
	note A_, 1
	rest 3
Music_MuseumGuy_Ch3.mainloop:
	sound_call Music_MuseumGuy_Ch3.sub2
	rest 3
	octave 6
	note E_, 1
	rest 1
	octave 5
	note A_, 1
	rest 1
	note A_, 1
	rest 3
	note B_, 1
	rest 1
	note G_SHARP, 1
	rest 1
	note G_SHARP, 1
	rest 3
	sound_call Music_MuseumGuy_Ch3.sub2
	rest 1
	octave 6
	note E_, 1
	rest 1
	note D_, 1
	rest 1
	octave 5
	note B_, 1
	rest 1
	note A_, 1
	rest 1
	note G_SHARP, 1
	rest 3
	note A_, 1
	rest 1
	note A_, 1
	rest 3
	sound_loop 0, Music_MuseumGuy_Ch3.mainloop

Music_MuseumGuy_Ch3.sub1:
	note A_, 1
	rest 1
	note A_, 1
	rest 5
	note A_, 1
	rest 1
	note A_, 1
	rest 5
	sound_ret

Music_MuseumGuy_Ch3.sub2:
	octave 6
	note C_SHARP, 1
	rest 1
	octave 5
	note A_, 1
	rest 1
	note A_, 1
	rest 3
	octave 6
	note F_SHARP, 1
	rest 1
	octave 5
	note A_, 1
	rest 1
	note A_, 1
	sound_ret

Music_MuseumGuy_Ch4:
	drum_speed 12
	rest 16
	rest 16
	rest 16
	rest 16
	rest 16
	rest 14
	drum_speed 6
	drum_note 19, 1
	drum_note 19, 1
	drum_note 18, 1
	drum_note 18, 1
Music_MuseumGuy_Ch4.mainloop:
	drum_note 17, 4
	drum_note 17, 6
	drum_note 17, 2
	drum_note 17, 2
	drum_note 17, 2
	drum_note 17, 4
	drum_note 17, 2
	drum_note 19, 1
	drum_note 19, 1
	drum_note 17, 6
	drum_note 19, 1
	drum_note 19, 1
	drum_note 17, 4
	drum_note 17, 6
	drum_note 17, 2
	drum_note 18, 1
	drum_note 18, 1
	drum_note 17, 2
	drum_note 17, 2
	drum_note 17, 2
	drum_note 19, 1
	drum_note 19, 1
	drum_note 18, 1
	drum_note 18, 1
	drum_note 17, 6
	drum_note 17, 2
	drum_note 17, 4
	drum_note 17, 4
	drum_note 19, 1
	drum_note 19, 1
	drum_note 17, 2
	drum_note 18, 1
	drum_note 18, 1
	drum_note 17, 2
	drum_note 17, 4
	drum_note 17, 4
	drum_note 17, 2
	drum_note 19, 1
	drum_note 19, 1
	drum_note 18, 1
	drum_note 18, 1
	drum_note 17, 2
	drum_note 17, 2
	drum_note 17, 4
	drum_note 17, 2
	drum_note 19, 1
	drum_note 19, 1
	drum_note 18, 1
	drum_note 18, 1
	drum_note 17, 6
	drum_note 19, 1
	drum_note 19, 1
	drum_note 17, 4
	drum_note 17, 4
	drum_note 19, 1
	drum_note 19, 1
	drum_note 18, 1
	drum_note 18, 1
	sound_loop 0, Music_MuseumGuy_Ch4.mainloop
