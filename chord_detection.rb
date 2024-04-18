
require_relative "semitonal"
require_relative "tonal"
require "json"

key = Tonal::KEYS["C"]
midi_note_numbers = [57, 60, 64, 48]
# key = Tonal::KEYS["c"]
# midi_note_numbers = [59, 62, 65, 68]
chords = Semitonal::Chord.candidates_from_midi_note_numbers(midi_note_numbers)

chords.each do |chord|
  chord.to_tonal_chords.each do |c|
    puts JSON.pretty_generate(
      {
        code: c.name,
        pitches: c.pitches_from_midi_note_numbers(midi_note_numbers),
        number_of_accidentals: key.number_of_accidentals(c.notes)
      }
    )
  end
end
