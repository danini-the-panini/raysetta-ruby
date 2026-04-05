# frozen_string_literal: true

require 'chunky_png'

module Raysetta
  module Output
    class PNG < Base
      def call
        image = ChunkyPNG::Image.new(width, height)

        pixels.each.with_index do |row, y|
          row.each.with_index do |pixel, x|
            image.set_pixel(x, y, ChunkyPNG::Color.rgb(pixel[0], pixel[1], pixel[2]))
          end
        end

        image
      end

      def save(file)
        image = call
        image.save(file, :fast_rgb)
      end
    end
  end
end
