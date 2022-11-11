#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/base'

class Aoc202022
  def solve01(input)
    scores = play(input.as_blocks.map { |p| p.split("\n")[1..].map(&:to_i) })
    calculate_score(scores.flatten)
  end

  def calculate_score(scores)
    scores.reverse.map.with_index(1) { |v, i| v * i }.sum
  end

  def play(players)
    return players if players.any?(&:empty?)

    p1card = players[0].shift
    p2card = players[1].shift

    if p1card > p2card
      players[0] = players[0] + [p1card, p2card].sort.reverse
    else
      players[1] = players[1] + [p1card, p2card].sort.reverse
    end

    play(players)
  end
end

class TestAoc202022 < MiniTest::Test
  include TestBase

  def answer01
    306
  end

  def sample
    <<~EOINPUT
      Player 1:
      9
      2
      6
      3
      1

      Player 2:
      5
      8
      4
      7
      10
    EOINPUT
  end
end
