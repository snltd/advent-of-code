#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# It's a child's homework. I trust the input.
# rubocop:disable Security/Eval
class Aoc202018
  def solve01(input)
    input.as_lines.sum { |i| calculate01(i) }
  end

  def solve02(input)
    input.as_lines.sum { |i| calculate02(i) }
  end

  private

  def calculate01(raw)
    return calc_block01(raw) unless raw.include?('(')

    calculate01(raw.sub(/\(([^()]+)\)/) { calc_block01(Regexp.last_match[1]) })
  end

  def calc_block01(raw)
    args = raw.split
    tot = args.shift.to_i

    args.each_slice(2) do |op, arg|
      tot += arg.to_i if op == '+'
      tot *= arg.to_i if op == '*'
    end

    tot
  end

  def calculate02(raw)
    return calc_block02(raw) unless raw.include?('(')

    calculate02(raw.sub(/\(([^()]+)\)/) { calc_block02(Regexp.last_match[1]) })
  end

  def calc_block02(raw)
    return eval(raw) unless raw.include?('+')

    calc_block02(raw.gsub(/(\d+ \+ \d+)/) { eval(Regexp.last_match[1]) })
  end
end

class TestAoc202018 < Minitest::Test
  include TestBase

  def table01
    {
      '1 + 2 * 3 + 4 * 5 + 6': 71,
      '2 * 3 + (4 * 5)': 26,
      '5 + (8 * 3 + 9 + 3 * 4 * 3)': 437,
      '5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))': 12_240,
      '((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2': 13_632
    }
  end

  def table02
    {
      '1 + 2 * 3 + 4 * 5 + 6': 231,
      '1 + (2 * 3) + (4 * (5 + 6))': 51,
      '5 + (8 * 3 + 9 + 3 * 4 * 3)': 1445,
      '5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))': 669_060,
      '((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2': 23_340
    }
  end
end
