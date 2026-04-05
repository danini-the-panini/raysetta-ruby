# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "raysetta"

class Minitest::Test
  def vec3(x, y, z)
    Raysetta::Vec3.new(x, y, z)
  end

  def vec2(x, y)
    Raysetta::Vec2.new(x, y)
  end

  def rgb(r, g, b)
    Raysetta::Color.new(r, g, b)
  end

  def ray(o, d, t=0.0)
    Raysetta::Ray.new(vec3(*o), vec3(*d), t)
  end

  def int(min, max)
    Raysetta::Interval.new(min, max)
  end

  def aabb(min, max)
    Raysetta::AABB.from_points(vec3(*min), vec3(*max))
  end
end

require "minitest/autorun"
