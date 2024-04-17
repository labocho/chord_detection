module Semitonal
  class Interval
    attr_reader :a, :b, :semitones

    def initialize(a, b)
      @a = a
      @b = b
      @semitones = (b.in_octave - a.in_octave) % 12
    end
  end
end
