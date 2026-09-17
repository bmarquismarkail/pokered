Music_MeetFemaleTrainer_Ch1:
	tempo 124
	volume 7, 7
	duty_cycle 1
	toggle_perfect_pitch
	note_type 12, 11, 2
	octave 3
	note G_SHARP, 6
	octave 4
	note E_, 2
	note D_SHARP, 2
	note C_SHARP, 2
	note C_, 2
	note_type 12, 8, 1
Music_MeetFemaleTrainer_Ch1.mainloop:
Music_MeetFemaleTrainer_Ch1.loop1:
	octave 3
	note E_, 4
	sound_loop 12, Music_MeetFemaleTrainer_Ch1.loop1
	note E_, 4
	octave 2
	note B_, 4
	note B_, 4
	octave 3
	note E_, 4
	sound_loop 0, Music_MeetFemaleTrainer_Ch1.mainloop

Music_MeetFemaleTrainer_Ch2:
	duty_cycle 2
	note_type 12, 12, 2
	octave 3
	note B_, 2
	note_type 12, 12, 7
	octave 4
	note B_, 12
Music_MeetFemaleTrainer_Ch2.mainloop:
	note_type 12, 12, 2
	octave 3
	note B_, 4
	octave 4
	note D_SHARP, 4
	note E_, 4
	note D_SHARP, 4
	note C_SHARP, 2
	note C_, 2
	octave 3
	note B_, 2
	note A_, 2
	note G_SHARP, 2
	note A_, 2
	note A_SHARP, 2
	octave 4
	note C_SHARP, 2
	octave 3
	note B_, 4
	octave 4
	note C_SHARP, 4
	octave 3
	note B_, 4
	note A_, 4
	note G_SHARP, 2
	note F_SHARP, 2
	note E_, 2
	note D_SHARP, 2
	note E_, 2
	note F_SHARP, 2
	note G_SHARP, 2
	note A_, 2
	sound_loop 0, Music_MeetFemaleTrainer_Ch2.mainloop

Music_MeetFemaleTrainer_Ch3:
	note_type 12, 1, 0
	rest 8
	octave 5
	note C_SHARP, 1
	rest 1
	octave 4
	note B_, 1
	rest 1
	note A_, 1
	rest 1
Music_MeetFemaleTrainer_Ch3.mainloop:
	sound_call Music_MeetFemaleTrainer_Ch3.sub1
	note G_SHARP, 1
	rest 3
	note E_, 1
	rest 3
	note G_SHARP, 1
	rest 3
	note E_, 1
	rest 3
	sound_call Music_MeetFemaleTrainer_Ch3.sub1
	note G_SHARP, 1
	rest 3
	note E_, 1
	rest 3
	note G_SHARP, 1
	rest 3
	note B_, 1
	rest 3
	sound_loop 0, Music_MeetFemaleTrainer_Ch3.mainloop

Music_MeetFemaleTrainer_Ch3.sub1:
	note G_SHARP, 1
	rest 3
	note E_, 1
	rest 3
	note G_SHARP, 1
	rest 3
	note E_, 1
	rest 1
	note F_SHARP, 1
	rest 1
	sound_ret
