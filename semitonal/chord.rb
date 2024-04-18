module Semitonal
  Chord = Struct.new(:form, :root, :notes) do
    def self.candidates_from_midi_note_numbers(midi_note_numbers)
      notes = midi_note_numbers.map {|n| Note.new(n) } # a, c, e
      sorted = notes.sort.uniq {|note| note.value } # [0, 4, 9]
      intervals = Interval.intervals_of(sorted) # [4, 5, 3]
      inversions = Interval.inversions(intervals) # [[4, 5], [5, 3], [3, 4]]
      candidates_from_inversions(inversions, sorted)
    end

    def self.candidates_from_inversions(inversions, notes)
      inversions.map{|intervals|
        chord_form = Tonal::CHORD_FORMS_BY_SEMITONES[intervals.map(&:semitones)]
        next unless chord_form

        Semitonal::Chord.new(chord_form, intervals.first.a, notes)
      }.compact
    end

    def name(root_name)
      "#{root_name}#{form[:signature]}"
    end

    def to_tonal_chords
      tonal_chords = []
      root_candidates = Tonal::Note.candidates(root)
      root_candidates.each do |root|
        tonal_root = notes.find {|n| n.value == root.semitones }.yield_self {|n|
          Tonal::Note.candidates(n).find {|c| c.natural == root.natural }
        }

        tonal_notes = [tonal_root]
        form.intervals.each do |interval|
          note = root + interval

          tonal_notes += notes.select {|n| n.value == note.semitones }.map {|n|
            # 重減、重増を含む場合 nil になる
            Tonal::Note.candidates(n).find {|c| c.natural == note.natural }
          }
        end

        next if tonal_notes.any?(&:nil?)

        tonal_chords << Tonal::Chord.new(form, root, tonal_notes)
      end
      tonal_chords
    end
  end
end
