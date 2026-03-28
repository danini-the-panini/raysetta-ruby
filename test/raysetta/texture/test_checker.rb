# frozen_string_literal: true

require "test_helper"

class TestCheckerTexture < Minitest::Test
  def test_solid
    assert_equal Raysetta::Texture::Checker.new(
      0.5,
      Raysetta::Texture::SolidColor.new(rgb(0.1, 0.2, 0.3)),
      Raysetta::Texture::SolidColor.new(rgb(0.4, 0.5, 0.6))
    ),
    Raysetta::Texture::Checker.solid(
      0.5,
      rgb(0.1, 0.2, 0.3),
      rgb(0.4, 0.5, 0.6)
    )
  end

  def test_sample
    tex = Raysetta::Texture::Checker.new(
      1.0,
      Raysetta::Texture::SolidColor.new(rgb(0.1, 0.2, 0.3)),
      Raysetta::Texture::SolidColor.new(rgb(0.4, 0.5, 0.6))
    )

    assert_equal(rgb(0.1, 0.2, 0.3), tex.sample(nil, point3(0.5, 0.5, 0.5)))
    assert_equal(rgb(0.4, 0.5, 0.6), tex.sample(nil, point3(1.5, 1.5, 1.5)))
  end

  def test_export
    tex = Raysetta::Texture::Checker.new(
      0.75,
      Raysetta::Texture::SolidColor.new(rgb(0.1, 0.2, 0.3)),
      Raysetta::Texture::SolidColor.new(rgb(0.4, 0.5, 0.6))
    )
    assert_equal({
      type: "Checker",
      scale: 0.75,
      even: {
        type: "SolidColor",
        albedo: [0.1, 0.2, 0.3]
      },
      odd: {
        type: "SolidColor",
        albedo: [0.4, 0.5, 0.6]
      }
    }, tex.export)
  end
end
