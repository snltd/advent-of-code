# frozen_string_literal: true

require_relative 'stdlib/string'

# The grid is represented as a single flat array, so a 3 x 3 grid looks like
#
#     0 1 2
#   +------
# 0 | 0 1 2
# 1 | 3 4 5
# 2 | 6 7 8
#
class Grid
  attr_accessor :grid, :width, :height, :points

  def initialize(grid)
    raw = grid.as_lines

    @width = raw.first.size
    @height = raw.size
    @points = @width * @height
    @grid = populate_with(grid)
  end

  def at(index)
    @grid[index]
  end

  # Overload if you need to make them ints or something
  #
  def populate_with(grid)
    grid.as_lines.map(&:chars).flatten
  end

  # Values at the given points
  #
  def vals_of(points)
    points.map { |p| @grid[p] }
  end

  # Values at the given points with point index [p, val]
  #
  def vals_of_with_index(points)
    points.map { |p| [p, @grid[p]] }
  end

  def indices_of(val)
    ret = []
    @grid.each_with_index { |p, i| ret.<<i if p == val }
    ret
  end

  # Neighbours of the given point when you can move N E S W
  #
  def neighbours4(point)
    ret = []

    p = point + 1 # one to the right
    ret << p if same_row?(p, point)

    p = point - 1 # one to the left
    ret << p if same_row?(p, point)

    p = point - @width # immediately above
    ret << p if adjacent_row?(p, point)

    p = point + @width # immediately below
    ret << p if adjacent_row?(p, point)

    ret.reject { |q| q.negative? || q >= @points }
  end

  # Neighbours of the given point when you can move in eight directions
  #
  def neighbours8(point)
    ret = neighbours4(point)

    p = point - @width - 1 # up and left
    ret << p if adjacent_row?(p, point)

    p = point - @width + 1
    ret << p if adjacent_row?(p, point)

    p = point + @width - 1
    ret << p if adjacent_row?(p, point)

    p = point + @width + 1
    ret << p if adjacent_row?(p, point)

    ret.reject { |q| q.negative? || q >= @points }
  end

  def to_s
    "\n#{@grid.each_slice(@width).map(&:join).join("\n")}\n"
  end

  def all_points
    0...@points
  end

  def all_vals
    vals_of(all_points)
  end

  def all_vals_with_index
    vals_of_with_index(all_points)
  end

  private

  def same_row?(point1, point2)
    point1.div(@width) == point2.div(@width)
  end

  def adjacent_row?(point1, point2)
    (point1.div(@width) - point2.div(@width)).abs == 1
  end
end
