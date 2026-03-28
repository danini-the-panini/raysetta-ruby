# frozen_string_literal: true

module Raysetta
  module Material
    class Base < EntityBase
      def emitted(uv, point)
        return Color.new(0.0, 0.0, 0.0)
      end

      def scatter(r_in, rec)
        nil
      end

      def textures
        []
      end
    end
  end
end
