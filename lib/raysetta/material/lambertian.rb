# frozen_string_literal: true

module Raysetta
  module Material
    class Lambertian < Base
      attr_accessor :texture

      def initialize(texture)
        @texture = texture
      end

      def self.solid(albedo)
        new(Texture::SolidColor.new(albedo))
      end

      def scatter(r_in, rec)
        scatter_direction = rec.normal + Vec3.random_unit

        # Catch degenerate scatter direction
        scatter_direction = rec.normal if scatter_direction.zero?

        scattered = Ray.new(rec.point, scatter_direction, r_in.time)
        Scatter.new(scattered, texture.sample(rec.uv, rec.point))
      end

      def ==(mat)
        return false unless mat.is_a?(Lambertian)

        texture == mat.texture
      end

      def hash
        [type, texture].hash
      end

      def export
        {
          **super,
          texture: texture.id,
        }
      end

      def textures
        [texture]
      end
    end
  end
end
