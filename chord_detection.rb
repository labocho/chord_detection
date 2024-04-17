CHORD_FORMS = {
  [3, 4] => {
    name: "minor triad",
    tones: ["m3", "P5"],
    signature: "m",
  },
  [4, 3] => {
    name: "major triad",
    tones: ["M3", "P5"],
    signature: "",
  },
}

require_relative "semitonal"
require_relative "tonal"

notes = [57, 60, 64].map {|n| Semitonal::Pitch.new(n) } # a, c, e
# regularized = notes.map {|n| n % 12 } # [9, 0, 4]
sorted = notes.sort # [0, 4, 9]
intervals = Semitonal::Interval.intervals_of(sorted) # [4, 5, 3]
inversions = Semitonal::Interval.inversions(intervals) # [[4, 5], [5, 3], [3, 4]]

chords = inversions.map{|(i1, i2)|
  chord_form = CHORD_FORMS[[i1.semitones, i2.semitones]]
  next unless chord_form
  {
    chord_form: chord_form,
    root: i1.a,
    notes: notes,
    signaturue: i1.a
  }
}.compact
pp chords

chords.each do |chord|
  root_candidates = Tonal::Pitch.candidates(chord[:root])
  root_candidates.each do |root|
    notes = chord[:notes].select {|n| n.in_octave == root.semitones_in_octave }.map {|n|
      Tonal::Pitch.candidates(n).find {|c| c.natural == root.natural }
    }

    chord[:chord_form][:tones].each do |interval|
      note = root + Tonal::Interval.parse(interval)

      notes += chord[:notes].select {|n| n.in_octave == note.semitones_in_octave }.map {|n|
        Tonal::Pitch.candidates(n).find {|c| c.natural == note.natural }
      }
    end

    puts notes.map(&:to_s)
  end
end
