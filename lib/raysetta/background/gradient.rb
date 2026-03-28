# frozen_string_literal: true

module Raysetta
  module Background
    class Gradient < Base
      attr_accessor :top, :bottom

      def initialize(top, bottom)
        @top = top
        @bottom = bottom
      end

      def sample(r)
        unit_direction = r.direction.unit
        a = 0.5 * (unit_direction.y + 1.0)
        bottom * (1.0 - a) + top * a
      end

      def export
        {
          **super,
          top: top.to_a,
          bottom: bottom.to_a
        }
      end
    end
  end
end
