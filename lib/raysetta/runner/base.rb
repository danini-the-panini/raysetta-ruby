# frozen_string_literal: true

require 'progress'

module Raysetta
  module Runner
    class Base
      attr_reader :tracer

      def initialize(tracer)
        @tracer = tracer
        Progress.start("Tracing", tracer.height)
      end

      def call
        raise NotImplementedError, "Implement #{self.class}#call"
      end

      def progress
        Progress.step
      end

      def finish
        Progress.stop
      end
    end
  end
end
