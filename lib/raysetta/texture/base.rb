# frozen_string_literal: true

module Raysetta
  module Texture
    class Base < EntityBase
      def sample(uv, point)
        raise NotImplementedError, "Implement #{self.class.name}#sample"
      end

      def images
        []
      end

      def noises
        []
      end
    end
  end
end