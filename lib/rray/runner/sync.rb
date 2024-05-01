# frozen_string_literal: true

module Rray
  module Runner
    class Sync < Base
      attr_reader :output

      def initialize(tracer)
        super
        @output = Array.new(tracer.height) { Array.new(tracer.width) { [0, 0, 0] } }
      end

      def call
        @output.each.with_index do |row, i|
          row.each.with_index do |pixel, j|
            r, g, b = tracer.call(j, i)
            
            pixel[0] = r
            pixel[1] = g
            pixel[2] = b
          end
          progress
        end
        finish
      end
    end
  end
end
