# frozen_string_literal: true

module Rray
  module HttpRunner
    class Threads < Base
      attr_reader :count

      def initialize(url, count: 4, **options)
        super(url, **options)
        @count = count
      end

      def call(poll: false)
        count.times.map do |i|
          Thread.new { Base.new(@url, poll: @poll).connect(i) }
        end.each(&:join)
      end
    end
  end
end
