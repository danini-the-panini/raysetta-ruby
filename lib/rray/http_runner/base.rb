# frozen_string_literal: true

require 'net/http'
require 'json'

module Rray
  module HttpRunner
    class HTTP
      class Response
        def initialize(http_response)
          @http_response = http_response
        end

        def to_s
          @http_response.body
        end

        def status
          @http_response.code.to_i
        end
      end

      def initialize(address)
        uri = URI.parse(address)
        @http = Net::HTTP.new(uri.host, uri.port)
        @http.start
      end

      def get(uri)
        Response.new(@http.request(Net::HTTP::Get.new(uri)))
      end

      def patch(uri, json:)
        request = Net::HTTP::Patch.new((uri))
        request.body = json.to_json
        request['Content-type'] = 'application/json'
        Response.new(@http.request(request)).tap { check_error _1 }
      end

      def finish
        @http.finish
      end

      def self.start(address)
        http = new(address)
        ret = yield http
        http.finish
        ret
      end

      def self.get(uri)
        start(uri) { _1.get(uri) }
      end

      def self.patch(uri, json:)
        start(uri) { _1.patch(uri, json:) }
      end

      private

        def check_error(response)
          raise "HTTP #{response.status} ERROR: #{@url}" unless (200..300).include?(response.status)
        end
    end

    class SliceFetcher
      def initialize(url)
        @url = url
        @queue = []
        5.times { @queue.unshift(fetch) }
      end

      def slice
        if @queue.size <= 5
          (5 - @queue.size + 1).times { @queue.unshift(fetch) }
        end

        @queue.pop.value
      end

      def finish
        @queue.each(&:join)
      end

      private

        def fetch
          Thread.new do
            response = HTTP.get(URI.join(@url, 'slice.json'))
            if response.status == 200
              JSON.parse(response.to_s)
            end
          end
        end
    end

    class Base
      POLL_TIME = 1 # seconds

      def initialize(url, poll: false)
        @url = url
        @tracers = {}
        @poll = poll
        @fetcher = SliceFetcher.new(url)
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
            # TODO fix polling with threads
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
        @fetcher.finish
        @send_thread&.join
      end

      private

        def fetch_slice
          @fetcher.slice
        end

        def fetch_scene(slice)
          response = HTTP.get(URI.join(@url, 'images/', "#{slice['image_id']}.json"))
          raise "ERROR #{response.status} fetching scene" unless response.status == 200

          JSON.parse(response.to_s)
        end

        def create_tracer(slice)
          @tracers[slice['image_id']] ||= begin
            scene = fetch_scene(slice)
            Impl::Tracer.new(Impl::Scene.parse(scene['data']),
              width: scene['width'],
              height: scene['height'],
              samples_per_pixel: scene['samples'],
              max_depth: scene['depth']
            )
          end
        end

        def send_slice(slice, row)
          @send_thread = Thread.new { HTTP.patch(URI.join(@url, 'slices/', "#{slice['id']}.json"), json: { slice: { data: row } }) }
        end
    end
  end
end
