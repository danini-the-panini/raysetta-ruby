# frozen_string_literal: true

require "test_helper"

class TestBVH < Minitest::Test
  def sphere(x, y, z)
    Raysetta::Object::Sphere.new(
      vec3(x, y, z),
      1.0,
      OpenStruct.new(id: "#{x}-#{y}-#{z}")
    )
  end

  def sphere1
    @sphere1 ||= sphere(1.0, 2.0, 3.0)
  end

  def sphere2
    @sphere2 ||= sphere(6.0, 7.0, 8.0)
  end

  def sphere3
    @sphere3 ||= sphere(-2.0, -3.0, -4.0)
  end

  def bvh
    @bvh ||= Raysetta::Object::BVH.new([sphere1, sphere2, sphere3])
  end

  def assert_bvh(left, right, bvh)
    bvh_left = bvh.instance_variable_get(:@left)
    bvh_right = bvh.instance_variable_get(:@right)

    case left
    when Array then assert_bvh(*left, bvh_left)
    else assert_equal left, bvh_left
    end

    case right
    when Array then assert_bvh(*right, bvh_right)
    else assert_equal right, bvh_right
    end
  end

  def test_initialize
    assert_bvh(
      [sphere3, sphere3],
      [sphere1, sphere2],
      bvh
    )
  end

  def test_hit
    hit = bvh.hit(
      ray([1.0, 0.0, 3.0], [0.0, 1.0, 0.0]),
      0.0..1000.0
    )
    refute_nil hit
    assert_equal sphere1.material, hit.material

    hit = bvh.hit(
      ray([6.0, 0.0, 8.0], [0.0, 1.0, 0.0]),
      0.0..1000.0
    )
    refute_nil hit
    assert_equal sphere2.material, hit.material

    hit = bvh.hit(
      ray([-2.0, 0.0, -4.0], [0.0, -1.0, 0.0]),
      0.0..1000.0
    )
    refute_nil hit
    assert_equal sphere3.material, hit.material

    hit = bvh.hit(
      ray([10.0, 10.0, 10.0], [0.0, 1.0, 0.0]),
      0.0..1000.0
    )
    assert_nil hit
  end

  def test_bounding_box
    assert_equal(aabb([-3.0, -4.0, -5.0], [7.0, 8.0, 9.0]), bvh.bounding_box)
  end

  def test_export
    {
      sphere1.id => sphere1.export,
      sphere2.id => sphere2.export,
      sphere3.id => sphere3.export
    }
  end
end
