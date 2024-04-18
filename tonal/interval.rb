module Tonal
  Interval = Struct.new(:name, :semitones, :degree, :displacements, keyword_init: true) do
    attr_reader :value

    def self.parse(s)
      INTERVALS.fetch(s)
    end

    def add(note)
      n = note.index_of_natural
      natural = Note::NAMES[
        (n + degree - 1) % 7
      ]
      Note.new(
        natural,
        note.displacement + displacements[n],
      )
    end
  end

  # 略記は https://en.wikipedia.org/wiki/Interval_(music) 参照
  INTERVALS = [
    # 1st
    {name: "P1", semitones:  0, degree: 1, displacements: [ 0,  0,  0,  0,  0,  0,  0]},
    {name: "A1", semitones:  1, degree: 1, displacements: [ 1,  1,  1,  1,  1,  1,  1]},
    # 2nd
    {name: "d2", semitones:  0, degree: 2, displacements: [-2, -2, -1, -2, -2, -2, -1]},
    {name: "m2", semitones:  1, degree: 2, displacements: [-1, -1,  0, -1, -1, -1,  0]},
    {name: "M2", semitones:  2, degree: 2, displacements: [ 0,  0,  1,  0,  0,  0,  1]},
    {name: "A2", semitones:  3, degree: 2, displacements: [ 1,  1,  2,  1,  1,  1,  2]},
    # 3rd
    {name: "d3", semitones:  2, degree: 3, displacements: [-2, -1, -1, -2, -2, -1, -1]},
    {name: "m3", semitones:  3, degree: 3, displacements: [-1,  0,  0, -1, -1,  0,  0]},
    {name: "M3", semitones:  4, degree: 3, displacements: [ 0,  1,  1,  0,  0,  1,  1]},
    {name: "A3", semitones:  5, degree: 3, displacements: [ 1,  2,  2,  1,  1,  2,  2]},
    # 4th
    {name: "d4", semitones:  4, degree: 4, displacements: [-1, -1, -1,  0, -1, -1, -1]},
    {name: "P4", semitones:  5, degree: 4, displacements: [ 0,  0,  0,  1,  0,  0,  0]},
    {name: "A4", semitones:  6, degree: 4, displacements: [ 1,  1,  1,  2,  1,  1,  1]},
    # 5th
    {name: "d5", semitones:  6, degree: 5, displacements: [-1, -1, -1, -1, -1, -1, -2]},
    {name: "P5", semitones:  7, degree: 5, displacements: [ 0,  0,  0,  0,  0,  0,  1]},
    {name: "A5", semitones:  8, degree: 5, displacements: [ 1,  1,  1,  1,  1,  1,  2]},
    # 6th
    {name: "d6", semitones:  7, degree: 6, displacements: [-2, -2, -3, -2, -2, -3, -3]},
    {name: "m6", semitones:  8, degree: 6, displacements: [-1, -1, -2, -1, -1, -2, -2]},
    {name: "M6", semitones:  9, degree: 6, displacements: [ 0,  0,  1,  0,  0,  1,  1]},
    {name: "A6", semitones: 10, degree: 6, displacements: [ 1,  1,  2,  1,  1,  2,  2]},
    # 7th
    {name: "d7", semitones:  9, degree: 7, displacements: [-2, -1, -1, -2, -1, -1, -1]},
    {name: "m7", semitones: 10, degree: 7, displacements: [-1,  0,  0, -1,  0,  0,  0]},
    {name: "M7", semitones: 11, degree: 7, displacements: [ 0,  1,  1,  0,  1,  1,  1]},
    {name: "A7", semitones: 12, degree: 7, displacements: [ 1,  2,  2,  1,  2,  2,  2]},
  ].inject({}) {|h, definition|
    h[definition.fetch(:name)] = Interval.new(**definition)
    h
  }.freeze
end
