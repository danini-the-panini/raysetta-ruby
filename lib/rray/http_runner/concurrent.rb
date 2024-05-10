# frozen_string_literal: true

require 'etc'

module Rray
  module HttpRunner
    class Concurrent < Base
      attr_reader :count

      def initialize(url, count: Etc.nprocessors, **options)
        super(url, **options)
        @count = count
      end
    end
  end
end
