# frozen_string_literal: true

module Raysetta
  class Color < Vec3
    def r = x
    def g = y
    def b = z

    def r=(v)
      self.x = v
    end

    def g=(v)
      self.y = v
    end

    def b=(v)
      self.z = v
    end

    def multiply(v)
      self.r *= v.r
      self.g *= v.g
      self.b *= v.b
      self
    end

    def times(v)
      dup.multiply(v)
    end

    def to_pixel
      # Apply a linear to gamma transform for gamma 2
      rg = Util.linear_to_gamma(r)
      gg = Util.linear_to_gamma(g)
      bg = Util.linear_to_gamma(b)

      # Translate the [0,1] component values to the byte range [0,255].
      intensity = Interval.new(0.000, 0.999)
      rbyte = (256 * intensity.clamp(rg)).to_i
      gbyte = (256 * intensity.clamp(gg)).to_i
      bbyte = (256 * intensity.clamp(bg)).to_i

      # Return the pixel color components.
      [rbyte, gbyte, bbyte]
    end
  end
end
