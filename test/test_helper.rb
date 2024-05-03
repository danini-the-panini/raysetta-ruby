# frozen_string_literal: true

$impl = :ruby

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "rray/runner"

require "minitest/autorun"
