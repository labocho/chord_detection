module Tonal
  Chord = Struct.new(:form, :root, :notes) do
    def name
      "#{root}#{form.signature}"
    end

    def pitches_from_midi_note_numbers(midi_note_numbers)
      midi_note_numbers.map {|i|
        n = i % 12 # semitones in octave
        octave = i / 12 - 1 # middle C = 4

        note = notes.find {|pitch| pitch.semitones_in_octave == n }
        "#{note}#{octave}"
      }
    end
  end
end
