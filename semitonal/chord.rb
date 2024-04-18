module Semitonal
  Chord = Struct.new(:form, :root, :notes) do
    def self.candidates_from_inversions(inversions, notes)
      inversions.map{|(i1, i2)|
        chord_form = Tonal::CHORD_FORMS_BY_SEMITONES[[i1.semitones, i2.semitones]]
        next unless chord_form

        Semitonal::Chord.new(chord_form, i1.a, notes)
      }.compact
    end

    def name(root_name)
      "#{root_name}#{form[:signature]}"
    end

    def to_tonal_chords(midi_note_numbers)
      warn "to_tonal_chods called"
      tonal_chords = []
      root_candidates = Tonal::Pitch.candidates(root)
      root_candidates.each do |root|
        tonal_notes = notes.select {|n| n.in_octave == root.semitones_in_octave }.map {|n|
          Tonal::Pitch.candidates(n).find {|c| c.natural == root.natural }
        }

        form.intervals.each do |interval|
          note = root + interval

          tonal_notes += notes.select {|n| n.in_octave == note.semitones_in_octave }.map {|n|
            Tonal::Pitch.candidates(n).find {|c| c.natural == note.natural }
          }
        end

        tonal_chords << Tonal::Chord.new(form, root, tonal_notes)
      end
      tonal_chords
    end
  end
end
