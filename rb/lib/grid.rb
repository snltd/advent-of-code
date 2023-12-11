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
  attr_accessor :grid, :width, :height, :points, :cursor

  def initialize(grid)
    raw = grid.as_lines

    @width = raw.first.size
    @height = raw.size
    @points = @width * @height
    @grid = populate_with(grid)
  end

  def each_point
    0.upto(@points)
  end

  def at(index)
    @grid[index]
  end

  # Overload if you need to make them ints or something
  #
  def populate_with(grid)
    grid.as_lines.map(&:chars).flatten
  end

  def val_at(point)
    @grid[point]
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
    @grid.each_with_index { |p, i| ret << i if p == val }
    ret
  end

  # Neighbours of the given point when you can move N E S W
  #
  def neighbours4(point)
    ret = []

    p = right(point)
    ret << p if same_row?(p, point)

    p = left(point)
    ret << p if same_row?(p, point)

    p = up(point)
    ret << p if adjacent_row?(p, point)

    p = down(point)
    ret << p if adjacent_row?(p, point)

    ret.reject { |q| q.negative? || q >= @points }
  end

  # Neighbours of the given point when you can move in eight directions
  #
  def neighbours8(point)
    ret = neighbours4(point)

    p = up_left(point)
    ret << p if adjacent_row?(p, point)

    p = up_right(point)
    ret << p if adjacent_row?(p, point)

    p = down_left(point)

    ret << p if adjacent_row?(p, point)

    p = down_right(point)
    ret << p if adjacent_row?(p, point)

    ret.reject { |q| q.negative? || q >= @points }
  end

  # @return [Integer] the point immediately right of the given point
  #
  def right(point)
    point + 1
  end

  # @return [Integer] the point immediately left of the given point
  #
  def left(point)
    point - 1
  end

  # @return [Integer] the point immediately above the given point
  #
  def up(point)
    point - @width
  end

  # @return [Integer] the point immediately below the given point
  #
  def down(point)
    point + @width
  end

  # @return [Integer] the point diagonally up and left from the given point
  #
  def up_left(point)
    point - @width - 1
  end

  # @return [Integer] the point diagonally up and right from the given point
  #
  def up_right(point)
    point - @width + 1
  end

  # @return [Integer] the point diagonally down and left from the given point
  #
  def down_left(point)
    point + @width - 1
  end

  # @return [Integer] the point diagonally down and right from the given point
  #
  def down_right(point)
    point + @width + 1
  end

  # @return [Array[Integer, Integer]] x-y coords of the given point, where
  # [0,0] is top left.
  #
  def x_y(point)
    x = point.remainder(@width)
    y = point.div(@width)
    [x, y]
  end

  # @return [Integer] point from the given x-y coords, where [0,0] is top
  # left.
  #
  def from_x_y(point)
    x, y = point
    (y * @width) + x
  end

  # @return [Enumerator] of the cells from the given point (not inclusive)
  # until the end of the row
  #
  def to_end_of_row(point)
    (point + 1).upto((point.div(@width) * @width) + @width - 1)
  end

  # @return [Enumerator] of the values in the cells from the given point (not
  # inclusive) until the end of the row
  def vals_to_end_of_row(point)
    @grid[(point + 1)..((point.div(@width) * @width) + @width - 1)]
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
