#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# Each item of input looks like '1-3 a: abcde'. The fields are a range, a
# letter, and a string. The number of times the letter appears in the string
# must be in the range.
#
class Aoc202002
  def solve01(input)
    processed_input(input).count do |row|
      row[:range].include?(row[:password].count(row[:letter]))
    end
  end

  def processed_input(input)
    input.as_lines.map do |row|
      range, letter, password = row.split(/[\s:]+/)

      { letter:,
        range: Range.new(*range.split('-').to_i),
        password: }
    end
  end

  def solve02(input)
    input.as_lines.map { |r| parse(r) }.count { |item| valid?(item) }
  end

  def valid?(item)
    item[:positions].count do |p|
      in_pos?(item[:letter], item[:password], p)
    end == 1
  end

  def in_pos?(letter, string, offset)
    letter == string[offset - 1]
  end

  def parse(raw)
    range, letter, password = raw.split(/[\s:]+/)

    { letter:,
      positions: range.split('-').to_i,
      password: }
  end
end

class TestAoc202002 < Minitest::Test
  include TestBase

  def answer01
    2
  end

  def ganswer02
    1
  end

  def sample
    <<~EOINPUT
      1-3 a: abcde
      1-3 b: cdefg
      2-9 c: ccccccccc
    EOINPUT
  end

  def test_parse
    assert_equal(
      { letter: 'a',
        positions: [1, 3],
        password: 'abcde' },
      @c.parse('1-3 a: abcde')
    )
  end

  def test_in_pos?
    assert @c.in_pos?('a', 'abc', 1)
    refute @c.in_pos?('b', 'abc', 1)
  end

  def test_valid?
    assert @c.valid?(@c.parse('1-3 a: abcde'))
    refute @c.valid?(@c.parse('1-3 b: cdefg'))
    refute @c.valid?(@c.parse('2-9 c: ccccccccc'))
  end
end
