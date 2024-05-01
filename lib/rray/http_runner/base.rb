# frozen_string_literal: true

require 'http'

module Rray
  module HttpRunner
    class Base
      POLL_TIME = 1 # seconds

      def initialize(url, poll: false)
        @url = url
        @tracers = {}
        @poll = poll
      end

      def call
        raise NotImplementedError, "Implement #{self.class}#call"
      end

      def connect(i)
        puts "#{i}: Starting"
        loop do
          puts "#{i}: Looking for work"
          slice = fetch_slice
          if slice.nil?
            break unless @poll
            sleep POLL_TIME
            next
          end
          puts "#{i}: Tracing..."

          tracer = create_tracer(slice)
          
          row = Array.new(tracer.width) { [0, 0, 0] }
          row.each.with_index do |pixel, x|
            r, g, b = tracer.call(x, slice['y'])
            
            pixel[0] = r
            pixel[1] = g
            pixel[2] = b
          end

          puts "#{i}: Sending..."
          send_slice(slice, row)
          puts "#{i}: Done"
        end
        puts "#{i}: Finishing"
      end

      private

        def fetch_slice
          response = HTTP.get(URI.join(@url, 'slice.json'))
          return nil unless response.status == 200
          
          JSON.parse(response.to_s)
        end

        def fetch_scene(slice)
          response = HTTP.get(URI.join(@url, 'images/', "#{slice['image_id']}.json"))
          JSON.parse(response.to_s)
        end

        def create_tracer(slice)
          @tracers[slice['image_id']] ||= begin
            scene = fetch_scene(slice)
            Tracer.new(Scene.parse(scene['data']),
              width: scene['width'],
              height: scene['height'],
              samples_per_pixel: scene['samples'],
              max_depth: scene['depth']
            )
          end
        end

        def send_slice(slice, row)
          HTTP.patch(URI.join(@url, 'slices/', "#{slice['id']}.json"), json: { slice: { data: row } })
        end
    end
  end
end
