# frozen_string_literal: true

module Raysetta
  class Vec3
    attr_accessor :x, :y, :z

    alias :r :x
    alias :g :y
    alias :b :z

    alias :r= :x=
    alias :g= :y=
    alias :b= :z=

    def initialize(x = 0.0, y = x, z = y)
      @x = x
      @y = y
      @z = z
    end

    def self.random(min = 0.0, max = 1.0)
      Vec3.new(Util.random(min, max), Util.random(min, max), Util.random(min, max))
    end

    def self.random_in_unit_sphere
      loop do
        v = random(-1.0, 1.0)
        return v if v.length_squared < 1
      end
    end

    def self.random_unit = random_in_unit_sphere.normalize

    def self.random_on_hemisphere(normal)
      on_unit_sphere = random_unit
      if on_unit_sphere.dot(normal) > 0.0 # In the same hemisphere as the normal
        on_unit_sphere
      else
        -on_unit_sphere
      end
    end

    def self.random_in_unit_disk
      loop do
        v = new(Util.random(-1.0, 1.0), Util.random(-1.0, 1.0), 0.0)
        return v if v.length_squared < 1
      end
    end

    def to_a = [x, y, z]
    alias :to_ary :to_a

    def [](i)
      return x if i == 0
      return y if i == 1
      return z if i == 2
      0.0
    end

    def []=(i, v)
      self.x = v if i == 0
      self.y = v if i == 1
      self.z = v if i == 2
    end

    def -@
      Vec3.new(-x, -y, -z)
    end

    def +(v) = Vec3.new(x + v.x, y + v.y, z + v.z)
    def -(v) = Vec3.new(x - v.x, y - v.y, z - v.z)
    def *(t) = Vec3.new(x * t, y * t, z * t)
    def /(t) = self * (1.0/t)

    def add(v)
      self.x += v.x
      self.y += v.y
      self.z += v.z
      self
    end

    def sub(v)
      self.x -= v.x
      self.y -= v.y
      self.z -= v.z
      self
    end

    def mul(t)
      self.x *= t
      self.y *= t
      self.z *= t
      self
    end

    def multiply(v)
      self.x *= v.x
      self.y *= v.y
      self.z *= v.z
      self
    end

    def times(v)
      dup.multiply(v)
    end

    def div(t)
      mul(1.0/t)
      self
    end

    def neg
      self.x = -x
      self.y = -y
      self.z = -z
      self
    end

    def length = Math.sqrt(length_squared)
    def length_squared = dot(self)

    def dot(v)
      x * v.x + y * v.y + z * v.z
    end

    def unit = self / length

    def normalize
      div(length)
      self
    end

    def dup = Vec3.new(x, y, z)

    def abs!
      self.x = x.abs
      self.y = y.abs
      self.z = z.abs
      self
    end

    def abs
      Vec3.new(x.abs, y.abs, z.abs)
    end

    def smoothstep!
      self.x = x**2 * (3.0 - 2.0 * x)
      self.y = y**2 * (3.0 - 2.0 * y)
      self.z = z**2 * (3.0 - 2.0 * z)
      self
    end
    def smoothstep = dup.smoothstep!

    def cross(v)
      Vec3.new(
        y * v.z - z * v.y,
        z * v.x - x * v.z,
        x * v.y - y * v.x
      )
    end

    def reflect(n)
      self - n * (dot(n) * 2.0)
    end

    def refract(n, etai_over_etat)
      cos_theta = [(-self).dot(n), 1.0].min
      r_out_perp = (self + n * cos_theta).mul(etai_over_etat)
      r_out_parallel = n * -Math.sqrt((1.0 - r_out_perp.length_squared).abs)
      r_out_perp.add(r_out_parallel)
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

    def zero?
      x.abs < Util::EPSILON &&
      y.abs < Util::EPSILON &&
      z.abs < Util::EPSILON
    end

    def to_s
      "(#{x}, #{y}, #{z})"
    end

    def ==(v)
      (x - v.x).abs < Util::EPSILON &&
      (y - v.y).abs < Util::EPSILON &&
      (z - v.z).abs < Util::EPSILON
    end
    alias :eql? :==

    def eql?(v)
      x == v.x && y == v.y && z == v.z
    end

    def hash
      [x, y, z].hash
    end
  end
end
