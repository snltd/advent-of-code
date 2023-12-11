#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'
require_relative '../lib/grid'

# https://adventofcode.com/2023/day/11
#
class Aoc202311
  def solve01(input)
    solve_for(input, 2)
  end

  def solve02(input)
    solve_for(input, 1_000_000)
  end

  private

  def solve_for(input, scale_factor)
    g = Grid.new(input)
    star_pair_coords = g.indices_of('#').combination(2).map { |a, b| [g.x_y(a), g.x_y(b)] }

    @expanded_rows = empty_rows(g)
    @expanded_cols = empty_cols(g)

    star_pair_coords.sum { |star1, star2| dist_between(star1, star2, scale_factor) }
  end

  def dist_between(star1, star2, scale_factor)
    x_coords = [star1[0], star2[0]].sort
    y_coords = [star1[1], star2[1]].sort

    extra_x_distance = (scale_factor - 1) * @expanded_cols.count { |c| c.between?(*x_coords) }
    extra_y_distance = (scale_factor - 1) * @expanded_rows.count { |c| c.between?(*y_coords) }

    x_diff = x_coords[1] - x_coords[0] + extra_x_distance
    y_diff = y_coords[1] - y_coords[0] + extra_y_distance

    x_diff + y_diff
  end

  def empty_rows(grid)
    grid.rows.filter_map.with_index { |r, i| i if r.all?('.') }
  end

  def empty_cols(grid)
    grid.cols.filter_map.with_index { |r, i| i if r.all?('.') }
  end
end

class TestAoc202311 < Minitest::Test
  include TestBase

  def answer01
    374
  end

  def sample01
    <<~EOSAMPLE
      ...#......
      .......#..
      #.........
      ..........
      ......#...
      .#........
      .........#
      ..........
      .......#..
      #...#.....
    EOSAMPLE
  end
end
