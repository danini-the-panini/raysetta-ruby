# frozen_string_literal: true

require "test_helper"

class TestVec2 < Minitest::Test
  def test_dimensions
    assert_equal 2, Raysetta::Vec2.dimensions
  end

  def test_repeat
    assert_equal Raysetta::Vec2.new(2.7, 2.7), Raysetta::Vec2.repeat(2.7)
  end

  def test_unary_minus
    assert_equal Raysetta::Vec2.new(-1.0, -2.0), -Raysetta::Vec2.new(1.0, 2.0)
  end

  def test_aref
    v = Raysetta::Vec2.new(1.0, 2.0)
    assert_equal 1.0, v[0]
    assert_equal 2.0, v[1]
  end

  def test_aset
    v = Raysetta::Vec2.repeat(99.0)
    v[0] = 1.0
    v[1] = 2.0
    assert_equal Raysetta::Vec2.new(1.0, 2.0), v
  end

  def test_getters
    v = Raysetta::Vec2.new(1.0, 2.0)
    assert_equal 1.0, v.x
    assert_equal 2.0, v.y
    assert_equal 1.0, v.u
    assert_equal 2.0, v.v
  end

  def test_setters
    v = Raysetta::Vec2.repeat(99.0)
    v.x = 1.0
    v.y = 2.0
    assert_equal Raysetta::Vec2.new(1.0, 2.0), v
    v.u = 3.0
    v.v = 4.0
    assert_equal Raysetta::Vec2.new(3.0, 4.0), v
  end

  def test_plus
    u = Raysetta::Vec2.new(1.0, 2.0)
    v = Raysetta::Vec2.new(4.0, 5.0)
    assert_equal Raysetta::Vec2.new(5.0, 7.0), u + v
  end

  def test_minus
    u = Raysetta::Vec2.new(1.0, 2.0)
    v = Raysetta::Vec2.new(6.0, 5.0)
    assert_equal Raysetta::Vec2.new(-5.0, -3.0), u - v
  end

  def test_times
    v = Raysetta::Vec2.new(1.0, 2.0)
    assert_equal Raysetta::Vec2.new(2.0, 4.0), v * 2.0
  end

  def test_divide
    v = Raysetta::Vec2.new(1.0, 2.0)
    assert_equal Raysetta::Vec2.new(0.5, 1.0), v / 2.0
  end

  def test_add
    v = Raysetta::Vec2.new(1.0, 2.0)
    v.add(Raysetta::Vec2.new(4.0, 5.0))
    assert_equal Raysetta::Vec2.new(5.0, 7.0), v
  end

  def test_sub
    v = Raysetta::Vec2.new(1.0, 2.0)
    v.sub(Raysetta::Vec2.new(6.0, 5.0))
    assert_equal Raysetta::Vec2.new(-5.0, -3.0), v
  end

  def test_mul
    v = Raysetta::Vec2.new(1.0, 2.0)
    v.mul(2.0)
    assert_equal Raysetta::Vec2.new(2.0, 4.0), v
  end

  def test_div
    v = Raysetta::Vec2.new(1.0, 2.0)
    v.div(2.0)
    assert_equal Raysetta::Vec2.new(0.5, 1.0), v
  end

  def test_negate
    v = Raysetta::Vec2.new(1.0, 2.0)
    v.neg
    assert_equal Raysetta::Vec2.new(-1.0, -2.0), v
  end

  def test_length
    v = Raysetta::Vec2.new(1.0, 2.0)
    assert_in_delta 2.236067977, v.length, Raysetta::Vec2::EPSILON
  end

  def test_length_squared
    v = Raysetta::Vec2.new(1.0, 2.0)
    assert_equal 5.0, v.length_squared
  end

  def test_dot
    u = Raysetta::Vec2.new(1.0, 2.0)
    v = Raysetta::Vec2.new(4.0, 5.0)
    assert_equal 14.0, u.dot(v)
  end

  def test_unit
    v = Raysetta::Vec2.new(1.0, 2.0)
    assert_equal Raysetta::Vec2.new(0.447213596, 0.894427191), v.unit
  end

  def test_normalize
    v = Raysetta::Vec2.new(1.0, 2.0)
    v.normalize
    assert_equal Raysetta::Vec2.new(0.447213596, 0.894427191), v
  end

  def test_dup
    v = Raysetta::Vec2.new(1.0, 2.0)
    v2 = v.dup
    assert_equal v, v2
    refute v.equal?(v2)
  end

  def test_floor
    v = Raysetta::Vec2.new(1.2, 2.3)
    assert_equal Raysetta::Vec2.new(1.0, 2.0), v.floor
  end

  def test_floor_bang
    v = Raysetta::Vec2.new(1.2, 2.3)
    v.floor!
    assert_equal Raysetta::Vec2.new(1.0, 2.0), v
  end

  def test_smoothstep
    v = Raysetta::Vec2.new(1.0, 2.0)
    assert_equal Raysetta::Vec2.new(1.0, -4.0), v.smoothstep
  end

  def test_smoothstep_bang
    v = Raysetta::Vec2.new(1.0, 2.0)
    v.smoothstep!
    assert_equal Raysetta::Vec2.new(1.0, -4.0), v
  end

  def test_zero
    u = Raysetta::Vec2.new(1.0, 2.0)
    v = Raysetta::Vec2.new(1e-9, -1e-9)
    refute u.zero?
    assert v.zero?
  end

  def test_equal
    u = Raysetta::Vec2.new(1.0, 2.0)
    v = Raysetta::Vec2.new(1.000000001, 2.0)
    assert_equal u, v
  end

  def test_hash
    v = Raysetta::Vec2.new(1.0, 2.0)
    assert_equal [1.0, 2.0].hash, v.hash
  end

  def test_random
    v = Raysetta::Vec2.random(-10.0, 10.0)
    assert(-10.0 < v.x && v.x < 10.0)
    assert(-10.0 < v.y && v.y < 10.0)
  end
end
