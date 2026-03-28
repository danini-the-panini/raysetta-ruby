# frozen_string_literal: true

module Raysetta
  module Background
    class Solid < Base
      attr_accessor :albedo

      def initialize(albedo)
        @albedo = albedo
      end

      def sample(r)
        albedo
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
