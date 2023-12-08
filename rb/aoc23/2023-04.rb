#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2023/day/04
#
class Aoc202304
  def solve01(input)
    process_cards(input).sum do |card|
      winners = winners(card)
      winners.zero? ? 0 : double(1, winners - 1)
    end
  end

  def solve02(input)
    winners = process_cards(input).map { |c| winners(c) }.freeze
    cards = winners.map { |_w| 1 }

    cards.each_with_index do |_c, i|
      (i + 1).upto(i + winners[i]) { |w| cards[w] += cards[i] }
    end

    cards.sum
  end

  private

  def process_cards(input)
    input.as_lines.map do |l|
      _, data = l.split(': ')
      winners, nums = data.split(' | ')
      winners = winners.split.map(&:to_i).to_hash_table
      nums = nums.split.map(&:to_i)

      { winners:, nums: }
    end
  end

  def winners(card)
    card[:nums].count { |n| card[:winners].key?(n) }
  end

  def score(matches)
    matches.times { matches * 2 }
  end

  def double(num, times)
    return num if times.zero?

    double(num * 2, times - 1)
  end
end

class TestAoc202304 < Minitest::Test
  include TestBase

  def answer01
    13
  end

  def answer02
    30
  end

  def sample
    <<~EOSAMPLE
      Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
      Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
      Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
      Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
      Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
      Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
    EOSAMPLE
  end
end
