# frozen_string_literal: true

require 'etc'

module Rray
  module HttpRunner
    class Processes < Concurrent

      def call
        pids = count.times.map do |i|
          Process.fork { Base.new(@url, poll: @poll).connect(i) }
        end
        pids.each { Process.wait _1 }
      end
    end
  end
end
