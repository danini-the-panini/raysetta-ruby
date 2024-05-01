# frozen_string_literal: true

module Rray
  module HttpRunner
    class Processes < Base
      attr_reader :count

      def initialize(url, count: 4)
        super(url)
        @count = count
      end

      def call
        pids = count.times.map do |i|
          Process.fork { connect(i) }
        end
        pids.each { Process.wait _1 }
      end
    end
  end
end
