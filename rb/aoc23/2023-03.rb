#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'
require_relative '../lib/grid'

# https://adventofcode.com/2023/day/03
#
class Aoc202303
  def solve01(input)
    @g = Grid.new(input)
    number_ranges.sum { |x| x[0] }
  end

  def solve02(input)
    @g = Grid.new(input)
    ranges = number_ranges
    @g.indices_of('*')
      .map { |s| gear_neighbours(s, ranges) }
      .select { |g| g.size > 1 }
      .sum { |gp| gp.map(&:first).inject(:*) }
  end

  private

  # @return [Array] subset of the given number ranges which neighbour the
  # given star.
  #
  def gear_neighbours(star, ranges)
    ranges.select do |_n, i|
      @g.neighbours8(star).any? { |p| i.include?(p) }
    end
  end

  # Subset of nums_at which border a symbol
  def number_ranges
    nums_at(@g.all_vals, @g.width).select do |num|
      _, i = num
      neighbours_symbol?(i, @g)
    end
  end

  # does anything in the given point range neighbour a symbol?
  def neighbours_symbol?(range, grid)
    range.any? do |i|
      !grid.vals_of(grid.neighbours8(i)).all? { |v| v.is_integer? || v == '.' }
    end
  end

  # @return [Array[Integer, Array[Integer]]] of multi-digit numbers, and the
  # positions in the grid the number covers
  def nums_at(input, width)
    ret = []

    input.each_with_index { |n, i| ret << [n, i] if n.is_integer? }

    r2 = tmp_idx = []
    last_i = 1
    tmp_num = ''

    ret.each do |n, i|
      if i == last_i + 1 && (i % width).positive?
        tmp_num += n
        tmp_idx = tmp_idx << i
      else
        r2 << [tmp_num.to_i, tmp_idx] unless tmp_idx.empty?
        tmp_num = n
        tmp_idx = [i]
      end

      last_i = i
    end

    r2 << [tmp_num.to_i, tmp_idx] unless tmp_idx.empty?
    r2
  end
end

class TestAoc202303 < Minitest::Test
  include TestBase

  def answer01
    4361
  end

  def answer02
    467_835
  end

  def sample
    <<~EOSAMPLE
      467..114..
      ...*......
      ..35..633.
      ......#...
      617*......
      .....+.58.
      ..592.....
      ......755.
      ...$.*....
      .664.598..
    EOSAMPLE
  end
end
