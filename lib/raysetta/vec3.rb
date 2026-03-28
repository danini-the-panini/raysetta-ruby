# frozen_string_literal: true

module Raysetta
  class Vec3 < Vec
    def self.dimensions = 3

    def initialize(x = 0.0, y = 0.0, z = 0.0)
      super
    end

    def x = @e[0]
    def y = @e[1]
    def z = @e[2]

    def x=(v)
      @e[0] = v
    end

    def y=(v)
      @e[1] = v
    end

    def z=(v)
      @e[2] = v
    end

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
  end
end
