#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2023/day/09
#
class Aoc202309
  def solve01(input)
    input.as_lines.map(&:to_ints)
         .map { |l| extrapolate01(diff_list(l)) }.sum { |r| r.first.last }
  end

  def solve02(input)
    input.as_lines.map(&:to_ints)
         .map { |l| extrapolate02(diff_list(l)) }.sum { |r| r.first.first }
  end

  private

  def extrapolate01(lines)
    ret = []
    ret[lines.size - 1] = lines[-1] + [0]

    (lines.size - 2).downto(0) do |i|
      ret[i] = lines[i] + [(ret[i + 1][-1] + lines[i][-1])]
    end

    ret
  end

  def extrapolate02(lines)
    ret = []
    ret[lines.size - 1] = [0] + lines[-1]

    (lines.size - 2).downto(0) do |i|
      ret[i] = [(lines[i][0] - ret[i + 1][0])] + lines[i]
    end

    ret
  end

  def diff_list(line)
    lines = [line]

    loop do
      line = diffs(line)
      lines << line
      return lines if line.all?(&:zero?)
    end
  end

  def diffs(seq)
    seq.each_cons(2).map { |a, b| b - a }
  end
end

class TestAoc202309 < Minitest::Test
  include TestBase

  def answer01
    114
  end

  def answer02
    2
  end

  def sample
    <<~EOSAMPLE
      0 3 6 9 12 15
      1 3 6 10 15 21
      10 13 16 21 30 45
    EOSAMPLE
  end
end
