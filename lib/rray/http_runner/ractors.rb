# frozen_string_literal: true

module Rray
  module HttpRunner
    class Ractors < Concurrent
      attr_reader :count

      def initialize(...)
        raise NotImplementedError, "Ractor HTTP runner not implemented"
      end
    end
  end
end
