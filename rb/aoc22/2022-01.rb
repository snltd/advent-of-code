#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2022/day/01
#
class Aoc202201
  def solve01(input)
    input.as_num_blocks.map(&:sum).max
  end

  def solve02(input)
    input.as_num_blocks.map(&:sum).sort.reverse.take(3).sum
  end
end

class TestAoc202201 < MiniTest::Test
  include TestBase

  def answer01
    24_000
  end

  def answer02
    45_000
  end

  def sample
    <<~EOSAMPLE
      1000
      2000
      3000

      4000

      5000
      6000

      7000
      8000
      9000

      10000
    EOSAMPLE
  end
end
