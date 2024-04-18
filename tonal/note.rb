module Tonal
  class Note
    NAMES = %w(C D E F G A B).map(&:freeze).freeze

    attr_reader :natural, :displacement

    def self.candidates(semitonal_pitch)
      candidates = case semitonal_pitch.value
      when 0
        [
          "B#",
          "C",
          "Dbb",
        ]
      when 1
        [
          "C#",
          "Db",
        ]
      when 2
        [
          "C##",
          "D",
          "Ebb",
        ]
      when 3
        [
          "D#",
          "Eb",
        ]
      when 4
        [
          "D##",
          "E",
          "Fb",
        ]
      when 5
        [
          "E#",
          "F",
          "Gbb",
        ]
      when 6
        [
          "E##",
          "F#",
          "Gb",
        ]
      when 7
        [
          "F##",
          "G",
          "Abb",
        ]
      when 8
        [
          "G#",
          "Ab",
        ]
      when 9
        [
          "G##",
          "A",
          "Bbb",
        ]
      when 10
        [
          "A#",
          "Bb",
          "Cbb",
        ]
      when 11
        [
          "A##",
          "B",
          "Cb",
        ]
      end
      candidates.map {|s| parse(s) }
    end

    def self.parse(s)
      unless s =~ /\A([A-G])(|#|##|b|bb)\z/
        raise "Could not parse: #{s.inspect}"
      end

      natural, displacement = $~.captures

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

      new(natural, d)
    end

    # e.g. Pitch.new("C", -2, 1)
    def initialize(natural, displacement)
      @natural = natural
      @displacement = displacement
    end

    def semitones
      i = case natural
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

      (i + displacement) % 12
    end

    def index_of_natural
      NAMES.index(natural)
    end

    def +(interval)
      interval.add(self)
    end

    def to_s
      "#{natural}#{displacement_text}"
    end

    def displacement_text
      ["bb", "b", "", "#", "x"][displacement + 2]
    end
  end
end
