# frozen_string_literal: true

module Rray
  module HttpRunner
    class Ractors < Base
      attr_reader :count

      def initialize(url, count: 4, **options)
        super(url, **options)
        @count = count
      end

      def call
        count.times.map do |i|
          Ractor.new(url, i, @poll) { |url, i, poll| Sync.new(url, poll:).connect(i) }
        end.each(&:take)
      end
    end
  end
end
