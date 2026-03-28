# frozen_string_literal: true

module Raysetta
  module Texture
    class Checker < Base
      attr_accessor :inv_scale, :even, :odd

      def initialize(scale, even, odd)
        self.scale = scale
        @even = even
        @odd = odd
      end

      def self.solid(scale, even, odd)
        new(scale, SolidColor.new(even), SolidColor.new(odd))
      end

      def scale=(scale)
        @inv_scale = 1.0 / scale
      end

      def scale
        1.0 / @inv_scale
      end

      def sample(uv, point)
        x = (inv_scale * point.x).floor
        y = (inv_scale * point.y).floor
        z = (inv_scale * point.z).floor


        (x + y + z).even? ? even.sample(uv, point) : odd.sample(uv, point)
      end

      def ==(tex)
        inv_scale == tex.inv_scale &&
        even == tex.even &&
        odd == tex.odd
      end

      def hash
        [inv_scale, even, odd].hash
      end

      def export
        {
          **super,
          scale: scale,
          even: even.export,
          odd: odd.export
        }
      end
    end
  end
end
