# frozen_string_literal: true

module Raysetta
  module Material
    class Metal < Base
      attr_accessor :texture, :fuzz

      def initialize(texture, fuzz)
        @texture = texture
        @fuzz = fuzz
      end

      def self.solid(albedo, fuzz)
        new(Texture::SolidColor.new(albedo), fuzz)
      end

      def scatter(r_in, rec)
        reflected = r_in.direction.reflect(rec.normal)
        reflected = reflected.normalize.add(Vec3.random_unit.mul(fuzz))
        scattered = Ray.new(rec.point, reflected, r_in.time)
        return nil if scattered.direction.dot(rec.normal) <= 0

        Scatter.new(scattered, texture.sample(rec.uv, rec.point))
      end

      def ==(mat)
        return false unless mat.is_a?(Metal)

        texture == mat.texture && fuzz == mat.fuzz
      end

      def hash
        [type, texture, fuzz].hash
      end

      def export
        {
          **super,
          texture: texture.id,
          fuzz: fuzz,
        }
      end

      def textures
        [texture]
      end
    end
  end
end
