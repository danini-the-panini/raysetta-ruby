# frozen_string_literal: true

module Rray
  module HttpRunner
    class Ractors < Base
      attr_reader :count

      def initialize(url, count: 4)
        super(url)
        @count = count
      end

      def call
        count.times.map do |i|
          Ractor.new(url, i) { |url, i| Sync.new(url).connect(i) }
        end.each(&:take)
      end
    end
  end
end
