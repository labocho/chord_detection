module Semitonal
  Chord = Struct.new(:form, :root, :notes) do
    def name(root_name)
      "#{root_name}#{form[:signature]}"
    end
  end
end
