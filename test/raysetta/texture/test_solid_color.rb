# frozen_string_literal: true

require "test_helper"

class TestSolidColor < Minitest::Test
  def test_rgb
    assert_equal Raysetta::Texture::SolidColor.new(rgb(0.1, 0.2, 0.3)),
      Raysetta::Texture::SolidColor.rgb(0.1, 0.2, 0.3)
  end

  def test_sample
    tex = Raysetta::Texture::SolidColor.new(rgb(0.1, 0.2, 0.3))
    assert_equal(rgb(0.1, 0.2, 0.3), tex.sample(nil, nil))
  end

  def test_export
    assert_equal({
      type: "SolidColor",
      albedo: [0.1, 0.2, 0.3]
    }, Raysetta::Texture::SolidColor.new(rgb(0.1, 0.2, 0.3)).export)
  end
end
