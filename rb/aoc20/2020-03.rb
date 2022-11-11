#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'
require_relative '../lib/grid'

# Problem 0301. All the work for this is in the Grid class, which took ages
# and I hope I'll get some more use from.
#
class Aoc202003
  def solve01(input)
    Toboggan.new(input.as_raw_char_grid).run([3, 1])
  end

  def solve02(input)
    [[1, 1],
     [3, 1],
     [5, 1],
     [7, 1],
     [1, 2]].map { |m| Toboggan.new(input.as_raw_char_grid).run(m) }.reduce(:*)
  end
end

class TestAoc202003 < MiniTest::Test
  include TestBase

  def answer01
    7
  end

  def answer02
    336
  end

  def sample
    <<~EOINPUT
      ..##.......
      #...#...#..
      .#....#..#.
      ..#.#...#.#
      .#...##..#.
      ..#.##.....
      .#.#.#....#
      .#........#
      #.##...#...
      #...##....#
      .#..#...#.#
    EOINPUT
  end
end

class Toboggan
  def initialize(input)
    @input = input
  end

  def run(move)
    g = Grid.new(@input, move: move)
    hits = 0

    loop do
      hits += 1 if g.hit?
      g.move!
    end
  rescue OutsideGridY
    hits
  end
end
