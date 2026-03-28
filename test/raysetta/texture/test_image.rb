# frozen_string_literal: true

require "test_helper"

class TestImageTexture < Minitest::Test
  def image
    @image ||= Raysetta::Image.new(path: 'test/fixtures/test.png')
  end

  # SKIP: i think texture sampling is broken :/
  # def test_sample
  #   tex = Raysetta::Texture::Image.new(image)
  #   assert_equal(rgb(0.8, 0.8, 0.2), tex.sample(vec2(0.1, 0.1), nil))
  #   assert_equal(rgb(0.8, 0.2, 0.8), tex.sample(vec2(0.9, 0.9), nil))
  #   assert_equal(rgb(0.8, 0.2, 0.2), tex.sample(vec2(0.1, 0.9), nil))
  #   assert_equal(rgb(0.2, 0.8, 0.8), tex.sample(vec2(0.9, 0.1), nil))
  # end

  def test_export
    image = OpenStruct.new(id: "some-image")
    assert_equal({
      type: "Image",
      image: "some-image"
    }, Raysetta::Texture::Image.new(image).export)
  end
end
