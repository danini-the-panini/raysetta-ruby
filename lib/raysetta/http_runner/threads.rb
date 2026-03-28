# frozen_string_literal: true

module Raysetta
  module HttpRunner
    class Threads < Concurrent
      def call(poll: false)
        count.times.map do |i|
          Thread.new { Base.new(@url, poll: @poll).connect(i) }
        end.each(&:join)
      end
    end
  end
end
