# frozen_string_literal: true

module Raysetta
  class Vec2 < Vec
    def self.dimensions = 2

    def initialize(x = 0.0, y = 0.0)
      super
    end

    def x = @e[0]
    def y = @e[1]

    alias :u :x
    alias :v :y

    def x=(v)
      @e[0] = v
    end

    def y=(v)
      @e[1] = v
    end

    alias :u= :x=
    alias :v= :y=

    def self.sample_square = new(rand - 0.5, rand - 0.5)
  end
end
