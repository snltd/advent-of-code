#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2023/day/06
#
class Aoc202306
  def solve01(input)
    process01(input).map { |t, d| t + 1 - dist(t, d) }.inject(:*)
  end

  def solve02(input)
    time, record = process02(input)
    time + 1 - dist(time, record)
  end

  private

  # Count how many times don't fulfil the criteria. Subtract this from the
  # number of times.
  #
  def dist(time, d)
    0.upto(time).each.with_index { |t, i| return i * 2 if t * (time - t) > d }
  end

  def process01(input)
    nums = input.as_lines.map { |l| l.split(':').last.to_ints }
    nums[0].zip(nums[1])
  end

  def process02(input)
    input.as_lines.map { |l| l.split(':').last.delete(' ').to_i }
  end
end

class TestAoc202306 < Minitest::Test
  include TestBase

  def answer01
    288
  end

  def answer02
    71_503
  end

  def sample
    <<~EOSAMPLE
      Time:      7  15   30
      Distance:  9  40  200
    EOSAMPLE
  end
end
