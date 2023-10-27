#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# Binary boarding
#
class Aoc202005
  def solve01(input)
    input.as_lines.map { |pass| seat_id(pass) }.max
  end

  def solve02(input)
    seat_list = input.as_lines.map { |pass| seat_id(pass) }
    (Range.new(seat_list.min, seat_list.max).to_a - seat_list).first
  end

  def seat_id(pass)
    row = BinaryPartition.new(pass[0..6], 'B').value
    column = BinaryPartition.new(pass[7..10], 'R').value
    (row * 8) + column
  end
end

# Test the solution
#
class TestAoc202005 < Minitest::Test
  include TestBase

  def test_seat_id
    assert_equal(357, @c.seat_id('FBFBBFFRLR'))
    assert_equal(567, @c.seat_id('BFFFBBFRRR'))
    assert_equal(119, @c.seat_id('FFFBBBFRRR'))
    assert_equal(820, @c.seat_id('BBFFBBFRLL'))
  end
end

# You can easily turn the passport string into a binary value and convert it
# (see #cheaty_value) but I decided doing it that way went against the spirit
# of the exercise, so I re-implemented it the way it is done in the problem
# text.
#
class BinaryPartition
  def initialize(data, upper_char)
    @data = data
    @upper = upper_char
  end

  def value
    max = 2**@data.size
    range = Range.new(0, max, true).to_a

    @data.each_char do |c|
      range = c == @upper ? top_half(range) : bottom_half(range)
    end

    range.first
  end

  def top_half(arr)
    midpoint = arr.size / 2
    arr[midpoint..]
  end

  def bottom_half(arr)
    midpoint = arr.size / 2
    arr[...midpoint]
  end

  # I decided this was cheating.
  #
  def cheaty_value
    @data.gsub(@lower, '0').gsub(@upper, '1').to_i(2)
  end
end

# Test the BinaryPartition class
#
class TestBinaryPartition < Minitest::Test
  def test_fb
    assert_equal(44, BinaryPartition.new('FBFBBFF', 'B').value)
  end

  def test_rl
    assert_equal(5, BinaryPartition.new('RLR', 'R').value)
  end
end
