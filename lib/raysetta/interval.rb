# frozen_string_literal: true

module Raysetta
  class Interval
    attr_accessor :min, :max

    # Default interval is empty
    def initialize(min = Float::INFINITY, max = -Float::INFINITY)
      @min = min
      @max = max
    end

    def self.from_range(r)
      new(r.min, r.max)
    end

    # Create the interval tightly enclosing the two input intervals.
    def self.from_intervals(a, b)
      new(
        a.min <= b.min ? a.min : b.min,
        a.max >= b.max ? a.max : b.max
      )
    end

    def size = max - min
    def include?(x) = min <= x && x <= max
    def surround?(x) = min < x && x < max

    def clamp(x)
      return min if x < min
      return max if x > max
      x
    end

    def expand(delta)
      padding = delta / 2.0
      Interval.new(min - padding, max + padding)
    end

    def expand!(delta)
      padding = delta / 2.0
      self.min -= padding
      self.max += padding
      self
    end

    def dup
      Interval.new(min, max)
    end

    def ==(i)
      min == i.min && max == i.max
    end
    alias :eql? :==
    
    def hash
      [min, max].hash
    end

    EMPTY = new(Float::INFINITY, -Float::INFINITY)
    UNIVERSE = new(-Float::INFINITY, Float::INFINITY)
  end
end
