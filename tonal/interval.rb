module Tonal
  class Interval
    # 略記は https://en.wikipedia.org/wiki/Interval_(music) 参照
    SEMITONAL = {
      # 1st
      "P1" => 0,
      "A1" => 1,
      # 2nd
      "d2" => 0,
      "m2" => 1,
      "M2" => 2,
      "A2" => 3,
      # 3rd
      "d3" => 2,
      "m3" => 3,
      "M3" => 4,
      "A3" => 5,
      # 4th
      "d4" => 4,
      "P4" => 5,
      "A4" => 6,
      # 5th
      "d5" => 6,
      "P5" => 7,
      "A5" => 8,
      # 6th
      "d6" => 7,
      "m6" => 8,
      "M6" => 9,
      "A6" => 10,
      # 7th
      "d7" => 9,
      "m7" => 10,
      "M7" => 11,
      "A7" => 12,
    }.transform_keys(&:freeze).freeze

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
      when "A1"
        Pitch.new(pitch.natural, pitch.displacement + 1)
      when "m3"
        case pitch.natural.name
        when "C", "F", "G"
          Pitch.new(pitch.natural + 2, pitch.displacement - 1)
        else
          Pitch.new(pitch.natural + 2, pitch.displacement)
        end
      when "P5"
        case pitch.natural.name
        when "B"
          Pitch.new(pitch.natural + 4, pitch.displacement + 1)
        else
          Pitch.new(pitch.natural + 4, pitch.displacement)
        end
      else
        raise NotImplementedError, "Cannot add `#{value}`"
      end
    end

    def semitonal
      SEMITONAL.fetch(value)
    end
  end
end
