#!/usr/bin/env ruby

# frozen_string_literal: true

require 'set'
require_relative '../lib/base'

# https://adventofcode.com/2022/day/09
#
class Aoc202209
  def solve01(input)
    h = [0, 0]
    t = [0, 0]
    tv = Set.new

    input.as_lines.each do |l|
      dir, count = l.split

      count.to_i.times do
        h = move_head(h, dir)
        t = move_tail(h, t)
        tv.<< t.dup
      end
    end

    tv.size
  end

  def solve02(input)
    h = [0, 0]
    t = Array.new(9, [0, 0])
    tv = Set.new

    input.as_lines.each do |l|
      dir, count = l.split

      count.to_i.times do
        h = move_head(h, dir)
        t[0] = move_tail(h, t[0]).dup
        1.upto(8) { |i| t[i] = move_tail(t[i - 1], t[i]).dup }
        tv.<< t[8].dup
      end
    end

    tv.size
  end

  private

  def move_head(head_pos, direction)
    case direction
    when 'U'
      head_pos[1] += 1
    when 'R'
      head_pos[0] += 1
    when 'D'
      head_pos[1] -= 1
    when 'L'
      head_pos[0] -= 1
    end

    head_pos
  end

  def move_tail(h, t)
    return t if touching?(h, t)

    if h[0] > t[0]
      t[0] += 1
    elsif h[0] < t[0]
      t[0] -= 1
    end

    if h[1] > t[1]
      t[1] += 1
    elsif h[1] < t[1]
      t[1] -= 1
    end

    t
  end

  def touching?(h, t)
    x_gap = (h[0] - t[0]).abs
    y_gap = (h[1] - t[1]).abs
    x_gap <= 1 && y_gap <= 1
  end
end

class TestAoc202209 < MiniTest::Test
  include TestBase

  def answer01
    13
  end

  def answer02
    36
  end

  def sample01
    <<~EOSAMPLE
      R 4
      U 4
      L 3
      D 1
      R 4
      D 1
      L 5
      R 2
    EOSAMPLE
  end

  def sample02
    <<~EOSAMPLE
      R 5
      U 8
      L 8
      D 3
      R 17
      D 10
      L 25
      U 20
    EOSAMPLE
  end
end
