module Semitonal
  Chord = Struct.new(:form, :root, :notes) do
    def self.candidates_from_midi_note_numbers(midi_note_numbers)
      notes = midi_note_numbers.map {|n| Note.new(n) } # a, c, e
      sorted = notes.sort.uniq {|note| note.value } # [0, 4, 9]
      intervals = Interval.intervals_of(sorted) # [4, 5, 3]
      inversions = Interval.inversions(intervals) # [[4, 5], [5, 3], [3, 4]]
      candidates_from_inversions(inversions, notes)
    end

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

    def to_tonal_chords
      tonal_chords = []
      root_candidates = Tonal::Note.candidates(root)
      root_candidates.each do |root|
        tonal_notes = notes.select {|n| n.value == root.semitones }.map {|n|
          Tonal::Note.candidates(n).find {|c| c.natural == root.natural }
        }

        form.intervals.each do |interval|
          note = root + interval

          tonal_notes += notes.select {|n| n.value == note.semitones }.map {|n|
            Tonal::Note.candidates(n).find {|c| c.natural == note.natural }
          }
        end

        tonal_chords << Tonal::Chord.new(form, root, tonal_notes)
      end
      tonal_chords
    end
  end
end
