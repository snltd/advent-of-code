#!/usr/bin/env ruby

require 'minitest/autorun'
require_relative '../lib/grid'

# Tests
#
class Test < Minitest::Test
  def setup
    @g = Grid.new(sample)
  end

  def test_dimensions
    assert_equal(4, @g.width)
    assert_equal(4, @g.height)
    assert_equal(16, @g.points)
  end

  def test_vals_of
    assert_equal(%w[e f g h], @g.vals_of([4, 5, 6, 7]))
  end

  def test_vals_of_with_index
    assert_equal([[9, 'j'], [10, 'k']], @g.vals_of_with_index([9, 10]))
  end

  def test_neighbours4
    assert_equal([1, 4], @g.neighbours4(0))
    assert_equal([1, 4, 6, 9], @g.neighbours4(5).sort)
    assert_equal([11, 14], @g.neighbours4(15).sort)
  end

  def test_neighbours8
    assert_equal([1, 4, 5], @g.neighbours8(0))
    assert_equal([0, 1, 2, 4, 6, 8, 9, 10], @g.neighbours8(5).sort)
    assert_equal([10, 11, 14], @g.neighbours8(15).sort)
  end

  def test_indices_of
    assert_equal([6], @g.indices_of('g'))
  end

  def test_x_y
    assert_equal([0, 0], @g.x_y(0))
    assert_equal([2, 0], @g.x_y(2))
    assert_equal([3, 3], @g.x_y(15))
  end

  def test_from_x_y
    assert_equal(0, @g.from_x_y([0, 0]))
    assert_equal(2, @g.from_x_y([2, 0]))
    assert_equal(15, @g.from_x_y([3, 3]))
  end

  def test_to_end_of_row
    assert_empty(@g.to_end_of_row(7).to_a)
    assert_equal([5, 6, 7], @g.to_end_of_row(4).to_a)
    assert_equal([14, 15], @g.to_end_of_row(13).to_a)
  end

  def test_vals_to_end_of_row
    assert_empty(@g.vals_to_end_of_row(7).to_a)
    assert_equal(%w[f g h], @g.vals_to_end_of_row(4).to_a)
    assert_equal(%w[o p], @g.vals_to_end_of_row(13).to_a)
  end

  def test_insert_row_before_0
    assert_equal(
      %w[A B C D a b c d e f g h i j k l m n o p],
      @g.insert_row_before(0, %w[A B C D])
    )
  end

  def test_insert_row_after_1
    assert_equal(
      %w[a b c d e f g h A B C D i j k l m n o p],
      @g.insert_row_after(1, %w[A B C D])
    )

    assert_equal(5, @g.height)
    assert_equal(4, @g.width)
    assert_equal(20, @g.points)
  end

  def test_insert_row_after_2
    @g.insert_row_after(2, %w[A B C D])

    assert_equal(
      "abcd\n" \
      "efgh\n" \
      "ijkl\n" \
      "ABCD\n" \
      'mnop',
      @g.to_s.strip
    )

    assert_equal(5, @g.height)
    assert_equal(4, @g.width)
    assert_equal(20, @g.points)
  end

  def test_insert_col_after_2
    @g.insert_col_after(2, %w[A B C D])

    assert_equal(
      "abcAd\n" \
      "efgBh\n" \
      "ijkCl\n" \
      'mnoDp',
      @g.to_s.strip
    )

    assert_equal(4, @g.height)
    assert_equal(5, @g.width)
    assert_equal(20, @g.points)
  end

  def test_insert_col_before_0
    @g.insert_col_before(0, %w[A B C D])

    assert_equal(
      "Aabcd\n" \
      "Befgh\n" \
      "Cijkl\n" \
      'Dmnop',
      @g.to_s.strip
    )

    assert_equal(4, @g.height)
    assert_equal(5, @g.width)
    assert_equal(20, @g.points)
  end

  def test_row
    assert_equal(%w[a b c d], @g.row(0))
    assert_equal(%w[e f g h], @g.row(1))
    assert_nil(@g.row(100))
  end

  def test_col
    assert_equal(%w[a e i m], @g.col(0))
    assert_equal(%w[d h l p], @g.col(3))
  end

  def test_rows
    assert_equal(4, @g.rows.size)
    assert_equal(%w[a b c d], @g.rows.first)
  end

  def test_cols
    assert_equal(4, @g.cols.size)
  end

  def test_manhattan
    a = 0
    b = 13

    assert_equal(4, @g.manhattan(a, b))
    assert_equal(4, @g.manhattan(b, a))
  end

  private

  def sample
    "abcd\n" +   # 0  1  2  3
    "efgh\n" +   # 4  5  6  7
    "ijkl\n" +   # 8  9  10 11
    'mnop'       # 12 13 14 15
  end
end
