module Tonal
  Note = Struct.new(:name) do
    def self.find(name)
      NOTES.find {|n| n.name == name } || raise("Unknown note name `#{name}`")
    end

    def to_s
      name
    end

    def +(integer)
      NOTES[(NOTES.index(self) + integer) % 7]
    end
  end

  NOTES = %w(C D E F G A B).map {|s| Note.new(s).freeze }.freeze
end