module Semitonal
  class Note
    include Comparable

    attr_reader :value

    def initialize(midi_pitch)
      @value = midi_pitch % 12
    end

    def <=>(other)
      value <=> other.value
    end
  end
end
