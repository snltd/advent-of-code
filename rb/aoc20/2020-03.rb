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

class TestAoc202003 < Minitest::Test
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
    g = Grid.new(@input, move:)
    hits = 0

    loop do
      hits += 1 if g.hit?
      g.move!
    end
  rescue OutsideGridY
    hits
  end
end

# This may well be massive overkill, but it may also save lots of time in the
# future. Who knows? Has mutable state, but doing this functionally in Ruby
# doesn't feel right.
# A grid's (0, 0) coordinate is the top left. All methods refer to (x, y)
#
class Grid
  attr_reader :raw, :pos, :move

  def initialize(data, options)
    @raw = data
    @hit_symbol = options[:hit_symbol] || '#'
    @miss_symbol = options[:miss_symbol] || '.'
    @move = options[:move]
    @pos = [0, 0]
  end

  def width
    @raw.first.size
  end

  def height
    @raw.size
  end

  def valid_point?(col, row)
    raise(OutsideGridFail, [col, row]) if col.negative? || row.negative?
    raise(OutsideGridY, [col, row]) if row >= height
    raise(OutsideGridX, [col, row]) if col >= width

    true
  end

  def at(col, row)
    valid_point?(col, row)
    @raw[row][col]
  end

  def hit?(col = pos[0], row = pos[1])
    valid_point?(col, row)
    at(col, row) == @hit_symbol
  end

  def miss?(col = pos[0], row = pos[1])
    valid_point?(col, row)
    at(col, row) == @miss_symbol
  end

  # In problem 0301, the grid repeats infinitely to the right. We can treat
  # this like wrapping round. This may all need ripping out for something more
  # general later.
  #
  def move!(across = move[0], down = move[1])
    new_pos = [pos[0] + across, pos[1] + down]
    valid_point?(new_pos[0], new_pos[1])
    @pos = new_pos
  rescue OutsideGridX
    @pos = [new_pos[0] % width, new_pos[1]]
  end
end

class OutsideGridFail < RuntimeError; end

class OutsideGridX < RuntimeError; end

class OutsideGridY < RuntimeError; end

class TestGrid < Minitest::Test
  attr_reader :c

  def setup
    @c = Grid.new(sample_data, move: [3, 1])
  end

  def test_width
    assert_equal(4, c.width)
  end

  def test_height
    assert_equal(3, c.height)
  end

  def test_at
    assert_equal('.', c.at(0, 0))
    assert_equal('#', c.at(3, 0))
    assert_equal('#', c.at(0, 1))
    assert_equal('.', c.at(0, 2))
    assert_raises(OutsideGridX) { c.at(5, 2) }
  end

  def test_hit?
    assert c.hit?(0, 1)
    refute c.hit?(2, 2)
    refute c.hit?(0, 0)
    assert_raises(OutsideGridX) { c.hit?(5, 2) }
  end

  def test_miss?
    assert c.miss?(0, 0)
    assert c.miss?(2, 2)
    refute c.miss?(0, 1)
    assert_raises(OutsideGridY) { c.miss?(0, 9) }
    assert_raises(OutsideGridFail) { c.miss?(0, -1) }
  end

  def test_valid_point?
    assert c.valid_point?(0, 0)
    assert c.valid_point?(3, 2)
    assert_raises(OutsideGridFail) { c.valid_point?(0, -1) }
    assert_raises(OutsideGridY) { c.valid_point?(3, 3) }
    assert_raises(OutsideGridX) { c.valid_point?(4, 0) }
  end

  def sample_data
    [%w[. . # #],
     %w[# . . .],
     %w[. # . .]]
  end

  def test_move!
    assert_equal([0, 0], c.pos)
    c.move!
    assert_equal([3, 1], c.pos)
  end

  def test_move_and_hit
    assert c.miss?
    c.move!(0, 1)
    assert c.hit?
    c.move!(2, 1)
    assert c.miss?
    c.move!(-1, 0)
    assert c.hit?
    assert_raises(OutsideGridY) { c.move!(0, 10) }
  end

  def test_map_wrap1
    assert_equal([0, 0], c.pos)
    c.move!(2, 0)
    assert c.hit?
    c.move!(2, 0)
    assert c.miss?
  end

  def test_map_wrap2
    assert_equal([0, 0], c.pos)
    c.move!(3, 1)
    assert c.miss?
    c.move!(3, 1)
    assert c.miss?
    assert_equal([2, 2], c.pos)
  end
end
