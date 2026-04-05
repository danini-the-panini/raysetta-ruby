# frozen_string_literal: true

require "test_helper"

class TestAABB < Minitest::Test
  def test_from_points
    assert_equal Raysetta::AABB.new(int(-4.0, 1.0), int(-2.0, 5.0), int(-6.0, 3.0)),
    Raysetta::AABB.from_points(vec3(1.0, -2.0, 3.0), vec3(-4.0, 5.0, -6.0))
  end

  def test_from_aabbs
    assert_equal Raysetta::AABB.new(int(-1.0, 3.0), int(-3.0, 4.0), int(-6.0, 7.0)),
    Raysetta::AABB.from_aabbs(
      Raysetta::AABB.new(int(-1.0, 2.0), int(-3.0, 4.0), int(-5.0, 6.0)),
      Raysetta::AABB.new(int(2.0, 3.0), int(3.0, 4.0), int(-6.0, 7.0))
    )
  end

  def test_aref
    box = Raysetta::AABB.new(int(1.0, 2.0), int(3.0, 4.0), int(5.0, 6.0))
    assert_equal int(1.0, 2.0), box[0]
    assert_equal int(3.0, 4.0), box[1]
    assert_equal int(5.0, 6.0), box[2]
  end

  def test_aset
    box = Raysetta::AABB.new(int(0.0, 99.0), int(0.0, 99.0), int(0.0, 99.0))
    box[0] = int(1.0, 2.0)
    box[1] = int(3.0, 4.0)
    box[2] = int(5.0, 6.0)
    assert_equal Raysetta::AABB.new(int(1.0, 2.0), int(3.0, 4.0), int(5.0, 6.0)), box
  end

  def test_hit
    box = Raysetta::AABB.new(int(1.0, 2.0), int(3.0, 4.0), int(5.0, 6.0))

    assert box.hit(Raysetta::Ray.new(vec3(0.0, 0.0, 0.0), Raysetta::Vec3.new(1.5, 3.5, 5.5)), int(0.001, 1000.0))
    refute box.hit(Raysetta::Ray.new(vec3(0.0, 0.0, 0.0), Raysetta::Vec3.new(1.5, 3.5, 5.5)), int(20.0, 1000.0))
    refute box.hit(Raysetta::Ray.new(vec3(0.0, 0.0, 0.0), Raysetta::Vec3.new(1.0, -1.0, 1.0)), int(0.001, 1000.0))
  end

  def test_longest_axis
    assert_equal 0, Raysetta::AABB.new(int(0.0, 10.0), int(0.0, 1.0), int(0.0, 1.0)).longest_axis
    assert_equal 1, Raysetta::AABB.new(int(0.0, 1.0), int(0.0, 10.0), int(0.0, 1.0)).longest_axis
    assert_equal 2, Raysetta::AABB.new(int(0.0, 1.0), int(0.0, 1.0), int(0.0, 10.0)).longest_axis
  end

  def test_dup
    box = Raysetta::AABB.new(int(1.0, 2.0), int(3.0, 4.0), int(5.0, 6.0))
    box2 = box.dup
    assert_equal box, box2
    refute box.equal?(box2)
    refute box.x.equal?(box2.x)
    refute box.y.equal?(box2.y)
    refute box.z.equal?(box2.z)
  end
end
