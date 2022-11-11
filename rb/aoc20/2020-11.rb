#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/base'

class Aoc202011
  def solve01(input)
    solver(input, 4, SeatMap)
  end

  def solve02(input)
    solver(input, 5, SeatMap2)
  end

  def solver(input, tolerence, mapper)
    last_map = mapper.new(input.as_raw_char_grid, tolerence).iterate

    1000.times do
      new_map = mapper.new(last_map, tolerence).iterate
      return new_map.flatten.count('#') if new_map == last_map

      last_map = new_map
    end
  end
end

class TestAoc202011 < MiniTest::Test
  include TestBase

  def answer01
    37
  end

  def answer02
    26
  end

  def sample
    SAMPLE_INPUT
  end
end

class SeatMap
  attr_reader :raw

  FLOOR = '.'
  OCCUPIED = '#'
  EMPTY = 'L'

  def initialize(input, tolerence = 4)
    @tolerence = tolerence
    @raw = input
  end

  def iterate
    raw.map.with_index do |row, y|
      row.map.with_index { |_col, x| apply_rules(x, y) }
    end
  end

  def apply_rules(x, y)
    return FLOOR if floor?(x, y)

    occupied_around = occupied(adjacent_to(x, y))

    if occupied?(x, y)
      occupied_around >= @tolerence ? EMPTY : OCCUPIED
    else
      occupied_around.zero? ? OCCUPIED : EMPTY
    end
  end

  # @return [Array] state of seats around given coordinate, left-to-right,
  # top-to-bottom.
  #
  def adjacent_to(x, y)
    all = adjacent.map { |ax, ay| [x + ax, y + ay] }
    all.select { |nx, ny| on_map?(nx, ny) }
  end

  def adjacent
    [[-1, -1], [0, -1], [1, -1],
     [-1, 0], [1, 0],
     [-1, 1], [0, 1], [1, 1]]
  end

  # @return [Integer] how many seats in the given list are occupied
  #
  def occupied(seats)
    seats.count { |x, y| occupied?(x, y) }
  end

  def occupied?(x, y)
    @raw[y][x] == OCCUPIED
  end

  def on_map?(x, y)
    x >= 0 && y >= 0 && x < raw.first.size && y < raw.size
  end

  def floor?(x, y)
    @raw[y][x] == FLOOR
  end
end

# An extension of the original SeatMap class, applying slightly different
# rules
#
class SeatMap2 < SeatMap
  def apply_rules(x, y)
    return FLOOR if floor?(x, y)

    visible_occupied = occupied(visible_from(x, y))

    if occupied?(x, y)
      visible_occupied >= 5 ? EMPTY : OCCUPIED
    else
      visible_occupied.zero? ? OCCUPIED : EMPTY
    end
  end

  # @return the coordinates of all seats in the line of sight from the given
  # coordinate.
  #
  def visible_from(x, y)
    adjacent.filter_map { |dx, dy| first_in_line_of_sight(x, y, dx, dy) }
  end

  def first_in_line_of_sight(x, y, dx, dy)
    px = x + dx
    py = y + dy
    return nil unless on_map?(px, py)

    return [px, py] unless floor?(px, py)

    first_in_line_of_sight(px, py, dx, dy)
  end
end

class TestSeatMap < Minitest::Test
  def setup
    input = SAMPLE_INPUT.as_raw_char_grid
    @c = SeatMap.new(input)
  end

  def test_iterate
    actual = @c.iterate

    SEAT_MAP_TEST_STEPS.each do |expected|
      assert_equal(expected.delete(' '), stringify(actual))
      actual = SeatMap.new(actual).iterate
    end
  end

  def stringify(seatmap)
    seatmap.map(&:join).join("\n")
  end

  def test_adjacent_to
    assert_equal([[1, 1], [2, 1], [3, 1],
                  [1, 2], [3, 2],
                  [1, 3], [2, 3], [3, 3]], @c.adjacent_to(2, 2))

    assert_equal([[1, 0], [0, 1], [1, 1]], @c.adjacent_to(0, 0))
  end

  def test_on_map?
    assert @c.on_map?(0, 0)
    assert @c.on_map?(4, 2)
    assert @c.on_map?(9, 9)
    refute @c.on_map?(-1, 0)
    refute @c.on_map?(10, 0)
    refute @c.on_map?(1, 10)
  end

  def test_occupied
    c = SeatMap.new([%w[# . L],
                     %w[. L #],
                     %w[. # #]])

    assert_equal(4, c.occupied(c.adjacent_to(1, 1)))
  end

  def test_occupied?
    c = SeatMap.new([%w[# . L], %w[. # #]])
    assert c.occupied?(0, 0)
    assert c.occupied?(2, 1)
    refute c.occupied?(1, 0)
    refute c.occupied?(2, 0)
  end
end

SAMPLE_INPUT = <<~EOSAMPLE
  L.LL.LL.LL
  LLLLLLL.LL
  L.L.L..L..
  LLLL.LL.LL
  L.LL.LL.LL
  L.LLLLL.LL
  ..L.L.....
  LLLLLLLLLL
  L.LLLLLL.L
  L.LLLLL.LL
EOSAMPLE

SEAT_MAP_TEST_STEPS = [
  '#.##.##.##
   #######.##
   #.#.#..#..
   ####.##.##
   #.##.##.##
   #.#####.##
   ..#.#.....
   ##########
   #.######.#
   #.#####.##',

  '#.LL.L#.##
   #LLLLLL.L#
   L.L.L..L..
   #LLL.LL.L#
   #.LL.LL.LL
   #.LLLL#.##
   ..L.L.....
   #LLLLLLLL#
   #.LLLLLL.L
   #.#LLLL.##',

  '#.##.L#.##
   #L###LL.L#
   L.#.#..#..
   #L##.##.L#
   #.##.LL.LL
   #.###L#.##
   ..#.#.....
   #L######L#
   #.LL###L.L
   #.#L###.##',

  '#.#L.L#.##
   #LLL#LL.L#
   L.L.L..#..
   #LLL.##.L#
   #.LL.LL.LL
   #.LL#L#.##
   ..L.L.....
   #L#LLLL#L#
   #.LLLLLL.L
   #.#L#L#.##',

  '#.#L.L#.##
   #LLL#LL.L#
   L.#.L..#..
   #L##.##.L#
   #.#L.LL.LL
   #.#L#L#.##
   ..L.L.....
   #L#L##L#L#
   #.LLLLLL.L
   #.#L#L#.##'
].freeze
