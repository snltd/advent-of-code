#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'
require_relative '../lib/light_grid'

# https://adventofcode.com/2015/day/6
# Grid of lights
#
class Aoc201506
  SIZE = 1000

  def solve01(input)
    LightGrid01.new(SIZE, SIZE).play_input(input)
  end

  def solve02(input)
    LightGrid02.new(SIZE, SIZE).play_input(input)
  end
end

class LightGrid01 < LightGrid
  def on(points)
    points.each { |p| @grid[p] = 1 }
  end

  def off(points)
    points.each { |p| @grid[p] = 0 }
  end

  def toggle(points)
    points.each { |p| @grid[p] = @grid[p].zero? ? 1 : 0 }
  end
end

class LightGrid02 < LightGrid
  def on(points)
    points.each { |p| @grid[p] += 1 }
  end

  def off(points)
    points.each { |p| @grid[p] -= 1 unless @grid[p].zero? }
  end

  def toggle(points)
    points.each { |p| @grid[p] += 2 }
  end

  def count
    @grid.sum
  end
end

# Tests
#
class TestAoc201506 < Minitest::Test
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
