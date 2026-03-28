# frozen_string_literal: true

module Raysetta
  module Material
    class DiffuseLight < Base
      attr_accessor :texture

      def initialize(texture)
        @texture = texture
      end

      def self.solid(albedo)
        new(Texture::SolidColor.new(albedo))
      end

      def emitted(uv, point)
        texture.sample(uv, point)
      end

      def ==(mat)
        return false unless mat.is_a?(DiffuseLight)

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
