module Tonal
  Key = Struct.new(:key, :name, :displacements, keyword_init: true) do
    def number_of_accidentals(notes)
      notes.inject(0) do |sum, note|
        accidental = displacements[note.index_of_natural] == note.displacement ? 0 : 1
        sum + accidental
      end
    end
  end

  KEYS = [
    {key: "C", name: "C major", displacements: [ 0,  0,  0,  0,  0,  0,  0]},
    {key: "G", name: "G major", displacements: [ 0,  0,  0,  1,  0,  0,  0]},
    {key: "D", name: "D major", displacements: [ 1,  0,  0,  1,  0,  0,  0]},
    {key: "A", name: "A major", displacements: [ 1,  0,  0,  1,  1,  0,  0]},

    {key: "c", name: "C minor", displacements: [ 0,  0, -1,  0,  0, -1, -1]},
  ].inject({}) {|h, definition|
    h[definition[:key]] = Key.new(**definition)
    h
  }.freeze
end
