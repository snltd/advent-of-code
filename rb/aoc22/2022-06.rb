#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2022/day/06
#
class Aoc202206
  def solve01(input)
    solve_it(input, 4)
  end

  def solve02(input)
    solve_it(input, 14)
  end

  private

  def solve_it(input, window)
    input.chars.each_cons(window).with_index do |b, i|
      return i + window if b.uniq == b
    end
  end
end

class TestAoc202206 < MiniTest::Test
  include TestBase

  def table01
    {
      mjqjpqmgbljsphdztnvjfqwrcgsmlb: 7,
      bvwbjplbgvbhsrlpgdmjqwftvncz: 5,
      nppdvjthqldpwncqszvftbrmjlhg: 6,
      nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg: 10,
      zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw: 11
    }
  end

  def table02
    {
      mjqjpqmgbljsphdztnvjfqwrcgsmlb: 19,
      bvwbjplbgvbhsrlpgdmjqwftvncz: 23,
      nppdvjthqldpwncqszvftbrmjlhg: 23,
      nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg: 29,
      zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw: 26
    }
  end
end
