#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/light_grid'

class LightGridTest < Minitest::Test
  def setup
    @g = LightGrid.new(5, 5)
  end

  def test_initialize
    assert_equal(25, LightGrid.new(5, 5).grid.size)
    assert_equal([0, 0, 0, 0], LightGrid.new(2, 2).grid)
  end

  def test_points
    assert_equal([6, 7, 8, 11, 12, 13], @g.points('1,1', '3,2'))
    assert_equal([16], @g.points('1,3', '1,3'))
    assert_equal([5, 6, 7, 8, 9], @g.points('0,1', '4,1'))
    assert_equal([2, 7, 12, 17, 22], @g.points('2,0', '2,4'))
  end

  def test_neighbours
    assert_equal([0, 1, 2, 5, 7, 10, 11, 12], @g.neighbours(6).sort)
    assert_equal([1, 5, 6], @g.neighbours(0).sort)
    assert_equal([3, 8, 9], @g.neighbours(4).sort)
  end
end
