# frozen_string_literal: true

module Raysetta
  class Ray
    attr_accessor :origin, :direction, :time

    def initialize(origin, direction, time = 0.0)
      @origin = origin
      @direction = direction
      @time = time
    end

    def at(t) = (direction*t).add(origin)

    def dup = self.class.new(origin.dup, direction.dup, time)

    def ==(r)
      origin == r.origin &&
      direction == r.direction &&
      (time- r.time).abs < Vec3::EPSILON
    end
    alias :eql? :==

    def hash
      [origin, direction, time].hash
    end
  end
end
