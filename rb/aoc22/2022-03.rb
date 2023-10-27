#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2022/day/03
#
class Aoc202203
  def solve01(input)
    input.as_lines.sum { |l| value_for(common_item01(l)) }
  end

  def solve02(input)
    input.as_lines.each_slice(3).sum { |b| value_for(common_item02(b)) }
  end

  private

  def value_for(char)
    ord = char.ord - 96
    ord.positive? ? ord : ord + 58
  end

  def common_item01(line)
    c2 = line.length / 2
    seen = line[0...c2].to_hash_table
    line[c2..].each_char { |c| return c if seen.key?(c) }
  end

  def common_item02(block)
    seen00 = block[0].to_hash_table
    seen01 = block[1].to_hash_table

    block[2].each_char { |c| return c if seen00.key?(c) && seen01.key?(c) }
  end
end

class TestAoc202203 < Minitest::Test
  include TestBase

  def answer01
    157
  end

  def answer02
    70
  end

  def sample
    <<~EOSAMPLE
      vJrwpWtwJgWrhcsFMMfFFhFp
      jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
      PmmdzqPrVvPwwTWBwg
      wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
      ttgJtRGJQctTZtZT
      CrZsJsPPZsGzwwsLwLmpwMDw
    EOSAMPLE
  end
end
