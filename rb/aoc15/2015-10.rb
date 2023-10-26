#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2015/day/10
#
class Aoc201510
  def solve01(input)
    solve_it(input, 40)
  end

  def solve02(input)
    solve_it(input, 50)
  end

  private

  def solve_it(input, iterations)
    iterations.times { input = expand(input) }
    input.length
  end

  def expand(str)
    ret = +''
    last = nil
    run_length = 0

    str.each_char do |c|
      if last == c || last.nil?
        run_length += 1
      else
        ret << (run_length.to_s + last)
        run_length = 1
      end

      last = c
    end

    ret + run_length.to_s + last
  end
end
