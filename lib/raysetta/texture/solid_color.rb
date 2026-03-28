# frozen_string_literal: true

module Raysetta
  module Texture
    class SolidColor < Base
      attr_accessor :albedo

      def initialize(albedo)
        @albedo = albedo
      end

      def self.rgb(*e)
        new(Color.new(*e))
      end

      def sample(uv, point)
        albedo
      end

      def ==(tex)
        albedo == tex.albedo
      end

      def hash
        [type, albedo].hash
      end

      def export
        {
          **super,
          albedo: albedo.to_a
        }
      end
    end
  end
end
