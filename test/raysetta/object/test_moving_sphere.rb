# frozen_string_literal: true

require "test_helper"

class TestMovingSphere < Minitest::Test
  def sphere
    @sphere ||= Raysetta::Object::MovingSphere.new(
      vec3(0.0, 0.0, 0.0),
      vec3(5.0, 5.0, 5.0),
      1.0,
      OpenStruct.new(id: "1234")
    )
  end

  def test_hit
    hit = sphere.hit(
      ray([5.0, 0.0, 5.0], [0.0, 1.0, 0.0], 1.0),
      0.001..1000.0
    )
    refute_nil hit
    assert_equal vec3(5.0, 4.0, 5.0), hit.point
    assert_equal vec3(0.0, -1.0, 0.0), hit.normal
    assert_equal 4.0, hit.t
    assert_equal sphere.material, hit.material
    assert_equal vec2(0.5, 0.0), hit.uv
    assert hit.front_face?

    hit = sphere.hit(
      ray([5.0, 0.0, 5.0], [0.0, 1.0, 0.0], 0.0),
      0.001..1000.0
    )
    assert_nil hit
  end

  def test_bounding_box
    assert_equal(aabb([-1.0, -1.0, -1.0], [6.0, 6.0, 6.0]), sphere.bounding_box)
  end

  def test_export
    assert_equal({
      type: "MovingSphere",
      center1: [0.0, 0.0, 0.0],
      center2: [5.0, 5.0, 5.0],
      radius: 1.0,
      material: "1234"
    }, sphere.export)
  end
end
