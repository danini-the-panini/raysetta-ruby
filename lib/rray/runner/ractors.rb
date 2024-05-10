# frozen_string_literal: true

require 'parallel'

module Rray
  module Runner
    class Ractors < Base
      attr_reader :output

      def call
        Ractor.make_shareable(tracer)
        @output = Parallel.map(tracer.height.times.map { [_1, tracer] }, in_ractors: count, ractor: [self.class, :run], finish: proc { progress })
        finish
      end

      def self.run((y, tracer))
        row = Array.new(tracer.width) { [0, 0, 0] }
        row.each.with_index do |pixel, x|
          r, g, b = tracer.call(x, y)
                
          pixel[0] = r
          pixel[1] = g
          pixel[2] = b
        end
        row
      end
    end
  end
end
