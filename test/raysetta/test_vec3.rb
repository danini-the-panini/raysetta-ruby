# frozen_string_literal: true

require "test_helper"

class TestVec3 < Minitest::Test
  def test_new
    assert_equal Raysetta::Vec3.new(0.0, 0.0, 0.0), Raysetta::Vec3.new
    assert_equal Raysetta::Vec3.new(2.7, 2.7, 2.7), Raysetta::Vec3.new(2.7)
  end

  def test_unary_minus
    assert_equal Raysetta::Vec3.new(-1.0, -2.0, -3.0), -Raysetta::Vec3.new(1.0, 2.0, 3.0)
  end

  def test_aref
    v = Raysetta::Vec3.new(1.0, 2.0, 3.0)
    assert_equal 1.0, v[0]
    assert_equal 2.0, v[1]
    assert_equal 3.0, v[2]
  end

  def test_aset
    v = Raysetta::Vec3.new(99.0)
    v[0] = 1.0
    v[1] = 2.0
    v[2] = 3.0
    assert_equal Raysetta::Vec3.new(1.0, 2.0, 3.0), v
  end

  def test_getters
    v = Raysetta::Vec3.new(1.0, 2.0, 3.0)
    assert_equal 1.0, v.x
    assert_equal 2.0, v.y
    assert_equal 3.0, v.z
  end

  def test_setters
    v = Raysetta::Vec3.new(99.0)
    v.x = 1.0
    v.y = 2.0
    v.z = 3.0
    assert_equal Raysetta::Vec3.new(1.0, 2.0, 3.0), v
  end

  def test_plus
    u = Raysetta::Vec3.new(1.0, 2.0, 3.0)
    v = Raysetta::Vec3.new(4.0, 5.0, 6.0)
    assert_equal Raysetta::Vec3.new(5.0, 7.0, 9.0), u + v
  end

  def test_minus
    u = Raysetta::Vec3.new(1.0, 2.0, 3.0)
    v = Raysetta::Vec3.new(6.0, 5.0, 4.0)
    assert_equal Raysetta::Vec3.new(-5.0, -3.0, -1.0), u - v
  end

  def test_times
    v = Raysetta::Vec3.new(1.0, 2.0, 3.0)
    assert_equal Raysetta::Vec3.new(2.0, 4.0, 6.0), v * 2.0
  end

  def test_divide
    v = Raysetta::Vec3.new(1.0, 2.0, 3.0)
    assert_equal Raysetta::Vec3.new(0.5, 1.0, 1.5), v / 2.0
  end

  def test_add
    v = Raysetta::Vec3.new(1.0, 2.0, 3.0)
    v.add(Raysetta::Vec3.new(4.0, 5.0, 6.0))
    assert_equal Raysetta::Vec3.new(5.0, 7.0, 9.0), v
  end

  def test_sub
    v = Raysetta::Vec3.new(1.0, 2.0, 3.0)
    v.sub(Raysetta::Vec3.new(6.0, 5.0, 4.0))
    assert_equal Raysetta::Vec3.new(-5.0, -3.0, -1.0), v
  end

  def test_mul
    v = Raysetta::Vec3.new(1.0, 2.0, 3.0)
    v.mul(2.0)
    assert_equal Raysetta::Vec3.new(2.0, 4.0, 6.0), v
  end

  def test_multiply
    c = Raysetta::Vec3.new(0.1, 0.2, 0.3)
    c.multiply(Raysetta::Vec3.new(0.9, 0.8, 0.7))
    assert_equal Raysetta::Vec3.new(0.09, 0.16, 0.21), c
  end

  def test_div
    v = Raysetta::Vec3.new(1.0, 2.0, 3.0)
    v.div(2.0)
    assert_equal Raysetta::Vec3.new(0.5, 1.0, 1.5), v
  end

  def test_negate
    v = Raysetta::Vec3.new(1.0, 2.0, 3.0)
    v.neg
    assert_equal Raysetta::Vec3.new(-1.0, -2.0, -3.0), v
  end

  def test_length
    v = Raysetta::Vec3.new(1.0, 2.0, 3.0)
    assert_in_delta 3.741657387, v.length, Raysetta::Util::EPSILON
  end

  def test_length_squared
    v = Raysetta::Vec3.new(1.0, 2.0, 3.0)
    assert_equal 14.0, v.length_squared
  end

  def test_dot
    u = Raysetta::Vec3.new(1.0, 2.0, 3.0)
    v = Raysetta::Vec3.new(4.0, 5.0, 6.0)
    assert_equal 32.0, u.dot(v)
  end

  def test_unit
    v = Raysetta::Vec3.new(1.0, 2.0, 3.0)
    assert_equal Raysetta::Vec3.new(0.267261242, 0.534522484, 0.801783726), v.unit
  end

  def test_normalize
    v = Raysetta::Vec3.new(1.0, 2.0, 3.0)
    v.normalize
    assert_equal Raysetta::Vec3.new(0.267261242, 0.534522484, 0.801783726), v
  end

  def test_dup
    v = Raysetta::Vec3.new(1.0, 2.0, 3.0)
    v2 = v.dup
    assert_equal v, v2
    refute v.equal?(v2)
  end

  def test_smoothstep
    v = Raysetta::Vec3.new(1.0, 2.0, 3.0)
    assert_equal Raysetta::Vec3.new(1.0, -4.0, -27.0), v.smoothstep
  end

  def test_smoothstep_bang
    v = Raysetta::Vec3.new(1.0, 2.0, 3.0)
    v.smoothstep!
    assert_equal Raysetta::Vec3.new(1.0, -4.0, -27.0), v
  end

  def test_to_pixel
    c = Raysetta::Vec3.new(0.1, 0.2, 0.3)

    assert_equal [80, 114, 140], c.to_pixel
  end

  def test_zero
    u = Raysetta::Vec3.new(1.0, 2.0, 3.0)
    v = Raysetta::Vec3.new(1e-9, 1e-9, -1e-9)
    refute u.zero?
    assert v.zero?
  end

  def test_equal
    u = Raysetta::Vec3.new(1.0, 2.0, 3.0)
    v = Raysetta::Vec3.new(1.000000001, 2.0, 3.0)
    assert_equal u, v
  end

  def test_hash
    v = Raysetta::Vec3.new(1.0, 2.0, 3.0)
    assert_equal [1.0, 2.0, 3.0].hash, v.hash
  end

  def test_random
    v = Raysetta::Vec3.random(-10.0, 10.0)
    assert(-10.0 < v.x && v.x < 10.0)
    assert(-10.0 < v.y && v.y < 10.0)
    assert(-10.0 < v.z && v.z < 10.0)
  end

  def test_reflect
    v = Raysetta::Vec3.new(1.0, 2.0, 3.0)
    n = Raysetta::Vec3.new(0.0, 1.0, 0.0)
    assert_equal Raysetta::Vec3.new(1.0, -2.0, 3.0), v.reflect(n)
  end

  def test_refract
    v = Raysetta::Vec3.new(1.0, 2.0, 3.0)
    n = Raysetta::Vec3.new(0.0, 1.0, 0.0)
    assert_equal Raysetta::Vec3.new(1.5, -4.636809247747852, 4.5), v.refract(n, 1.5)
  end

  def test_random_in_unit_sphere
    v = Raysetta::Vec3.random_in_unit_sphere
    assert v.length < 1.0
  end

  def test_random_unit_vector
    v = Raysetta::Vec3.random_unit
    assert_in_delta 1.0, v.length, Raysetta::Util::EPSILON
  end

  def test_random_on_hemisphere
    n = Raysetta::Vec3.new(0.0, 1.0, 0.0)
    v = Raysetta::Vec3.random_on_hemisphere(n)

    assert_in_delta 1.0, v.length, Raysetta::Util::EPSILON
    assert v.y.positive?
  end

  def test_random_in_unit_disk
    v = Raysetta::Vec3.random_in_unit_disk
    assert v.z.zero?
    assert(-1.0 < v.x && v.x < 1.0)
    assert(-1.0 < v.y && v.y < 1.0)
  end
end
