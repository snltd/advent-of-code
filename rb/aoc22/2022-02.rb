#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2022/day/02
#
class Aoc202202
  def solve01(input)
    input.as_lines.sum { |l| table01[l] }
  end

  def solve02(input)
    input.as_lines.sum { |l| table02[l] }
  end

  private

  # Them         You
  # A    Rock      X
  # B    Paper     Y
  # C   Scissors   Z
  def table01
    {
      'A X' => 1 + 3,
      'A Y' => 2 + 6,
      'A Z' => 3 + 0,
      'B X' => 1 + 0,
      'B Y' => 2 + 3,
      'B Z' => 3 + 6,
      'C X' => 1 + 6,
      'C Y' => 2 + 0,
      'C Z' => 3 + 3,
    }
  end

  # X  lose
  # Y  draw
  # Z  win
  def table02
    {
      'A X' => 0 + 3,
      'A Y' => 3 + 1,
      'A Z' => 6 + 2,
      'B X' => 0 + 1,
      'B Y' => 3 + 2,
      'B Z' => 6 + 3,
      'C X' => 0 + 2,
      'C Y' => 3 + 3,
      'C Z' => 6 + 1,
    }
  end
end

class TestAoc202202 < MiniTest::Test
  include TestBase

  def answer01
    15
  end

  def answer02
    12
  end

  def sample
    <<~EOSAMPLE
      A Y
      B X
      C Z
    EOSAMPLE
  end
end
