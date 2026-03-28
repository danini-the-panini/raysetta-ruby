# Raysetta Ruby

A raytracer written in Ruby. Part of the Raysetta project. Based on [Ray Tracing in One Weekend](https://raytracing.github.io/).

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add raysetta

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install raysetta

## Usage

### CLI

```
$ raysetta scene.json --width 800 --height 600 --samples 50 --depth 100 --format ppm -o output.ppm
```

### Gem

#### Raytracer

```ruby
require "raysetta"

scene = Raysetta::Scene.parse(File.read("scene.json"))
tracer = Raysetta::Tracer.new(scene, width: 800, height: 600, samples_per_pixel: 50, max_depth: 100)

output = Array.new(tracer.height) { Array.new(tracer.width) { [0, 0, 0] } }
output.each.with_index do |row, i|
  row.each.with_index do |pixel, j|
    r, g, b = tracer.call(j, i)

    pixel[0] = r
    pixel[1] = g
    pixel[2] = b
  end
end

# store output as an image
```

#### Runner

```ruby
require "raysetta/runner"

scene = Raysetta::Scene.parse(File.read("scene.json"))
tracer = Raysetta::Tracer.new(scene, width: 800, height: 600, samples_per_pixel: 50, max_depth: 100)
runner = Raysetta::Runner::Sync.new(tracer)
runner.call
out = Raysetta::Output::PPM.new(runner.output, width: tracer.width, height: tracer.height)
out.save("output.ppm")
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/danini-the-panini/raysetta-ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
