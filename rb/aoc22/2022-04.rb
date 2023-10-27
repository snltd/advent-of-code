#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2022/day/04
#
class Aoc202204
  def solve01(input)
    input.as_lines.count { |l| contains?(l) }
  end

  def solve02(input)
    input.as_lines.count { |l| overlaps?(l) }
  end

  private

  def contains?(line)
    l1, r1, l2, r2 = line.split(/[^\d]/).map(&:to_i)
    (l1 <= l2 && r1 >= r2) || (l2 <= l1 && r2 >= r1)
  end

  def overlaps?(line)
    l1, r1, l2, r2 = line.split(/[^\d]/).map(&:to_i)
    r1 >= l2 && r2 >= l1
  end
end

class TestAoc202204 < Minitest::Test
  include TestBase

  def answer01
    2
  end

  def answer02
    4
  end

  def sample
    <<~EOSAMPLE
      2-4,6-8
      2-3,4-5
      5-7,7-9
      2-8,3-7
      6-6,4-6
      2-6,4-8
    EOSAMPLE
  end
end
