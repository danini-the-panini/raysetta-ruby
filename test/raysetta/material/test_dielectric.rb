# frozen_string_literal: true

require "test_helper"

class TestDielectric < Minitest::Test
  def test_scatter
    mat = Raysetta::Material::Dielectric.new(1.5)
    r = ray([0.0, 0.0, 0.0], [0.0, 1.0, 0.0], 0.75)

    hit = Raysetta::Hit.new(
      point: point3(1.0, 1.0, 0.0),
      r:,
      normal: vec3(-Math.sqrt(2.0), -Math.sqrt(2.0), 0.0),
      t: 10.0,
      material: mat,
      uv: vec2(0.5, 0.0)
    )

    scatter = mat.scatter(r, hit)

    assert_equal rgb(1.0, 1.0, 1.0), scatter.attenuation
    assert_equal point3(1.0, 1.0, 0.0), scatter.ray.origin
    refute scatter.ray.direction.zero?
    assert_equal 0.75, scatter.ray.time
  end

  def test_export
    assert_equal({
      type: "Dielectric",
      refraction_index: 1.5,
    }, Raysetta::Material::Dielectric.new(1.5).export)
  end
end
