# frozen_string_literal: true

require "test_helper"

class TestSphere < Minitest::Test
  def sphere
    @sphere ||= Raysetta::Object::Sphere.new(
      vec3(5.0, 5.0, 5.0),
      1.0,
      OpenStruct.new(id: "1234")
    )
  end

  def test_hit
    hit = sphere.hit(
      ray([5.0, 0.0, 5.0], [0.0, 1.0, 0.0]),
      0.001..1000.0
    )
    refute_nil hit
    assert_equal vec3(5.0, 4.0, 5.0), hit.point
    assert_equal vec3(0.0, -1.0, 0.0), hit.normal
    assert_equal 4.0, hit.t
    assert_equal sphere.material, hit.material
    assert_equal vec2(0.5, 0.0), hit.uv
    assert hit.front_face?

    # from inside
    hit = sphere.hit(
      ray([5.0, 5.0, 5.0], [0.0, 1.0, 0.0]),
      0.001..1000.0
    )
    refute_nil hit
    assert_equal vec3(5.0, 6.0, 5.0), hit.point
    assert_equal vec3(0.0, -1.0, 0.0), hit.normal
    assert_equal 1.0, hit.t
    assert_equal sphere.material, hit.material
    assert_equal vec2(0.5, 1.0), hit.uv
    refute hit.front_face?

    # half in range
    hit = sphere.hit(
      ray([5.0, 0.0, 5.0], [0.0, 1.0, 0.0]),
      5.0..1000.0
    )
    refute_nil hit
    assert_equal vec3(5.0, 6.0, 5.0), hit.point
    assert_equal vec3(0.0, -1.0, 0.0), hit.normal
    assert_equal 6.0, hit.t
    assert_equal sphere.material, hit.material
    assert_equal vec2(0.5, 1.0), hit.uv
    refute hit.front_face?

    # out of range
    hit = sphere.hit(
      ray([5.0, 0.0, 5.0], [0.0, 1.0, 0.0]),
      10.0..1000.0
    )
    assert_nil hit
  end

  def test_bounding_box
    assert_equal(aabb([4.0, 4.0, 4.0], [6.0, 6.0, 6.0]), sphere.bounding_box)
  end

  def test_export
    assert_equal({
      type: "Sphere",
      center: [5.0, 5.0, 5.0],
      radius: 1.0,
      material: "1234"
    }, sphere.export)
  end
end
