#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/base'

class Aoc201903
  def solve01(input)
    paths = input.as_lines.map do |wire|
      wire.split(',').each_with_object([[0, 0]]) do |ins, p|
        dir = ins[0]
        mag = ins[1..].to_i

        mag.times do
          last_x, last_y = p[-1]

          p << case dir
               when 'R'
                 [last_x + 1, last_y]
               when 'L'
                 [last_x - 1, last_y]
               when 'U'
                 [last_x, last_y + 1]
               when 'D'
                 [last_x, last_y - 1]
               end
        end
      end
    end

    (paths[0] & paths[1])[1..].map(&:sum).min
  end

  def solve02(input)
    paths = input.as_lines.map do |wire|
      wire.split(',').each_with_object([[0, 0]]) do |ins, p|
        dir = ins[0]
        mag = ins[1..].to_i

        mag.times do
          last_x, last_y = p[-1]

          p << case dir
               when 'R'
                 [last_x + 1, last_y]
               when 'L'
                 [last_x - 1, last_y]
               when 'U'
                 [last_x, last_y + 1]
               when 'D'
                 [last_x, last_y - 1]
               end
        end
      end
    end

    (paths[0] & paths[1])[1..].map { |p| paths[0].index(p) + paths[1].index(p) }.min
  end
end

class TestAoc201903 < Minitest::Test
  include TestBase

  def table01
    {
      "R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83": 146,
      "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7": 135
    }
  end

  def table02
    {
      "R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83": 610,
      "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7": 410
    }
  end
end
