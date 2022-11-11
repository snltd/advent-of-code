#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2015/day/6
# Grid of lights
#
class Aoc201506
  SIZE = 1000

  def solve01(input)
    grid = init_grid

    input.as_lines.each do |i|
      nums = i.match(/(\d+,\d+) .* (\d+,\d+)/)
      if i.start_with?('toggle')
        toggle01 grid, nums[1], nums[2]
      elsif i.start_with?('turn on')
        on01 grid, nums[1], nums[2]
      elsif i.start_with?('turn off')
        off01 grid, nums[1], nums[2]
      end
    end

    count01(grid)
  end

  def solve02(input)
    grid = init_grid

    input.as_lines.each do |i|
      nums = i.match(/(\d+,\d+) .* (\d+,\d+)/)
      if i.start_with?('toggle')
        toggle02 grid, nums[1], nums[2]
      elsif i.start_with?('turn on')
        on02 grid, nums[1], nums[2]
      elsif i.start_with?('turn off')
        off02 grid, nums[1], nums[2]
      end
    end

    count02(grid)
  end

  private

  def init_grid
    grid = []

    1.upto(SIZE) do |_row|
      grid.<< Array.new(SIZE, 0)
    end

    grid
  end

  def off01(grid, top_left, bottom_right)
    x1, y1 = top_left.split(',').map(&:to_i)
    x2, y2 = bottom_right.split(',').map(&:to_i)

    x1.upto(x2) do |x|
      y1.upto(y2) do |y|
        grid[y][x] = 0
      end
    end

    grid
  end

  def off02(grid, top_left, bottom_right)
    x1, y1 = top_left.split(',').map(&:to_i)
    x2, y2 = bottom_right.split(',').map(&:to_i)

    x1.upto(x2) do |x|
      y1.upto(y2) do |y|
        grid[y][x] -= 1 unless grid[y][x].zero?
      end
    end

    grid
  end

  def on01(grid, top_left, bottom_right)
    x1, y1 = top_left.split(',').map(&:to_i)
    x2, y2 = bottom_right.split(',').map(&:to_i)

    x1.upto(x2) do |x|
      y1.upto(y2) do |y|
        grid[y][x] = 1
      end
    end

    grid
  end

  def on02(grid, top_left, bottom_right)
    x1, y1 = top_left.split(',').map(&:to_i)
    x2, y2 = bottom_right.split(',').map(&:to_i)

    x1.upto(x2) do |x|
      y1.upto(y2) do |y|
        grid[y][x] += 1
      end
    end

    grid
  end

  def toggle01(grid, top_left, bottom_right)
    x1, y1 = top_left.split(',').map(&:to_i)
    x2, y2 = bottom_right.split(',').map(&:to_i)

    x1.upto(x2) do |x|
      y1.upto(y2) do |y|
        curr = grid[y][x]
        grid[y][x] = curr == 1 ? 0 : 1
      end
    end

    grid
  end

  def toggle02(grid, top_left, bottom_right)
    x1, y1 = top_left.split(',').map(&:to_i)
    x2, y2 = bottom_right.split(',').map(&:to_i)

    x1.upto(x2) do |x|
      y1.upto(y2) do |y|
        grid[y][x] += 2
      end
    end

    grid
  end

  def count01(grid)
    grid.flatten.count { |n| n == 1 }
  end

  def count02(grid)
    grid.flatten.sum
  end
end

# Tests
#
class TestAoc201506 < MiniTest::Test
  include TestBase

  def table01
    {
      'turn on 0,0 through 999,999': 1_000_000,
      'toggle 0,0 through 999,0': 1000,
      'turn on 499,499 through 500,500': 4
    }
  end

  def table02
    {
      'turn on 0,0 through 0,0': 1,
      'toggle 0,0 through 999,999': 2_000_000
    }
  end
end
