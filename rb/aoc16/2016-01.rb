#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2016/day/1
# Day 1: No Time for a Taxicab
#
class Aoc201601
  def solve01(input)
    bearing = x = y = 0

    input.split(', ').each do |inst|
      bearing = turn(bearing, inst[0])
      x, y = walk(x, y, bearing, inst[1..].to_i)
    end

    x.abs + y.abs
  end

  def solve02(input)
    bearing = x = y = 0
    visited = {}

    input.split(', ').each do |inst|
      bearing = turn(bearing, inst[0])
      x0 = x
      y0 = y
      x, y = walk(x, y, bearing, inst[1..].to_i)

      if x0 != x
        s = x > x0 ? 1 : -1
        (x0...x).step(s).each do |xp|
          return xp.abs + y.abs if visited.key?([xp, y])

          visited[[xp, y]] = true
        end
      end

      next unless y0 != y

      s = y > y0 ? 1 : -1
      (y0...y).step(s).each do |yp|
        return x.abs + yp.abs if visited.key?([x, yp])

        visited[[x, yp]] = true
      end
    end
  end

  private

  def turn(bearing, dir)
    return bearing == 3 ? 0 : bearing + 1 if dir == 'R'

    bearing.zero? ? 3 : bearing - 1
  end

  def walk(x, y, bearing, dist)
    case bearing
    when 0
      [x, y + dist]
    when 1
      [x + dist, y]
    when 2
      [x, y - dist]
    when 3
      [x - dist, y]
    end
  end
end

class TestAoc201601 < Minitest::Test
  include TestBase

  def table01
    {
      'R2, L3': 5,
      'R2, R2, R2': 2,
      'R5, L5, R5, R3': 12
    }
  end

  def table02
    {
      'R8, R4, R4, R8': 4
    }
  end
end
