# frozen_string_literal: true

require "test_helper"

class TestHit < Minitest::Test
  def test_initialize
    point = point3(1.0, 1.0, 1.0)
    r = ray([0.0, 0.0, 0.0], [0.5, 0.5, 0.5])

    norm1 = vec3(-0.4, -0.5, -0.6)
    hit1 = Raysetta::Hit.new(point:, r:, normal: norm1, t: 2.0, material: nil)
    assert hit1.front_face?
    assert_equal norm1, hit1.normal

    norm2 = vec3(0.6, 0.5, 0.4)
    hit2 = Raysetta::Hit.new(point:, r:, normal: norm2, t: 2.0, material: nil)
    refute hit2.front_face?
    assert_equal(-norm2, hit2.normal)
  end
end
