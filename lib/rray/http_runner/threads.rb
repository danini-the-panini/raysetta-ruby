# frozen_string_literal: true

module Rray
  module HttpRunner
    class Threads < Base
      attr_reader :count

      def initialize(url, count: 4)
        super(url)
        @count = count
      end

      def call
        count.times.map do |i|
          Thread.new { Sync.new(url).connect(i) }
        end.each(&:join)
      end
    end
  end
end
