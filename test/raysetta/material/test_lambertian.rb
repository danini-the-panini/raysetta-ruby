# frozen_string_literal: true

require "test_helper"

class TestLambertian < Minitest::Test
  def test_solid
    assert_equal Raysetta::Material::Lambertian.new(
      Raysetta::Texture::SolidColor.new(rgb(0.1, 0.2, 0.3))
    ), Raysetta::Material::Lambertian.solid(rgb(0.1, 0.2, 0.3))
  end

  def test_scatter
    mat = Raysetta::Material::Lambertian.solid(rgb(0.1, 0.2, 0.3))
    r = ray([0.0, 0.0, 0.0], [0.0, 1.0, 0.0], 0.75)

    hit = Raysetta::Hit.new(
      point: vec3(0.0, 10.0, 0.0),
      r: r,
      normal: vec3(0.0, -1.0, 0.0),
      t: 10.0,
      material: mat,
      uv: vec2(0.5, 0.0)
    )

    scatter = mat.scatter(r, hit)

    assert_equal rgb(0.1, 0.2, 0.3), scatter.attenuation
    assert_equal vec3(0.0, 10.0, 0.0), scatter.ray.origin
    refute_equal r.direction, scatter.ray.direction
    refute scatter.ray.direction.zero?
    assert_equal 0.75, scatter.ray.time
  end

  def test_export
    assert_equal({
      type: "Lambertian",
      texture: "some-texture"
    }, Raysetta::Material::Lambertian.new(OpenStruct.new(id: "some-texture")).export)
  end
end
