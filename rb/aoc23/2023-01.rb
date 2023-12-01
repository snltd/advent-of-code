#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2023/day/01
#
class Aoc202301
  NUMS = (1..9).to_a.map(&:to_s)

  def solve01(input)
    input.as_lines.sum { |l| "#{first_num(l)}#{last_num(l)}".to_i }
  end

  def solve02(input)
    input.as_lines.sum { |l| nums02(l) }
  end

  private

  def number
    { 'one' => 1,
      'two' => 2,
      'three' => 3,
      'four' => 4,
      'five' => 5,
      'six' => 6,
      'seven' => 7,
      'eight' => 8,
      'nine' => 9 }
  end

  def nums02(line)
    first = first_num(line.sub(/one|two|three|four|five|six|seven|eight|nine/, number))

    l = line.gsub(/(.*)(one|two|three|four|five|six|seven|eight|nine)(.*)/) do
      ::Regexp.last_match(1) + number[::Regexp.last_match(2)].to_s + ::Regexp.last_match(3)
    end

    "#{first}#{last_num(l)}".to_i
  end

  def first_num(str)
    str.chars.find { |c| NUMS.include?(c) }
  end

  def last_num(str)
    first_num(str.reverse)
  end
end

class TestAoc202301 < Minitest::Test
  include TestBase

  def answer01
    142
  end

  def answer02
    281
  end

  def sample01
    <<~EOSAMPLE
      1abc2
      pqr3stu8vwx
      a1b2c3d4e5f
      treb7uchet
    EOSAMPLE
  end

  def sample02
    <<~EOSAMPLE
      two1nine
      eightwothree
      abcone2threexyz
      xtwone3four
      4nineeightseven2
      zoneight234
      7pqrstsixteen
    EOSAMPLE
  end
end
