#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

class Aoc202013
  def solve01(input)
    input = input.as_lines
    solve_for(input.first.to_i,
              input.last.split(',').reject { |i| i == 'x' }.map(&:to_i))
  end

  def solve_for(ts, ids)
    ids.map { |i| [i, i - (ts % i)] }.min_by { |a| a[1] }.reduce(:*)
  end
end

class TestAoc202013 < MiniTest::Test
  include TestBase

  def answer01
    295
  end

  def sample
    <<~EOINPUT
      939
      7,13,x,x,59,x,31,19
    EOINPUT
  end
end
