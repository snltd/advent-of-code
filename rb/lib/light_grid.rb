
# The grid is represented as a single flat array, so a 3 x 3 grid looks like
#
#     0 1 2
#   +------
# 0 | 0 1 2
# 1 | 3 4 5
# 2 | 6 7 8
#
class LightGrid
  attr_accessor :grid

  def initialize(width, height)
    @width = width
    @height = height
    @points = width * height
    @grid = Array.new(@points, 0)
  end

  def play_input(input)
    input.as_lines.each do |i|
      nums = i.match(/(\d+,\d+) .* (\d+,\d+)/)
      p = points(nums[1], nums[2])

      if i.start_with?('toggle')
        toggle(p)
      elsif i.start_with?('turn on')
        on(p)
      elsif i.start_with?('turn off')
        off(p)
      end
    end

    count
  end

  def points(top_left, bottom_right)
    x1, y1 = top_left.split(',').map(&:to_i)
    x2, y2 = bottom_right.split(',').map(&:to_i)
    row_length = x2 - x1

    y1.upto(y2).with_object([]) do |y, ret|
      row_start = x1 + @width * y
      row_start.upto(row_start + row_length).each { |p| ret.<< p }
    end
  end


  def vals(points)
    points.map { |p| @grid[p] }
  end

  def neighbours(point)
    ret = []

    p = point + 1 # one to the right
    ret.<< p if same_row?(p, point)

    p = point - 1 # one to the left
    ret.<< p if same_row?(p, point)

    p = point - @width # immediately above
    ret.<< p if adjacent_row?(p, point)

    p = point + @width # immediately below
    ret.<< p if adjacent_row?(p, point)

    p = point - @width - 1 # up and left
    ret.<< p if adjacent_row?(p, point)

    p = point - @width + 1
    ret.<< p if adjacent_row?(p, point)

    p = point + @width - 1
    ret.<< p if adjacent_row?(p, point)

    p = point + @width + 1
    ret.<< p if adjacent_row?(p, point)

    ret.reject { |p| p < 0 || p >= @points }
  end

  def to_s
    "\n" + @grid.each_slice(@width).map do |row|
      row.map { |r| r.zero? ? '.' : '#' }.join
    end.join("\n") + "\n"
  end

  def count
    @grid.count { |n| n == 1 }
  end

  private

  def same_row?(point1, point2)
    point1.div(@width) == point2.div(@width)
  end

  def adjacent_row?(point1, point2)
    (point1.div(@width) - point2.div(@width)).abs == 1
  end
end
