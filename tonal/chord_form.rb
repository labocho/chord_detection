require_relative "interval"

module Tonal
  ChordForm = Struct.new(:name, :intervals, :signature) do
    def initialize(*args, **kw)
      super
    end
  end

  CHORD_FORMS = [
    {
      name: "minor triad",
      intervals: %w(m3 P5),
      signature: "m",
    },
    {
      name: "minor triad",
      intervals: %w(m3 P5),
      signature: "m",
    },
  ].map {|h|
    ChordForm.new(h[:name], h[:intervals].map {|s| Interval.parse(s) }, h[:signature])
  }

  CHORD_FORMS_BY_SEMITONES = CHORD_FORMS.inject({}) {|h, chord_form|
    intervals_from_root = chord_form.intervals.map(&:semitones)

    intervals_between_tones = []
    intervals_from_root.inject(0) {|n, interval|
      intervals_between_tones << (interval - n)
      n + interval
    }

    h[intervals_between_tones] = chord_form
    h
  }
end
