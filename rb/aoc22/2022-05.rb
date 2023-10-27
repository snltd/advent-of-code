#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2022/day/05
#
class Aoc202205
  def solve01(input)
    solve_it(input, true)
  end

  def solve02(input)
    solve_it(input, false)
  end

  private

  def solve_it(input, reverse)
    stacks, instructions = process(input)

    instructions.as_lines.each do |i|
      _, count, _, from, _, to = i.split
      bits = stacks[from].pop(count.to_i)
      bits.reverse! if reverse
      stacks[to] += bits
    end

    stacks.map { |_k, v| v.last }.join
  end

  def process(input)
    raw, instructions = input.as_raw_blocks
    raw = raw.as_lines
    nums = raw.pop

    stacks = nums.each_char.with_index.with_object({}) do |(c, i), aggr|
      next if c == ' '

      aggr[c] = extract_stack(raw, i)
    end

    [stacks, instructions]
  end

  def extract_stack(raw, index)
    raw.map { |r| r[index] }.reject { |e| e == ' ' }.compact.reverse
  end
end

class TestAoc202205 < Minitest::Test
  include TestBase

  def answer01
    'CMZ'
  end

  def answer02
    'MCD'
  end

  def sample
    <<~EOSAMPLE
          [D]
      [N] [C]
      [Z] [M] [P]
       1   2   3

      move 1 from 2 to 1
      move 3 from 1 to 3
      move 2 from 2 to 1
      move 1 from 1 to 2
    EOSAMPLE
  end
end
