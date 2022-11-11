#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'
require_relative '../lib/base'

class Aoc202109
  def solve01(input)
    input = process_input(input)
    minima(input).sum { |x, y| input[y][x] + 1 }
  end

  def solve02(input)
    input = process_input(input)
    m = minima(input).map { |x, y| [x - 1, y - 1] }
    m.map { |p| fill_basin(input, p.map { |pt| pt + 1 }).size }
     .sort
     .reverse
     .take(3)
     .inject(:*)
  end

  def process_input(input)
    o1 = input.as_lines.map { |l| "9#{l}9" }
    o2 = ['9' * o1.first.length] + o1 + ['9' * o1.first.length]
    o2.map { |l| l.each_char.map(&:to_i) }
  end

  def minima(input)
    m1 = input.map.with_index { |l, row| line_mins(l, row) }
    m1 = Set.new(m1.flatten(1))

    m2 = input.transpose.map.with_index { |l, row| line_mins2(l, row) }
    m2 = Set.new(m2.flatten(1))

    m1.intersection(m2)
  end

  # Return the adjacent points which are not a 9
  #
  def neighbours(input, x, y)
    adj = [[x, y - 1],
           [x + 1, y],
           [x, y + 1],
           [x - 1, y]]

    Set.new(adj.reject { |xa, ya| input[ya][xa] == 9 })
  end

  def fill_basin(input, point, aggr = Set.new([]))
    return aggr if point.nil?

    aggr.<< point
    (neighbours(input, *point) - aggr).each { |p| fill_basin(input, p, aggr) }
    fill_basin(input, p, aggr)
  end

  def line_mins(line, row)
    ([10] + line + [10]).each_cons(3).with_object([]).with_index do |(c, ret), i|
      ret.<< [i, row] if c[1] < c[0] && c[1] < c[2]
    end
  end

  def line_mins2(line, row)
    ([10] + line + [10]).each_cons(3).with_object([]).with_index do |(c, ret), i|
      ret.<< [row, i] if c[1] < c[0] && c[1] < c[2]
    end
  end
end

class TestAoc202109 < MiniTest::Test
  include TestBase

  def answer01
    15
  end

  def answer02
    1134
  end

  def sample
    <<~EOSAMPLE
      2199943210
      3987894921
      9856789892
      8767896789
      9899965678
    EOSAMPLE
  end
end
