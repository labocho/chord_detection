require_relative "interval"

module Tonal
  ChordForm = Struct.new(:name, :intervals, :signature) do
    def initialize(*args, **kw)
      super
    end
  end

  CHORD_FORMS = [
    {
      name: "major triad",
      intervals: %w(M3 P5),
      signature: "",
    },
    {
      name: "minor triad",
      intervals: %w(m3 P5),
      signature: "m",
    },
    {
      name: "diminish 7th",
      intervals: %w(m3 d5 d7),
      signature: "dim7",
    },
  ].map {|h|
    ChordForm.new(h[:name], h[:intervals].map {|s| Interval.parse(s) }, h[:signature])
  }

  CHORD_FORMS_BY_SEMITONES = CHORD_FORMS.inject({}) {|h, chord_form|
    intervals_from_root = chord_form.intervals.map(&:semitones)

    intervals_between_tones = []
    intervals_from_root.inject(0) {|n, interval|
      i = (interval - n)
      intervals_between_tones << i
      n + i
    }

    h[intervals_between_tones] = chord_form
    h
  }
end
