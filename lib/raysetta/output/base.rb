# frozen_string_literal: true

module Raysetta
  module Output
    class Base
      attr_reader :pixels, :width, :height

      def initialize(pixels, width:, height:)
        @pixels = pixels
        @width = width
        @height = height
      end

      def call
        raise NotImplementedError, "Implement #{self.class}#call"
      end

      def save(file)
        File.write(file, call)
      end
    end
  end
end
