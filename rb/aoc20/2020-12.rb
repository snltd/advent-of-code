#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

class Aoc202012
  def solve01(input)
    nav = Navigator.new(input.as_lines)
    nav.parse
    nav.manhattan_distance
  end

  def solve02(input)
    nav = WaypointNavigator.new(input.as_lines)
    nav.parse
    nav.manhattan_distance
  end
end

class TestAoc202012 < MiniTest::Test
  include TestBase

  def answer01
    25
  end

  def answer02
    286
  end

  def sample
    <<~EOINPUT
      F10
      N3
      F7
      R90
      F11
    EOINPUT
  end
end

# Start at [0, 0] which is in the middle of an imaginary grid. Going north
# increases the y value, going east increases x.
#
class Navigator
  attr_reader :raw, :pos, :bearing

  EAST = [1, 0].freeze
  SOUTH = [0, -1].freeze
  WEST = [-1, 0].freeze
  NORTH = [0, 1].freeze

  def initialize(input = [])
    @raw = input
    @pos = [0, 0]
    @bearing = EAST
  end

  def parse
    raw.each do |instruction|
      direction = instruction[0].downcase
      magnitude = instruction[1..].to_i
      send("go_#{direction}", magnitude)
    end
  end

  def manhattan_distance
    pos.sum(&:abs)
  end

  def go_n(magnitude)
    x, y = pos
    @pos = [x, y + magnitude]
  end

  def go_e(magnitude)
    x, y = pos
    @pos = [x + magnitude, y]
  end

  def go_s(magnitude)
    x, y = pos
    @pos = [x, y - magnitude]
  end

  def go_w(magnitude)
    x, y = pos
    @pos = [x - magnitude, y]
  end

  def go_f(magnitude)
    x, y = pos
    bx, by = bearing
    @pos = [x + (bx * magnitude), y + (by * magnitude)]
  end

  def go_l(degrees)
    current = bearings.index(@bearing)
    @bearing = bearings[(current - (degrees / 90)) % 4]
  end

  def go_r(degrees)
    go_l(360 - degrees)
  end

  def bearings
    [NORTH, EAST, SOUTH, WEST]
  end
end

class TestNavigator < MiniTest::Test
  attr_reader :c

  EAST = [1, 0].freeze
  SOUTH = [0, -1].freeze
  WEST = [-1, 0].freeze
  NORTH = [0, 1].freeze

  def setup
    @c = Navigator.new
  end

  def test_go_r
    assert_equal(EAST, c.bearing)
    c.go_r(180)
    assert_equal(WEST, c.bearing)
    c.go_r(90)
    assert_equal(NORTH, c.bearing)
    c.go_r(270)
    assert_equal(WEST, c.bearing)
    c.go_r(270)
    assert_equal(SOUTH, c.bearing)
  end

  def test_go_l
    assert_equal(EAST, c.bearing)
    c.go_l(90)
    assert_equal(NORTH, c.bearing)
    c.go_l(180)
    assert_equal(SOUTH, c.bearing)
    c.go_l(270)
    assert_equal(WEST, c.bearing)
    c.go_l(360)
    assert_equal(WEST, c.bearing)
  end
end

# Start at [0, 0] which is in the middle of an imaginary grid. Going north
# increases the y value, going east increases x.
#
class WaypointNavigator
  attr_reader :raw, :waypoint_pos, :ship_pos, :bearing

  def initialize(input = [])
    @raw = input
    @ship_pos = [0, 0]
    @waypoint_pos = [10, 1] # relative to the ship
  end

  def parse
    raw.each do |instruction|
      direction = instruction[0].downcase
      magnitude = instruction[1..].to_i
      send("go_#{direction}", magnitude)
    end
  end

  def manhattan_distance
    ship_pos.sum(&:abs)
  end

  def go_n(magnitude)
    x, y = waypoint_pos
    @waypoint_pos = [x, y + magnitude]
  end

  def go_e(magnitude)
    x, y = waypoint_pos
    @waypoint_pos = [x + magnitude, y]
  end

  def go_s(magnitude)
    x, y = waypoint_pos
    @waypoint_pos = [x, y - magnitude]
  end

  def go_w(magnitude)
    x, y = waypoint_pos
    @waypoint_pos = [x - magnitude, y]
  end

  def go_f(magnitude)
    wx, wy = waypoint_pos
    sx, sy = ship_pos

    @ship_pos = [sx + (wx * magnitude), sy + (wy * magnitude)]
  end

  def go_l(degrees)
    x, y = waypoint_pos

    @waypoint_pos = case degrees
                    when 90
                      [-y, x]
                    when 180
                      [-x, -y]
                    when 270
                      [y, -x]
                    end
  end

  def go_r(degrees)
    go_l(360 - degrees)
  end
end
