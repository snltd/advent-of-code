#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2015/day/1
#
class Aoc201501
  def solve01(input)
    input.chars.count('(') - input.count(')')
  end

  def solve02(input)
    floor = 0

    input.each_char.with_index(1) do |i, pos|
      i == '(' ? floor += 1 : floor -= 1

      return pos if floor == -1
    end
  end
end

# Tests
#
class TestAoc201501 < Minitest::Test
  include TestBase

  def table01
    {
      '(())': 0,
      '()()': 0,
      '(((': 3,
      '(()(()(': 3,
      '))(((((': 3,
      '())': -1,
      '))(': -1,
      ')))': -3,
      ')())())': -3
    }
  end

  def table02
    {
      ')': 1,
      '()())': 5
    }
  end

  def long_test; end
end
