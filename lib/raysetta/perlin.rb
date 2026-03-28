# frozen_string_literal: true

module Raysetta
  class Perlin < EntityBase
    POINT_COUNT = 256

    def initialize(
      randvec = Array.new(POINT_COUNT) { Vec3.random(-1.0, 1.0).normalize },
      perm_x = (0...POINT_COUNT).to_a.shuffle!,
      perm_y = (0...POINT_COUNT).to_a.shuffle!,
      perm_z = (0...POINT_COUNT).to_a.shuffle!
    )
      @randvec = randvec
      @perm_x = perm_x
      @perm_y = perm_y
      @perm_z = perm_z
    end

    def noise(point)
      ivec = point.floor
      vec = point - ivec

      i, j, k = ivec
      c = Array.new(2) { Array.new(2) { Array.new(2) } }

      Perlin.each_cube do |di, dj, dk|
        c[di][dj][dk] = @randvec[
          @perm_x[(i + di) & 255] ^
          @perm_y[(j + dj) & 255] ^
          @perm_z[(k + dk) & 255]
        ]
      end

      Perlin.perlin_interp(c, vec)
    end

    def turb(point, depth)
      accum = 0.0
      temp_p = point
      weight = 1.0

      (0...depth).each do
        accum += weight * noise(temp_p)
        weight *= 0.5
        temp_p *= 2.0
      end

      accum.abs
    end

    def ==(perlin)
      randvec == perlin.randvec &&
      perm_x == perlin.perm_x &&
      perm_y == perlin.perm_y &&
      perm_z == perlin.perm_z
    end

    alias :eql? :==

    def hash
      [randvec, perm_x, perm_y, perm_z].hash
    end

    def export
      {
        **super,
        randvec: @randvec.map(&:to_a),
        perm_x: @perm_x,
        perm_y: @perm_y,
        perm_z: @perm_z,
      }
    end

    def self.perlin_interp(c, vec)
      v = vec.smoothstep
      each_cube.sum do |i, j, k|
        weight = vec - Vec3.new(i, j, k)
        (i * v.x + (1 - i) * (1 - v.x)) *
        (j * v.y + (1 - j) * (1 - v.y)) *
        (k * v.z + (1 - k) * (1 - v.z)) *
        c[i][j][k].dot(weight)
      end
    end

    def self.each_cube(&block)
      [0, 1].product([0, 1], [0, 1]).each(&block)
    end
  end
end
