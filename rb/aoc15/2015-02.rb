#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2015/day/2
#
class Aoc201502
  def solve01(input)
    input.as_lines.sum { |l| paper(l) }
  end

  def solve02(input)
    input.as_lines.sum { |l| ribbon(l) }
  end

  private

  def paper(present)
    l, w, h = present.split('x').map(&:to_i)
    extra = [l, w, h].sort.take(2).reduce(:*)

    (2 * l * w) + (2 * w * h) + (2 * h * l) + extra
  end

  def ribbon(present)
    l, w, h = present.split('x').map(&:to_i)

    perim = [l, w, h].sort.take(2).sum * 2
    bow = l * w * h
    bow + perim
  end
end

# Tests
#
class TestAoc201502 < MiniTest::Test
  include TestBase

  def table01
    {
      '2x3x4': 58,
      '1x1x10': 43
    }
  end

  def table02
    {
      '2x3x4': 34,
      '1x1x10': 14
    }
  end
end
