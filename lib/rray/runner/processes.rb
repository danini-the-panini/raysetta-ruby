# frozen_string_literal: true

require 'parallel'

module Rray
  module Runner
    class Processes < Concurrent
      attr_reader :output

      def call
        @output = Parallel.map(tracer.height.times.to_a, in_processes: count, finish: proc { progress }) do |y|
          row = Array.new(tracer.width) { [0, 0, 0] }
          row.each.with_index do |pixel, x|
            r, g, b = tracer.call(x, y)
                  
            pixel[0] = r
            pixel[1] = g
            pixel[2] = b
          end
          row
        end
        finish
      end
    end
  end
end
