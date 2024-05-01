# frozen_string_literal: true

module Rray
  module Output
    class PPM < Base
      def call
        buffer = "P3\n#{width} #{height}\n255\n"

        pixels.each do |row|
          row.each do |pixel|
            buffer << pixel.join(' ') << "\n"
          end
        end

        buffer
      end
    end
  end
end
