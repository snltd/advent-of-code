#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

class Aoc202010
  def solve01(input)
    input = input.as_ints
    diffs01(input, 1) * diffs01(input, 3)
  end

  # I couldn't solve this on my own. It turns out there's this thing called
  # the Tribonacci Sequence, which tells you how many combinations of adapters
  # can make up a given step in joltage. This was no fun at all, and reminded
  # me that I am just a dumb-ass sys-admin. All I did here was implement the
  # steps of someone else's algorithm.
  #
  def solve02(input)
    input = input.as_ints
    run_lengths(diffs02(input)).map { |i| tribonacci_sequence[i] }.reduce(:*)
  end

  # Brackets @list with 0 (the joltage of the outlet) and the highest joltage
  # + 3 (the input of the device)
  # @return the number of steps in @list equal to @diff
  #
  def diffs01(list, diff)
    list += [0, list.max + 3]
    list.sort.each_cons(2).count { |a, b| b - a == diff }
  end

  private

  def tribonacci_sequence
    [0, 1, 2, 4, 7, 13]
  end

  # Make a list of all the differences between consecutive elements of the
  # sorted input. The actual values don't matter, only the runs of consecutive
  # numbers.
  #
  def diffs02(list)
    list += [0, list.max + 3]
    list.sort.each_cons(2).with_object([]) { |(a, b), aggr| aggr << (b - a) }
  end

  # Given a list of numbers like [3, 1, 1, 3, 1, 1], return a list of the
  # lengths of the runs of 1s.  The input only produces gaps of 1 or 3.
  # Apparently this solution wouldn't work if it didn't, but don't ask me to
  # explain why.
  #
  def run_lengths(list)
    list.join.split(/3+/).map(&:size)
  end
end

class TestAoc202010 < Minitest::Test
  include TestBase

  def answer01
    220
  end

  def answer02
    19_208
  end

  def test_diffs01
    assert_equal(5, @c.diffs01([1, 2, 5, 6, 7, 8], 1))
    assert_equal(7, @c.diffs01(little_example, 1))
    assert_equal(5, @c.diffs01(little_example, 3))
    assert_equal(22, @c.diffs01(sample.as_ints, 1))
    assert_equal(10, @c.diffs01(sample.as_ints, 3))
  end

  def little_example
    [16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4]
  end

  def sample
    <<~EOSAMPLE
      28
      33
      18
      42
      31
      14
      46
      20
      48
      47
      24
      23
      49
      45
      19
      38
      39
      11
      1
      32
      25
      35
      8
      17
      7
      9
      4
      2
      34
      10
      3
    EOSAMPLE
  end
end
