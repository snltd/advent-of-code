#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2015/day/3
# Perfectly Spherical Houses in a Vacuum
#
class Aoc201503
  def solve01(input)
    x = y = 0

    input.each_char.with_object({ [x, y] => true }) do |i, visited|
      x, y = move(x, y, i)
      visited[[x, y]] = true
    end.size
  end

  # rubocop:disable Metrics/AbcSize
  def solve02(input)
    visited = Hash.new(0)
    sx = sy = rx = ry = 0
    visited[[sx, sy]] = 1

    input.each_char.with_index do |i, index|
      if index.even?
        x = sx
        y = sy
      else
        x = rx
        y = ry
      end

      x, y = move(x, y, i)
      visited[[x, y]] += 1

      if index.even?
        sx = x
        sy = y
      else
        rx = x
        ry = y
      end
    end

    visited.count
  end
  # rubocop:enable Metrics/AbcSize

  private

  def move(x_pos, y_pos, instruction)
    case instruction
    when '^'
      [x_pos, y_pos + 1]
    when '>'
      [x_pos + 1, y_pos]
    when 'v'
      [x_pos, y_pos - 1]
    when '<'
      [x_pos - 1, y_pos]
    end
  end
end

# Tests
#
class TestAoc201503 < MiniTest::Test
  include TestBase

  def table01
    {
      '>': 2,
      '^>v<': 4,
      '^v^v^v^v^v': 2
    }
  end

  def table02
    {
      '^v': 3,
      '^>v<': 3,
      '^v^v^v^v^v': 11
    }
  end
end
