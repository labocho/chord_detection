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


module Semitonal
  class Pitch
    include Comparable

    attr_reader :midi_pitch, :in_octave

    def initialize(midi_pitch)
      @midi_pitch = midi_pitch
      @in_octave = midi_pitch % 12
    end

    def <=>(other)
      in_octave <=> other.in_octave
    end
  end

  class Interval
    attr_reader :a, :b, :semitones

    def initialize(a, b)
      @a = a
      @b = b
      @semitones = (b.in_octave - a.in_octave) % 12
    end
  end
end

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

module Tonal
  Note = Struct.new(:name) do
    def self.find(name)
      NOTES.find {|n| n.name == name } || raise("Unknown note name `#{name}`")
    end

    def to_s
      name
    end

    def +(integer)
      NOTES[(NOTES.index(self) + integer) % 7]
    end
  end

  NOTES = %w(C D E F G A B).map {|s| Note.new(s).freeze }.freeze

  class Pitch
    attr_reader :natural, :displacement, :octave

    def self.candidates(semitonal_pitch)
      n = semitonal_pitch.midi_pitch / 12 - 1 # middle C を C4 とする

      candidates = case semitonal_pitch.in_octave
      when 0
        [
          "B###{n - 1}",
          "C#{n}",
          "Dbb#{n}",
        ]
      when 1
        [
          "C##{n}",
          "Db#{n}",
        ]
      when 2
        [
          "C###{n}",
          "D#{n}",
          "Ebb#{n}",
        ]
      when 3
        [
          "D##{n}",
          "Eb#{n}",
        ]
      when 4
        [
          "D###{n}",
          "E#{n}",
          "Fb#{n}",
        ]
      when 5
        [
          "E##{n}",
          "F#{n}",
          "Gbb#{n}",
        ]
      when 6
        [
          "E###{n}",
          "F##{n}",
          "Gb#{n}",
        ]
      when 7
        [
          "F###{n}",
          "G#{n}",
          "Abb#{n}",
        ]
      when 8
        [
          "G##{n}",
          "Ab#{n}",
        ]
      when 9
        [
          "G###{n}",
          "A#{n}",
          "Bbb#{n}",
        ]
      when 10
        [
          "A##{n}",
          "Bb#{n}",
          "Cbb#{n + 1}",
        ]
      when 11
        [
          "A###{n}",
          "B#{n}",
          "Cb#{n + 1}",
        ]
      end
      candidates.map {|s| parse(s) }
    end

    def self.parse(s)
      unless s =~ /\A([A-G])(|#|##|b|bb)(\d+)\z/
        raise "Could not parse: #{s.inspect}"
      end

      natural, displacement, octave = $~.captures

      d = case displacement
      when "bb"
        -2
      when "b"
        -1
      when ""
        0
      when "#"
        1
      when "##"
        2
      end

      new(natural, d, octave.to_i)
    end

    # e.g. Pitch.new("C", -2, 1)
    def initialize(natural, displacement, octave)
      @natural = natural.is_a?(Note) ? natural : Note.find(natural)
      @displacement = displacement
      @octave = octave
    end

    def midi_pitch
      i = case natural.name
      when "C"
        0
      when "D"
        2
      when "E"
        4
      when "F"
        5
      when "G"
        7
      when "A"
        9
      when "B"
        11
      end

      i + displacement + (octave + 1) * 12
    end

    def semitones_in_octave
      midi_pitch % 12
    end

    def +(interval)
      interval.add(self)
    end

    def to_s
      "#{natural}#{displacement_text}#{octave}"
    end

    def displacement_text
      ["bb", "b", "", "#", "x"][displacement + 2]
    end
  end

  class Interval
    attr_reader :value

    def self.parse(s)
      new(s)
    end

    def initialize(value)
      @value = value.freeze
    end

    def add(pitch)
      case value
      when ""
        pitch
      when "aug1"
        Pitch.new(pitch.natural, pitch.displacement + 1, pitch.octave)
      when "m3"
        case pitch.natural.name
        when "C", "F", "G"
          Pitch.new(pitch.natural + 2, pitch.displacement - 1, pitch.octave)
        else
          Pitch.new(pitch.natural + 2, pitch.displacement, pitch.octave)
        end
      when "P5"
        case pitch.natural.name
        when "B"
          Pitch.new(pitch.natural + 4, pitch.displacement + 1, pitch.octave)
        else
          Pitch.new(pitch.natural + 4, pitch.displacement, pitch.octave)
        end
      else
        raise NotImplementedError, "Cannot add `#{value}`"
      end
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
