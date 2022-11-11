# frozen_string_literal: true

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
