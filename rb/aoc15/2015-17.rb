#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2015/day/17
#
class Aoc201517
  def solve01(input, val = 150)
    input = input.as_ints

    1.upto(input.size).inject(0) do |aggr, l|
      aggr + input.combination(l).count { |c| c.sum == val }
    end
  end

  def solve02(input, val = 150)
    input = input.as_ints

    combis = 1.upto(input.size).inject([]) do |aggr, l|
      aggr + input.combination(l).select { |c| c.sum == val }
    end

    min_num = combis.map(&:size).min
    combis.count { |c| c.size == min_num }
  end
end

class TestAoc201517 < Minitest::Test
  include TestBase

  def answer01
    4
  end

  def answer02
    3
  end

  def sample
    <<~EOSAMPLE
      20
      15
      10
      5
      5
    EOSAMPLE
  end

  def sample_val
    25
  end
end
