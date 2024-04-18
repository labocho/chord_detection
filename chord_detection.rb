
require_relative "semitonal"
require_relative "tonal"

midi_note_numbers = [57, 60, 64, 48]
chords = Semitonal::Chord.candidates_from_midi_note_numbers(midi_note_numbers)

chords.each do |chord|
  chord.to_tonal_chords.each do |c|
    puts c.name
    p c.pitches_from_midi_note_numbers(midi_note_numbers)
  end
end
