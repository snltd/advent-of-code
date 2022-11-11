#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2015/day/11
#
class Aoc201511
  def solve01(input)
    @answer01 = solve_it(input)
  end

  def solve02(_input)
    solve_it(@answer01.next)
  end

  private

  def solve_it(input)
    loop do
      return input if good?(input)

      input = input.tr('i', 'j').tr('o', 'p').tr('l', 'm').next
    end
  end

  def good?(password)
    return false if password.match?(/[iol]/)

    chars = password.chars

    return false if chars.each_cons(3).none? { |c| c[2] == c[1].next && c[1] == c[0].next }

    last = nil
    pairs = 0

    chars.each_cons(2) do |c|
      pairs += 1 if c[0] == c[1] && c != last
      last = c
    end

    pairs >= 2
  end
end
