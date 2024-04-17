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

# def interval(notes)
#   (notes + [notes[0]]).each_cons(2).map do |(a, b)|
#     (b - a) % 12
#   end
# end

require_relative "semitonal"
require_relative "tonal"

def interval(notes)
  (notes + [notes[0]]).each_cons(2).map do |(a, b)|
    Semitonal::Interval.new(a, b)
  end
end

def invert(intervals)
  n = intervals.size
  n.times.map do |root|
    (n - 1).times.map do |j|
      intervals[(root + j) % n]
    end
  end
end

# notes = [57, 60, 64] # a, c, e
# regularized = notes.map {|n| n % 12 } # [9, 0, 4]
# sorted = regularized.sort # [0, 4, 9]
# intervals = interval(sorted) # [4, 5, 3]
# inversions = invert(intervals) # [[4, 5], [5, 3], [3, 4]]
# pp inversions.map{|i| CHORD_FORMS[i] }

notes = [57, 60, 64].map {|n| Semitonal::Pitch.new(n) } # a, c, e
# regularized = notes.map {|n| n % 12 } # [9, 0, 4]
sorted = notes.sort # [0, 4, 9]
intervals = interval(sorted) # [4, 5, 3]
inversions = invert(intervals) # [[4, 5], [5, 3], [3, 4]]
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
