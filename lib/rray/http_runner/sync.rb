# frozen_string_literal: true

module Rray
  module HttpRunner
    class Sync < Base
      def call
        connect(0)
      end
    end
  end
end
