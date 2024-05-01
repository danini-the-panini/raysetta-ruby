# frozen_string_literal: true

require_relative "lib/rray/runner/version"

Gem::Specification.new do |spec|
  spec.name = "rray-runner"
  spec.version = Rray::Runner::VERSION
  spec.authors = ["Danielle Smith"]
  spec.email = ["danielle.smith@platform45.com"]

  spec.summary = "Runners for Rray"
  spec.description = "Allows running Rray locally as a CLI"
  spec.homepage = "https://github.com/danini-the-panini/rray-runner"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/danini-the-panini/rray-runner"
  spec.metadata["changelog_uri"] = "https://github.com/danini-the-panini/rray-runner/releases"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rray", "~> 0.2"
  spec.add_dependency "progress", "~> 3.6"
  spec.add_dependency "chunky_png", "~> 1.4"
  spec.add_dependency "parallel", "~> 1.24"
  spec.add_dependency "http", "~> 5.2"
end
