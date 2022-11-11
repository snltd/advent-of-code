#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2015/day/1
#
class Aoc201508
  def solve01(input)
    literals = chars = 0

    input.each_line do |l|
      literals += l.size
      chars += clean(l)
    end

    literals - chars
  end

  def solve02(input)
    input.lines.sum do |l|
      encode(l).length - l.length
    end
  end

  private

  def clean(line)
    line[1..-2]
      .strip
      .gsub(/\\\\/, 'B')
      .gsub(/\\"/, 'Q')
      .gsub(/\\x../, 'X')
      .size
  end

  def encode(line)
    "\"#{line.gsub('\\', '\\\\\\').gsub('"', '\"')}\""
  end
end

# Tests
#
class TestAoc201508 < MiniTest::Test
  include TestBase

  def table01
    {
      '""': 2,
      '"abc"': 2,
      '"aaa\"aaa"': 3,
      '"\x27"': 5
    }
  end

  def table02
    {
      '""': 4,
      '"abc"': 4,
      '"aaa\"aaa"': 6,
      '"\x27"': 5
    }
  end
end
