#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2016/day/6
#
class Aoc201606
  def solve01(input)
    solve_it(input, -1)
  end

  def solve02(input)
    solve_it(input, 0)
  end

  private

  def solve_it(input, index)
    input.as_lines
         .map { |l| l.each_char.to_a }
         .transpose
         .map { |col| col.tally.sort_by { |_k, v| v }[index].first }
         .join
  end
end

class TestAoc201606 < MiniTest::Test
  include TestBase

  def sample
    <<~EOSAMPLE
      eedadn
      drvtee
      eandsr
      raavrd
      atevrs
      tsrnev
      sdttsa
      rasrtv
      nssdts
      ntnada
      svetve
      tesnvt
      vntsnd
      vrdear
      dvrsen
      enarar
    EOSAMPLE
  end

  def answer01
    'easter'
  end

  def answer02
    'advent'
  end
end
