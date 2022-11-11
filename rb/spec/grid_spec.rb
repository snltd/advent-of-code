#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../../lib/support/grid'

# Tests
#
class TestGrid < MiniTest::Test
  attr_reader :c

  def setup
    @c = Grid.new(sample_data, move: [3, 1])
  end

  def test_width
    assert_equal(4, c.width)
  end

  def test_height
    assert_equal(3, c.height)
  end

  def test_at
    assert_equal('.', c.at(0, 0))
    assert_equal('#', c.at(3, 0))
    assert_equal('#', c.at(0, 1))
    assert_equal('.', c.at(0, 2))
    assert_raises(OutsideGridX) { c.at(5, 2) }
  end

  def test_hit?
    assert c.hit?(0, 1)
    refute c.hit?(2, 2)
    refute c.hit?(0, 0)
    assert_raises(OutsideGridX) { c.hit?(5, 2) }
  end

  def test_miss?
    assert c.miss?(0, 0)
    assert c.miss?(2, 2)
    refute c.miss?(0, 1)
    assert_raises(OutsideGridY) { c.miss?(0, 9) }
    assert_raises(OutsideGridFail) { c.miss?(0, -1) }
  end

  def test_valid_point?
    assert c.valid_point?(0, 0)
    assert c.valid_point?(3, 2)
    assert_raises(OutsideGridFail) { c.valid_point?(0, -1) }
    assert_raises(OutsideGridY) { c.valid_point?(3, 3) }
    assert_raises(OutsideGridX) { c.valid_point?(4, 0) }
  end

  def sample_data
    [%w[. . # #],
     %w[# . . .],
     %w[. # . .]]
  end

  def test_move!
    assert_equal([0, 0], c.pos)
    c.move!
    assert_equal([3, 1], c.pos)
  end

  def test_move_and_hit
    assert c.miss?
    c.move!(0, 1)
    assert c.hit?
    c.move!(2, 1)
    assert c.miss?
    c.move!(-1, 0)
    assert c.hit?
    assert_raises(OutsideGridY) { c.move!(0, 10) }
  end

  def test_map_wrap1
    assert_equal([0, 0], c.pos)
    c.move!(2, 0)
    assert c.hit?
    c.move!(2, 0)
    assert c.miss?
  end

  def test_map_wrap2
    assert_equal([0, 0], c.pos)
    c.move!(3, 1)
    assert c.miss?
    c.move!(3, 1)
    assert c.miss?
    assert_equal([2, 2], c.pos)
  end
end
