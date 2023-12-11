#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'
require_relative '../lib/grid'

# https://adventofcode.com/2023/day/10
#
class Aoc202310
  def solve01(input)
    g = Grid.new(input)
    (perimeter(g, input).length - 1) / 2
  end

  def solve02(input)
    g = Grid.new(input)
    perim = perimeter(g, input)

    (0...g.points).each do |p|
      g.grid[p] = '.' unless perim.include?(p)
    end

    perim_crosses = g.indices_of('.').map do |p|
      perim_cross(g.vals_to_end_of_row(p))
    end

    perim_crosses.count { |p| p.to_i.odd? }
  end

  private

  def perimeter(grid, _input)
    trail = grid.indices_of('S')
    trail << first_step(grid, trail.last)

    loop do
      trail = move_cursor(grid, trail)
      return trail if trail.last == trail.first
    end
  end

  def mover(trail, opt1, opt2)
    trail[-2] == opt1 ? opt2 : opt1
  end

  def move_cursor(grid, trail)
    bit = grid.val_at(trail.last)
    p = trail.last

    case bit
    when '-'
      trail << mover(trail, grid.left(p), grid.right(p))
    when '|'
      trail << mover(trail, grid.up(p), grid.down(p))
    when 'L'
      trail << mover(trail, grid.right(p), grid.up(p))
    when 'J'
      trail << mover(trail, grid.left(p), grid.up(p))
    when '7'
      trail << mover(trail, grid.down(p), grid.left(p))
    when 'F'
      trail << mover(trail, grid.down(p), grid.right(p))
    end

    trail
  end

  def first_step(grid, point)
    return grid.up(point) if %w[| F 7].include?(grid.val_at(grid.up(point)))
    return grid.right(point) if %w[- J 7].include?(grid.val_at(grid.right(point)))
    return grid.down(point) if %w[| J L].include?(grid.val_at(grid.down(point)))

    grid.left(point) if %w[- F L].include?(grid.val_at(grid.left(point)))
  end

  def perim_cross(vals)
    ret = 0
    chars = vals.tally
    ret += chars.fetch('|', 0)
    ret += chars.fetch('F', 0) * -0.5
    ret += chars.fetch('J', 0) * -0.5
    ret += chars.fetch('7', 0) * 0.5
    ret += chars.fetch('L', 0) * 0.5
    ret + (chars.fetch('S', 0) * 0.5)
  end
end

class TestAoc202310 < Minitest::Test
  include TestBase

  def answer01
    8
  end

  def answer02
    10
  end

  def sample01
    <<~EOSAMPLE
      ..F7.
      .FJ|.
      SJ.L7
      |F--J
      LJ...
    EOSAMPLE
  end

  def sample02
    <<~EOSAMPLE
      FF7FSF7F7F7F7F7F---7
      L|LJ||||||||||||F--J
      FL-7LJLJ||||||LJL-77
      F--JF--7||LJLJ7F7FJ-
      L---JF-JLJ.||-FJLJJ7
      |F|F-JF---7F7-L7L|7|
      |FFJF7L7F-JF7|JL---7
      7-L-JL7||F7|L7F-7F7|
      L.L7LFJ|||||FJL7||LJ
      L7JLJL-JLJLJL--JLJ.L
    EOSAMPLE
  end
end
