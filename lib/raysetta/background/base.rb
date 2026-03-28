# frozen_string_literal: true

module Raysetta
  module Background
    class Base < EntityBase
      def sample(r)
        raise NotImplementedError, "Implement #{self.class.name}#sample"
      end

      def textures
        []
      end

      def images
        []
      end
    end
  end
end
