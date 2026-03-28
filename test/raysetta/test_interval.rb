# frozen_string_literal: true

require "test_helper"

class TestInterval < Minitest::Test
  def test_from_range
    i = Raysetta::Interval.from_range(1.0..2.0)
    assert_equal 1.0, i.min
    assert_equal 2.0, i.max
  end

  def test_from_intervals
    assert_equal Raysetta::Interval.new(1.0, 4.0),
      Raysetta::Interval.from_intervals(
        Raysetta::Interval.new(1.0, 2.0),
        Raysetta::Interval.new(3.0, 4.0),
      )

    assert_equal Raysetta::Interval.new(1.0, 4.0),
      Raysetta::Interval.from_intervals(
        Raysetta::Interval.new(2.0, 3.0),
        Raysetta::Interval.new(1.0, 4.0),
      )
  end

  def test_size
    i = Raysetta::Interval.new(3.0, 7.0)
    assert_equal 4.0, i.size
  end

  def test_include
    i = Raysetta::Interval.new(1.0, 2.0)
    assert i.include? 1.5
    assert i.include? 1.0
    assert i.include? 2.0

    refute i.include? 0.5
    refute i.include? 2.5
  end

  def test_surround
    i = Raysetta::Interval.new(1.0, 2.0)
    assert i.surround? 1.5
    refute i.surround? 1.0
    refute i.surround? 2.0

    refute i.surround? 0.5
    refute i.surround? 2.5
  end

  def test_clamp
    i = Raysetta::Interval.new(1.0, 2.0)
    assert_equal 1.0, i.clamp(0.5)
    assert_equal 2.0, i.clamp(2.5)
    assert_equal 1.5, i.clamp(1.5)
  end

  def test_expand
    i = Raysetta::Interval.new(1.0, 2.0)
    assert_equal Raysetta::Interval.new(0.75, 2.25), i.expand(0.5)
  end

  def test_dup
    i = Raysetta::Interval.new(1.0, 2.0)
    i2 = i.dup
    assert_equal i, i2
    refute i.equal?(i2)
  end
end
