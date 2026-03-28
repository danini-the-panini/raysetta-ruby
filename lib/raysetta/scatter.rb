# frozen_string_literal: true

module Raysetta
  class Scatter
    attr_accessor :ray, :attenuation

    def initialize(ray, attenuation)
      @ray = ray
      @attenuation = attenuation
    end
  end
end
