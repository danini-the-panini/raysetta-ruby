# frozen_string_literal: true

require "test_helper"
require "ostruct"

class TestMetal < Minitest::Test
  def test_solid
    assert_equal Raysetta::Material::Metal.new(
      Raysetta::Texture::SolidColor.new(rgb(0.1, 0.2, 0.3)),
      0.75
    ), Raysetta::Material::Metal.solid(rgb(0.1, 0.2, 0.3), 0.75)
  end

  def test_scatter
    mat = Raysetta::Material::Metal.solid(rgb(0.1, 0.2, 0.3), 0.0)
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

    assert_equal rgb(0.1, 0.2, 0.3), scatter.attenuation
    assert_equal point3(1.0, 1.0, 0.0), scatter.ray.origin
    assert_equal vec3(-0.8, -0.6, 0.0), scatter.ray.direction
    assert_equal 0.75, scatter.ray.time
  end

  def test_export
    assert_equal({
      type: "Metal",
      texture: "some-texture",
      fuzz: 0.75
    }, Raysetta::Material::Metal.new(OpenStruct.new(id: "some-texture"), 0.75).export)
  end
end
