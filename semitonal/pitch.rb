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
end
