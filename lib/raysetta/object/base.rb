# frozen_string_literal: true

module Raysetta
  module Object
    class Base < EntityBase
      def hit(r, ray_t)
        raise NotImplementedError, "Implement #{self.class.name}#hit"
      end

      def bounding_box
        raise NotImplementedError, "Implement #{self.class.name}#bounding_box"
      end

      def materials
        []
      end

      def objects
        [self]
      end
    end
  end
end
