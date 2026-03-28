# frozen_string_literal: true

require "test_helper"

class TestColor < Minitest::Test
  def test_getters
    c = Raysetta::Color.new(0.1, 0.2, 0.3)
    assert_equal 0.1, c.r
    assert_equal 0.2, c.g
    assert_equal 0.3, c.b
  end

  def test_setters
    c = Raysetta::Color.repeat(0.99)
    c.r = 0.1
    c.g = 0.2
    c.b = 0.3
    assert_equal Raysetta::Color.new(0.1, 0.2, 0.3), c
  end

  def test_multiply
    c = Raysetta::Color.new(0.1, 0.2, 0.3)
    c.multiply(Raysetta::Color.new(0.9, 0.8, 0.7))
    assert_equal Raysetta::Color.new(0.09, 0.16, 0.21), c
  end

  def test_to_pixel
    c = Raysetta::Color.new(0.1, 0.2, 0.3)

    assert_equal [80, 114, 140], c.to_pixel
  end
end
