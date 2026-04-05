# frozen_string_literal: true

module Raysetta
  class Vec
    def self.dimensions
      raise NotImplementedError, "implement #{self}.dimensions"
    end

    def initialize(*args)
      @e = args
    end

    def self.repeat(t)
      new(*Array.new(dimensions, t))
    end

    def to_a
      e.dup
    end
    alias :to_ary :to_a

    def -@
      self.class.new(*e.map(&:-@))
    end

    def [](i)
      e[i]
    end

    def []=(i, v)
      e[i] = v
    end

    def +(v) = self.class.new(*e.zip(v.e).map(&:sum))
    def -(v) = self.class.new(*e.zip(v.e.map(&:-@)).map(&:sum))
    def *(t) = self.class.new(*e.map{_1*t})
    def /(t) = self * (1.0/t)

    def add(v)
      e.each_index { self[_1] += v[_1] }
      self
    end

    def sub(v)
      e.each_index { self[_1] -= v[_1] }
      self
    end

    def mul(t)
      e.each_index { self[_1] *= t }
      self
    end

    def div(t)
      mul(1.0/t)
      self
    end

    def neg
      e.each_index { self[_1] = -self[_1] }
      self
    end

    def length = Math.sqrt(length_squared)
    def length_squared = dot(self)

    def dot(v)
      e.zip(v.e).map { _1*_2 }.sum
    end

    def unit = self / length

    def normalize
      div(length)
      self
    end

    def dup = self.class.new(*e)

    def abs!
      e.map!(&:abs)
      self
    end
    def abs = dup.abs!

    def smoothstep!
      e.map! { _1**2 * (3.0 - 2.0 * _1) }
      self
    end
    def smoothstep = dup.smoothstep!

    EPSILON = 1e-8
    # Return true if the vector is close to zero in all dimensions.
    def zero? = e.all? { _1.abs < EPSILON }

    def to_s
      "(#{e.join(', ')})"
    end

    def ==(v)
      e.each.with_index.all? { |x, i| (x-v[i]).abs < EPSILON }
    end
    alias :eql? :==

    def eql?(v)
      e == v.e
    end

    def hash
      e.hash
    end

    def self.random(min = 0.0, max = 1.0)
      new(*Array.new(dimensions) { Util.random(min, max) })
    end

    protected
    attr_reader :e
  end
end
