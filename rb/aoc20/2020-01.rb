#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

class Aoc202001
  def solve01(input)
    two_numbers_which_sum_to(2020, input.as_ints).reduce(:*)
  end

  def solve02(input)
    three_numbers_which_sum_to(2020, input.as_ints).reduce(:*)
  end

  def two_numbers_which_sum_to(value, input, _aggr = [])
    input.each { |n| return [n, value - n] if input.include?(value - n) }
  end

  # This should be done recursively, but it's very late and I'm very tired.
  # Maybe I'll do it properly tomorrow.
  #
  def three_numbers_which_sum_to(value, input)
    input.each do |n|
      number_remaining = value - n
      elements_remaining = input.reject { |v| v == n }

      elements_remaining.each do |p|
        number_now_remaining = number_remaining - p
        next unless elements_remaining.include?(number_now_remaining)

        return [n, p, number_now_remaining]
      end
    end
  end
end

class TestAoc202001 < MiniTest::Test
  include TestBase

  def answer01
    514_579
  end

  def answer02
    241_861_950
  end

  def sample
    <<~EOINPUT
      1721
      979
      366
      299
      675
      1456
    EOINPUT
  end
end
