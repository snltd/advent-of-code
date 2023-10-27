#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

class Aoc202009
  attr_accessor :window_size, :target # so the tests can override them

  def initialize
    @window_size = 25
    @target = 14_360_655
  end

  def solve01(input)
    offset = @window_size
    input = input.as_ints

    while offset < input.size
      offset += 1
      num = input[offset]
      window = preamble(input, offset, window_size)

      return num unless addends?(num, window)
    end
  end

  def preamble(input, offset, window_size)
    window_end = offset - 1
    window_start = offset - window_size
    input[window_start..window_end]
  end

  def addends?(value, input)
    input.each do |n|
      return true if input.include?(value - n) && value != n * 2
    end

    false
  end

  def solve02(input)
    result = nil

    1.upto(input.size) do |i|
      result = try_from(input.as_ints, i)
      break if result
    end

    result.max + result.min
  end

  def try_from(input, index)
    running_sum = 0
    sequence = [input[index]]

    while running_sum < target
      running_sum += input[index]
      sequence << input[index]
      return sequence if running_sum == target

      index += 1
    end

    false
  end
end

class TestAoc202009 < Minitest::Test
  include TestBase

  def answer01
    127
  end

  def _answer02
    62
  end

  def sample
    <<~EOSAMPLE
      35
      20
      15
      25
      47
      40
      62
      55
      65
      95
      102
      117
      150
      182
      127
      219
      299
      277
      309
      576
    EOSAMPLE
  end

  def post_setup
    @c.window_size = 5
  end

  def test_addends_ex1
    range = Range.new(1, 25)

    assert @c.addends?(26, range)
    assert @c.addends?(49, range)
    refute @c.addends?(100, range)
    refute @c.addends?(50, range)
  end

  def test_addends_ex2
    range = Range.new(1, 25).to_a << 45
    range.delete(20)
    assert @c.addends?(26, range)
    refute @c.addends?(65, range)
    assert @c.addends?(64, range)
    assert @c.addends?(66, range)
  end

  def test_preamble
    assert_equal([35, 20, 15], @c.preamble(sample.as_ints, 3, 3))
    assert_equal([55, 65, 95, 102], @c.preamble(sample.as_ints, 11, 4))
  end
end
