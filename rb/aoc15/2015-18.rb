#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'
require_relative '../lib/light_grid'

# https://adventofcode.com/2015/day/18
#
class Aoc201518
  SIZE = 100

  def solve01(input)
    solve_it(LightGrid1801.new(SIZE, SIZE), process(input))
  end

  def solve02(input)
    solve_it(LightGrid1802.new(SIZE, SIZE), process(input))
  end

  private

  def solve_it(grid, input)
    grid.grid = input
    100.times { grid.iterate }
    grid.count
  end

  def process(input)
    input.delete("\n").chars.map { |c| c == '#' ? 1 : 0 }
  end
end

class LightGrid1801 < LightGrid
  def iterate
    onvals = [2, 3]
    new_grid = []

    @grid.each_with_index do |v, i|
      n = vals(neighbours(i)).sum

      new_val = if v.zero?
                  n == 3 ? 1 : 0
                else
                  onvals.include?(n) ? 1 : 0
                end

      new_grid[i] = new_val
    end

    @grid = new_grid
    stuck_on if respond_to?(:stuck_on)
  end
end

class LightGrid1802 < LightGrid1801
  def stuck_on
    [0, 99, 9900, 9999].each { |p| @grid[p] = 1 }
  end
end
