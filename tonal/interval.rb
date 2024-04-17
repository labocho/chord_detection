module Tonal
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
