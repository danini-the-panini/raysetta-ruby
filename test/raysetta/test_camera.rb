# frozen_string_literal: true

require "test_helper"

class TestCamera < Minitest::Test
  def camera
    @camera ||= Raysetta::Camera.new.tap { _1.viewport(100, 100) }
  end

  def test_ray
    ray = camera.ray(50, 50)
    assert_equal camera.lookfrom, ray.origin
  end

  def test_export
    assert_equal({
      vfov: 90.0,
      lookfrom: [0.0, 0.0, 0.0],
      lookat: [0.0, 0.0, -1.0],
      vup: [0.0, 1.0, 0.0],
      defocus_angle: 0.0,
      focus_dist: 10.0
    }, camera.export)
  end
end
