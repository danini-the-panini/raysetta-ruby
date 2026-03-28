# frozen_string_literal: true

require 'parallel'
require 'etc'

module Raysetta
  module Runner
    class Concurrent < Base
      attr_reader :count, :output

      def initialize(tracer, count: Etc.nprocessors)
        super(tracer)
        @count = count
      end
    end
  end
end
