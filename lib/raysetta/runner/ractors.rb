# frozen_string_literal: true

require 'parallel'

module Raysetta
  module Runner
    class Ractors < Concurrent
      attr_reader :output

      def call
        Ractor.make_shareable(tracer)
        @output = Parallel.map(tracer.height.times.map { [_1, tracer] }, in_ractors: count, ractor: [self.class, :run], finish: proc { progress })
        finish
      end

      def self.run(args)
        y = args[0] #: Integer
        tracer = args[1] #: Tracer

        row = Array.new(tracer.width) { [0, 0, 0] } #: Array[[Integer, Integer, Integer]]
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
