# frozen_string_literal: true

module Raysetta
  module Material
    class Base < EntityBase
      def emitted(uv, point)
        return Vec3.new
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
