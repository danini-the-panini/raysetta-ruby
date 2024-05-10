# frozen_string_literal: true

require "etc"

require_relative "impl"

require_relative "runner/version"
require_relative "runner/base"
require_relative "runner/concurrent"
require_relative "runner/sync"
require_relative "runner/threads"
require_relative "runner/ractors"
require_relative "runner/processes"
require_relative "http_runner/base"
require_relative "http_runner/concurrent"
require_relative "http_runner/sync"
require_relative "http_runner/threads"
require_relative "http_runner/ractors"
require_relative "http_runner/processes"
require_relative "output/base"
require_relative "output/ppm"
require_relative "output/png"

module Rray
  module Runner
    def self.parse_scene(input_path, output_path: nil, runner: :sync, format: :ppm, concurrency: Etc.nprocessors, **options)
      scene = Impl::Scene.parse(JSON.parse(File.read(input_path)))

      tracer = Impl::Tracer.new(scene, **options)
      runner = case runner
      when :sync then Rray::Runner::Sync.new(tracer)
      when :threads then Rray::Runner::Threads.new(tracer, count: concurrency)
      when :ractors then Rray::Runner::Ractors.new(tracer, count: concurrency)
      when :processes then Rray::Runner::Processes.new(tracer, count: concurrency)
      else
        warn "*** Unknown runner #{runner} ***"
        exit
      end
      runner.call
      out = case format
      when :ppm then Rray::Output::PPM.new(runner.output, width: tracer.width, height: tracer.height)
      when :png then Rray::Output::PNG.new(runner.output, width: tracer.width, height: tracer.height)
      else
        warn "*** Unknown format #{format} ***"
        exit
      end
      if output_path
        out.save(output_path)
      else
        puts out.call
      end
    end

    def self.connect_to_server(url, runner: :sync, concurrency: Etc.nprocessors, poll: false)
      runner = case runner
      when :sync then Rray::HttpRunner::Sync.new(url, poll:)
      when :threads then Rray::HttpRunner::Threads.new(url, count: concurrency, poll:)
      when :ractors then Rray::HttpRunner::Ractors.new(url, count: concurrency, poll:)
      when :processes then Rray::HttpRunner::Processes.new(url, count: concurrency, poll:)
      else
        warn "*** Unknown runner #{runner} ***"
        exit
      end
      runner.call
    end
  end
end
