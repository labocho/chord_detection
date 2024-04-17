# 半音階的音程
# 2 つのピッチとその半音階的音程を保持する
module Semitonal
  class Interval
    attr_reader :a, :b, :semitones

    # となり合ったピッチそれぞれの音程を返す
    # C, E, A
    # [
    #   Interval(a: C, b: E, semitones: 4),
    #   Interval(a: E, b: A, semitones: 5),
    #   Interval(a: A, b: C, semitones: 3),
    # ]
    # @param pitches [Array<Semitonal::Pitch>] ソート済の Pitch の配列
    # @return [Array<Semitonal::Interval>
    def self.intervals_of(pitches)
      (pitches + [pitches[0]]).each_cons(2).map do |(a, b)|
        Semitonal::Interval.new(a, b)
      end
    end

    # 音程のリストから、すべての転回系の最低音からの音程のリストを返す
    # [
    #   Interval(a: C, b: E, semitones: 4),
    #   Interval(a: E, b: A, semitones: 5),
    #   Interval(a: A, b: C, semitones: 3),
    # ]
    # なら
    # [
    #   # C-E-A
    #   [
    #     Interval(a: C, b: E, semitones: 4),
    #     Interval(a: E, b: A, semitones: 5),
    #   ],
    #   # E-A-C
    #   [
    #     Interval(a: E, b: A, semitones: 5),
    #     Interval(a: A, b: C, semitones: 3),
    #   ],
    #   # A-C-E
    #   [
    #     Interval(a: A, b: C, semitones: 3),
    #     Interval(a: C, b: E, semitones: 4),
    #   ],
    # ]
    # @param intervals [Array<Semitonal::Intervals>]
    # @return [Array<Array<Semitonal::Interval>>]
    def self.inversions(intervals)
      n = intervals.size
      n.times.map do |root|
        (n - 1).times.map do |j|
          intervals[(root + j) % n]
        end
      end
    end

    def initialize(a, b)
      @a = a
      @b = b
      @semitones = (b.in_octave - a.in_octave) % 12
    end
  end
end
