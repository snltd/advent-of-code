#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2015/day/1
# Which strings are naughty, which are nice?
#
class Aoc201505
  def solve01(input)
    input.as_lines.count { |l| nice01?(l) }
  end

  def solve02(input)
    input.as_lines.count { |l| nice02?(l) }
  end

  def nice01?(str)
    return false unless str.match?(/[aeiou].*[aeiou].*[aeiou]/)
    return false if str.squeeze == str
    return false if str.include?('ab')
    return false if str.include?('cd')
    return false if str.include?('pq')
    return false if str.include?('xy')

    true
  end

  def nice02?(str)
    x = str.chars.each_cons(2).none? do |p|
      str.match?(Regexp.new("#{p.join}.*#{p.join}"))
    end

    return false if x

    Range.new('a', 'z').any? { |l| str.match?(Regexp.new("#{l}.#{l}")) }
  end
end

# Tests
#
class TestAoc201505 < Minitest::Test
  include TestBase

  def table01
    {
      ugknbfddgicrmopn: 1,
      aaa: 1,
      jchzalrnumimnmhp: 0,
      haegwjzuvuyypxyu: 0,
      dvszwmarrgswjxmb: 0
    }
  end

  def table02
    {
      qjhvhtzxzqqjkmpb: 1,
      xxyxx: 1,
      uurcxstgmygtbstg: 0,
      ieodomkazucvgmuy: 0
    }
  end
end
