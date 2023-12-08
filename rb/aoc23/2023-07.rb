#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2023/day/07
#
class Aoc202307
  CARDS01 = {
    '2' => 'a',
    '3' => 'b',
    '4' => 'c',
    '5' => 'd',
    '6' => 'e',
    '7' => 'f',
    '8' => 'g',
    '9' => 'h',
    'T' => 'i',
    'J' => 'j',
    'Q' => 'k',
    'K' => 'l',
    'A' => 'm'
  }.freeze

  CARDS02 = {
    'J' => 'a',
    '2' => 'b',
    '3' => 'c',
    '4' => 'd',
    '5' => 'e',
    '6' => 'f',
    '7' => 'g',
    '8' => 'h',
    '9' => 'i',
    'T' => 'j',
    'Q' => 'k',
    'K' => 'l',
    'A' => 'm'
  }.freeze

  def solve01(input)
    hands = process(input)
    ranks = hands.keys.map { |h| [h, hand(h)] }
    sorted = ranks.sort_by { |h, v| scorer(v, h, CARDS01) }.to_h
    sorted.keys.map.with_index(1) { |k, i| hands[k] * i }.sum
  end

  def solve02(input)
    hands = orig_hands = process(input)
    orig_hands = process(input)

    best_hands = hands.map { |h, b| [best_hand(h), b] }
    ranks = best_hands.map { |h, _v| [h, hand(h)] }
    to_sort = ranks.map.with_index { |(_k, v), i| [orig_hands.keys[i], v] }
    sorted = to_sort.sort_by { |h, v| scorer(v, h, CARDS02) }
    sorted.map.with_index(1) { |(k, _v), i| orig_hands[k] * i }.sum
  end

  def process(input)
    input.as_lines.to_h do |l|
      k, v = l.split
      [k.chars, v.to_i]
    end
  end

  def scorer(v, h, cards)
    "#{v}#{h.map { |l| -cards[l] }.join}"
  end

  # find the best hand for things with jokers
  #
  def best_hand(cards)
    tallies = cards.tally

    return cards unless tallies.key?('J')

    tallies.delete('J')

    target = if tallies.empty?
               'A'
             else
               tallies.max_by { |_k, v| v }.first
             end

    cards.each_index { |i| cards[i] = target if cards[i] == 'J' }
  end

  def hand(cards)
    tally = cards.tally
    uniqs = tally.size

    return 1 if uniqs == 5

    return 2 if uniqs == 4

    return 7 if uniqs == 1

    if uniqs == 3
      return tally.value?(3) ? 4 : 3
    end

    return unless uniqs == 2
    return 6 if tally.value?(4)

    5
  end
end

class TestAoc202307 < Minitest::Test
  include TestBase

  def answer01
    6440
  end

  def answer02
    5905
  end

  def sample
    <<~EOSAMPLE
      32T3K 765
      T55J5 684
      KK677 28
      KTJJT 220
      QQQJA 483
    EOSAMPLE
  end

  def test_best_hand
    assert_equal(%w[A A A A A], @c.best_hand(%w[A A A A A]))
    assert_equal(%w[A A A A A], @c.best_hand(%w[A J A J A]))
    assert_equal(%w[2 2 2 2 2], @c.best_hand(%w[2 2 J 2 J]))
  end

  def test_hand
    assert_equal(7, @c.hand(%w[A A A A A]))  # five of a kind      1
    assert_equal(6, @c.hand(%w[A A T A A]))  # four of a kind      2
    assert_equal(5, @c.hand(%w[A A T T A]))  # full house          2
    assert_equal(4, @c.hand(%w[A 4 A 1 A]))  # three of a kind     3
    assert_equal(3, @c.hand(%w[A 7 T 7 A]))  # two pair            3
    assert_equal(2, @c.hand(%w[A 1 2 A 4]))  # one pair            4
    assert_equal(1, @c.hand(%w[A 2 T 7 J]))  # high card           5
  end
end
