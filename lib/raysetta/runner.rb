# frozen_string_literal: true

require "etc"

require_relative "runner/base"
require_relative "runner/concurrent"
require_relative "runner/sync"
require_relative "runner/threads"
require_relative "runner/ractors"
require_relative "runner/processes"
require_relative "output/base"
require_relative "output/ppm"
require_relative "output/png"

module Raysetta
  module Runner
    def self.parse_scene(input_path, output_path: nil, runner: :sync, format: :ppm, concurrency: Etc.nprocessors, **options)
      scene = Raysetta::Scene.parse(JSON.parse(File.read(input_path)))

      tracer = Raysetta::Tracer.new(scene, **options)
      runner = case runner
      when :sync then Raysetta::Runner::Sync.new(tracer)
      when :threads then Raysetta::Runner::Threads.new(tracer, count: concurrency)
      when :ractors then Raysetta::Runner::Ractors.new(tracer, count: concurrency)
      when :processes then Raysetta::Runner::Processes.new(tracer, count: concurrency)
      else
        warn "*** Unknown runner #{runner} ***"
        exit
      end
      runner.call
      out = case format
      when :ppm then Raysetta::Output::PPM.new(runner.output, width: tracer.width, height: tracer.height)
      when :png then Raysetta::Output::PNG.new(runner.output, width: tracer.width, height: tracer.height)
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
  end
end
