require 'optparse'
require 'etc'

format_opt = :ppm
runner_opt = :sync
concurrency_opt = nil
output_path = nil
options = {}
opts_parser = OptionParser.new do |opts|
  opts.banner = "Usage: raysetta FILE [options]"

  opts.on("-w", "--width WIDTH", Integer, "Image width (default 256)") do |w|
    options[:width] = w
  end
  opts.on("-h", "--height HEIGHT", Integer, "Image height (default 256)") do |h|
    options[:height] = h
  end
  opts.on("-s", "--samples SAMPLES", Integer, "Samples per pixel (default 10)") do |s|
    options[:samples_per_pixel] = s
  end
  opts.on("-d", "--depth DEPTH", Integer, "Max depth (default 10)") do |d|
    options[:max_depth] = d
  end

  opts.on("-f", "--format FORMAT", %i[ppm png], "Output format (ppm, png; default ppm)") do |f|
    format_opt = f
  end
  opts.on("-r", "--runner RUNNER", %i[sync threads ractors processes], "Runner (sync, threads, ractors, processes; default sync)") do |r|
    runner_opt = r
  end
  opts.on("-c", "--concurrency CONCURRENCY", Integer, "Concurrency (threads and ractor only; default 4)") do |c|
    concurrency_opt = c
  end
  opts.on("-o", "--output FILE", "Output file (default STDOUT)") do |o|
    output_path = o
  end

  opts.on_tail("--help", "Show this message") do
    puts opts
    exit
  end

  opts.on_tail("-v", "--version", "Show version") do
    puts Raysetta::VERSION
    exit
  end
end
opts_parser.parse!

require "raysetta"
require "raysetta/runner"

if ARGV.size < 1
  warn "*** Missing FILE_OR_URL argument ***"
  puts opts_parser
  exit
end

file_or_url = ARGV.first

warn "WARN: Ignoring concurrency argument" if concurrency_opt && runner_opt == :sync
concurrency = concurrency_opt || Etc.nprocessors

if output_path.nil? && format_opt == :png
  warn "*** Refusing to output PNG to STDOUT ***"
  exit
end

Raysetta::Runner.parse_scene(file_or_url,
  output_path:,
  runner: runner_opt,
  format: format_opt,
  concurrency:,
  **options
)
