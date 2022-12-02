#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pathname'
require 'minitest/autorun'
require_relative '../../lib/stdlib/string'

INPUT_DIR = Pathname.new(__dir__).parent.parent.parent.join('test_inputs').freeze

class TestString < MiniTest::Test
  def test_as_lines
    assert_equal(%w[3 5 7 9], sample('int_list').as_lines)
    assert_equal(%w[abc def ghi], sample('word_list').as_lines)
  end

  def test_as_ints
    assert_equal([3, 5, 7, 9], sample('int_list').as_ints)
  end

  def test_as_raw_char_grid
    assert_equal(
      [%w[a b c],
       %w[d e f],
       %w[g h i]], sample('word_list').as_raw_char_grid
    )
  end

  def test_as_blocks
    assert_equal(
      %W[block0 block1\nblock1 block2],
      sample('blocks').as_blocks
    )
  end

  def test_as_int_blocks
    assert_equal([[1], [3, 4, 3], [90, 10]], sample('int_blocks').as_int_blocks)
  end

  def test_as_asm
    assert_equal(
      [[:nop, 0],
       [:acc, 3],
       [:jmp, -3]], sample('assembler').as_asm
    )
  end

  def test_as_intcode
    assert_equal([1, 2, 3, 4, 5], '1,2,3,4,5'.as_intcode)
  end

  private

  def sample(number)
    File.read(INPUT_DIR.join(number))
  end
end
