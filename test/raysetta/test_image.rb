# frozen_string_literal: true

require "test_helper"

class TestImage < Minitest::Test
  def image
    @image ||= Raysetta::Image.new(path: 'test/fixtures/test.png')
  end

  def test_initialize_error
    assert_raises ArgumentError do
      Raysetta::Image.new
    end
  end

  def test_path
    image = Raysetta::Image.new(path: 'test/fixtures/test.png')
    assert_kind_of ChunkyPNG::Image, image.image
  end

  def test_data_url
    data_url = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfF"+
    "cSJAAAAAXNSR0IArs4c6QAAAERlWElmTU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAA6ABAAM"+
    "AAAABAAEAAKACAAQAAAABAAAAAaADAAQAAAABAAAAAQAAAAD5Ip3+AAAADUlEQVQIHWP4z/D/P"+
    "wAG/gL+TePW1QAAAABJRU5ErkJggg=="
    data_image = Raysetta::Image.new(data_url:)
    assert_kind_of ChunkyPNG::Image, data_image.image
  end

  def test_width
    assert_equal 3, image.width
  end

  def test_height
    assert_equal 2, image.height
  end

  def test_aref
    assert_equal rgb(1.0, 0.0, 0.0), image[0, 0]
    assert_equal rgb(0.0, 1.0, 0.0), image[1, 0]
    assert_equal rgb(1.0, 0.0, 1.0), image[2, 0]
    assert_equal rgb(0.0, 0.0, 1.0), image[0, 1]
    assert_equal rgb(1.0, 1.0, 0.0), image[1, 1]
    assert_equal rgb(0.0, 1.0, 1.0), image[2, 1]
  end

  def test_export
    assert_equal({
      type: "Image",
      data: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAMAAAACBAMAAABvWnsp"+
      "AAAAGXRFWHRDb21tZW50AENyZWF0ZWQgd2l0aCBHSU1QV4EOFwAAABJQTFRFAAD/AP8AAP//"+
      "/wAA/wD///8Ad5zkcwAAAA5JREFUeJxjMnRguvIAAASVAip9IttgAAAAAElFTkSuQmCC"
    }, image.export)
  end
end
