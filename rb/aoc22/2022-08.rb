#!/usr/bin/env ruby

# frozen_string_literal: true

require 'set'
require_relative '../lib/base'

# https://adventofcode.com/2022/day/08
#
class Aoc202208
  def solve01(input)
    grid = input.as_int_grid

    visible = Set.new

    grid.each.with_index do |row, y|
      tallest = -1

      0.upto(row.size - 1) do |x|
        if row[x] > tallest
          visible.<< [x, y]
          tallest = row[x]
        end

        break if row[x] == 9
      end

      tallest = -1

      (row.size - 1).downto(0) do |x|
        if row[x] > tallest
          visible.<< [x, y]
          tallest = row[x]
        end

        break if row[x] == 9
      end
    end

    vert = grid.transpose

    vert.each.with_index do |col, x|
      tallest = -1

      0.upto(col.size - 1) do |y|
        if col[y] > tallest
          visible.<< [x, y]
          tallest = col[y]
        end

        break if col[y] == 9
      end

      tallest = - 1

      (col.size - 1).downto(0) do |y|
        if col[y] > tallest
          visible.<< [x, y]
          tallest = col[y]
        end

        break if col[y] == 9
      end
    end

    visible.size
  end

  def solve02(input)
    grid = input.as_int_grid
    @edge = grid.size - 1

    scores = {}

    1.upto(@edge) do |y|
      1.upto(@edge) do |x|
        scores[[x, y]] = scenic_score(grid, x, y)
      end
    end

    scores.values.flatten.max
  end

  def scenic_score(grid, x, y)
    s = 0
    z = []
    h = grid[y][x]

    (y - 1).downto(0) do |p| # up
      s += 1
      break if grid[p][x] >= h
    end

    z.<< s
    s = 0

    (x - 1).downto(0) do |p| # left
      s += 1
      break if grid[y][p] >= h
    end

    z.<< s
    s = 0

    (x + 1).upto(@edge) do |p| # right
      s += 1
      break if grid[y][p] >= h
    end

    z.<< s
    s = 0

    (y + 1).upto(@edge) do |p| # up
      s += 1
      break if grid[p][x] >= h
    end

    z.<< s

    z.inject(:*)
  end
end

class TestAoc202208 < MiniTest::Test
  include TestBase

  def answer01
    21
  end

  def answer02
    8
  end

  def sample
    <<~EOSAMPLE
      30373
      25512
      65332
      33549
      35390
    EOSAMPLE
  end
end
