
require_relative "semitonal"
require_relative "tonal"

midi_note_numbers = [57, 60, 64]

notes = midi_note_numbers.map {|n| Semitonal::Note.new(n) } # a, c, e
sorted = notes.sort # [0, 4, 9]
intervals = Semitonal::Interval.intervals_of(sorted) # [4, 5, 3]
inversions = Semitonal::Interval.inversions(intervals) # [[4, 5], [5, 3], [3, 4]]

chords = Semitonal::Chord.candidates_from_inversions(inversions, notes)

chords.each do |chord|
  chord.to_tonal_chords.each do |c|
    puts c.name
    p c.pitches_from_midi_note_numbers(midi_note_numbers)
  end
end
