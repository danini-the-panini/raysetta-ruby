# frozen_string_literal: true

module Raysetta
  class Vec2
    attr_accessor :x, :y

    alias :u :x
    alias :v :y

    alias :u= :x=
    alias :v= :y=

    def initialize(x = 0.0, y = x)
      @x = x
      @y = y
    end

    def self.random(min = 0.0, max = 1.0)
      Vec2.new(Util.random(min, max), Util.random(min, max))
    end

    def self.sample_square = new(rand - 0.5, rand - 0.5)

    def to_a = [x, y]
    alias :to_ary :to_a

    def [](i)
      return x if i == 0
      return y if i == 1
      0.0
    end

    def []=(i, v)
      self.x = v if i == 0
      self.y = v if i == 1
    end

    def -@
      Vec2.new(-x, -y)
    end

    def +(v) = Vec2.new(x + v.x, y + v.y)
    def -(v) = Vec2.new(x - v.x, y - v.y)
    def *(t) = Vec2.new(x * t, y * t)
    def /(t) = self * (1.0/t)

    def add(v)
      self.x += v.x
      self.y += v.y
      self
    end

    def sub(v)
      self.x -= v.x
      self.y -= v.y
      self
    end

    def mul(t)
      self.x *= t
      self.y *= t
      self
    end

    def div(t)
      mul(1.0/t)
      self
    end

    def neg
      self.x = -x
      self.y = -y
      self
    end

    def length = Math.sqrt(length_squared)
    def length_squared = dot(self)

    def dot(v)
      x * v.x + y * v.y
    end

    def unit = self / length

    def normalize
      div(length)
      self
    end

    def dup = Vec2.new(x, y)

    def abs!
      self.x = x.abs
      self.y = y.abs
      self
    end

    def abs
      Vec2.new(x.abs, y.abs)
    end

    # Return true if the vector is close to zero in all dimensions.
    def zero?
      x.abs < Util::EPSILON &&
      y.abs < Util::EPSILON
    end

    def to_s
      "(#{x}, #{y})"
    end

    def ==(v)
      (x - v.x).abs < Util::EPSILON && (y - v.y).abs < Util::EPSILON
    end
    alias :eql? :==

    def eql?(v)
      x == v.x && y == v.y
    end

    def hash
      [x, y].hash
    end
  end
end
