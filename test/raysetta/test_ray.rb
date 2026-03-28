# frozen_string_literal: true

require "test_helper"

class TestRay < Minitest::Test
  def test_at
    r = Raysetta::Ray.new(point3(1.0, 2.0, 3.0), vec3(4.0, 5.0, 6.0))
    assert_equal r.origin, r.at(0.0)
    assert_equal point3(5.0, 7.0, 9.0), r.at(1.0)
    assert_equal point3(7.0, 9.5, 12.0), r.at(1.5)
  end

  def test_dup
    r = Raysetta::Ray.new(point3(1.0, 2.0, 3.0), vec3(4.0, 5.0, 6.0))
    r2 = r.dup
    assert_equal r, r2
    refute r.equal?(r2)
    refute r.origin.equal?(r2.origin)
    refute r.direction.equal?(r2.direction)
  end
end
