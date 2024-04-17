module Tonal
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
end
