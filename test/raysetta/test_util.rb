# frozen_string_literal: true

require "test_helper"

class TestUtil < Minitest::Test
  def test_degrees_to_radians
    assert_equal 0.0, Raysetta::Util.degrees_to_radians(0.0)
    assert_equal Math::PI/2.0, Raysetta::Util.degrees_to_radians(90.0)
    assert_equal Math::PI, Raysetta::Util.degrees_to_radians(180.0)
    assert_equal Math::PI*1.5, Raysetta::Util.degrees_to_radians(270.0)
    assert_equal Math::PI*2.0, Raysetta::Util.degrees_to_radians(360.0)
  end

  def test_random
    x = Raysetta::Util.random(0.5, 0.75)
    assert 0.5 <= x && x <= 0.75
  end

  def test_linear_to_gamma
    assert_equal 0.0, Raysetta::Util.linear_to_gamma(0.0)
    assert_equal 0.0, Raysetta::Util.linear_to_gamma(-1.0)
    assert_in_delta 0.5, Raysetta::Util.linear_to_gamma(0.25), Raysetta::Util::EPSILON
  end

  def test_gamma_to_linear
    assert_equal 0.0, Raysetta::Util.gamma_to_linear(0.0)
    assert_equal 0.0, Raysetta::Util.gamma_to_linear(-1.0)
    assert_in_delta 0.217637640824031, Raysetta::Util.gamma_to_linear(0.5), Raysetta::Util::EPSILON
    assert_in_delta 0.25, Raysetta::Util.gamma_to_linear(0.5, 2.0), Raysetta::Util::EPSILON
  end
end
