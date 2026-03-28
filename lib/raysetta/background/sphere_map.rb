# frozen_string_literal: true

module Raysetta
  module Background
    class SphereMap < Base
      attr_accessor :texture

      def initialize(texture)
        @texture = texture
      end

      def sample(r)
        unit_direction = r.direction.unit
        uv = Util.sphere_uv(unit_direction)
        texture.sample(uv, unit_direction)
      end

      def textures
        [texture]
      end

      def export
        {
          **super,
          texture: texture.id
        }
      end
    end
  end
end
