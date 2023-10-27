#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2016/day/8
# Day 8: Two-Factor Authentication
#
class Aoc201608
  def solve01(input)
    display = Display.new
    input.as_lines.each { |l| display.cmd(l) }
    display.state.count { |c| c == true }
  end

  def solve02(input)
    display = Display.new
    input.as_lines.each { |l| display.cmd(l) }
    puts display.show
  end
end

class Display
  attr_reader :state

  # State goes in a single array
  def initialize(width = 50, height = 6)
    @width = width
    @height = height
    @cells = width * height
    @state = Array.new(@cells)
  end

  def cmd(command)
    args = command.split

    case args.first
    when 'rect'
      rect(*args.last.split('x').map(&:to_i))
    when 'rotate'
      num = args[2].split('=').last.to_i
      offset = args.last.to_i

      case args[1]
      when 'column'
        rotate_column(num, offset)
      when 'row'
        rotate_row(num, offset)
      end
    end
  end

  def rect(wide, tall)
    (0...tall).each do |row|
      (row * @width).upto((row * @width) + wide - 1).each { |n| @state[n] = true }
    end
  end

  def rotate_column(num, offset)
    n_end = num + (@width * (@height - 1))
    range = Range.new(num, n_end).step(@width)
    rotate_array!(range, @height - offset)
  end

  def rotate_row(num, offset)
    n_start = num * @width
    n_end = n_start + @width - 1

    range = Range.new(n_start, n_end)
    rotate_array!(range, @width - offset)
  end

  def rotate_array!(range, amount)
    row = range.map { |i| @state[i] }
    rotated = row.rotate(amount)
    range.map.with_index { |r, i| @state[r] = rotated[i] }
  end

  def show
    @state.each_slice(@width).map do |row|
      row.map { |c| c.nil? ? '.' : '#' }.join
    end.join("\n")
  end
end

class TestDisplay < Minitest::Test
  def test_example
    d = Display.new(7, 3)

    expected = <<~EODISPLAY
      ###....
      ###....
      .......
    EODISPLAY

    d.cmd('rect 3x2')
    assert_equal(expected.strip, d.show)

    expected = <<~EODISPLAY
      #.#....
      ###....
      .#.....
    EODISPLAY

    d.cmd('rotate column x=1 by 1')
    assert_equal(expected.strip, d.show)

    expected = <<~EODISPLAY
      ....#.#
      ###....
      .#.....
    EODISPLAY

    d.cmd('rotate row y=0 by 4')
    assert_equal(expected.strip, d.show)

    expected = <<~EODISPLAY
      .#..#.#
      #.#....
      .#.....
    EODISPLAY

    d.cmd('rotate column x=1 by 1')
    assert_equal(expected.strip, d.show)
  end
end
