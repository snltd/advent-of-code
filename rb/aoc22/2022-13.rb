#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2022/day/13
#
class Aoc202213
  def solve01(input)
    input.as_blocks.each do |blk|

      a, b = blk.as_lines.map { |l| eval(l) }

      puts "+_+++++"
      p a
      p b
    end
    puts "cunt"
    0
  end

  def solve02(input)
    input
    0
  end
end

class TestAoc202213 < MiniTest::Test
  include TestBase

  def answer01
    0
  end

  def answer02
    0
  end

  def sample
    <<~EOSAMPLE
      [1,1,3,1,1]
      [1,1,5,1,1]

      [[1],[2,3,4]]
      [[1],4]

      [9]
      [[8,7,6]]

      [[4,4],4,4]
      [[4,4],4,4,4]

      [7,7,7,7]
      [7,7,7]

      []
      [3]

      [[[]]]
      [[]]

      [1,[2,[3,[4,[5,6,7]]]],8,9]
      [1,[2,[3,[4,[5,6,0]]]],8,9]
    EOSAMPLE
  end
end
