#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2023/day/02
#
class Aoc202302
  LIMIT = {
    red: 12,
    green: 13,
    blue: 14
  }.freeze

  def solve01(input)
    input.as_lines.map { |r| parsed(r) }
         .select { |l| l[:games].all? { |g| good_game(g) } }
         .sum { |p| p[:game_id] }
  end

  def solve02(input)
    input.as_lines.map { |r| parsed(r) }
         .map { |l| LIMIT.keys.to_h { |col| [col, l[:games].filter_map { |g| g[col] }.max] } }
         .sum { |g| g.values.inject(:*) }
  end

  private

  def good_game(game)
    LIMIT.all? { |l_col, l_num| game.fetch(l_col, 0) <= l_num }
  end

  def parsed(line)
    id, games = line.split(': ')
    { game_id: id.split.last.to_i,
      games: games.split('; ').map { |g| game_to_hash(g) } }
  end

  def game_to_hash(game)
    game.split(', ').to_h do |g|
      num, col = g.split
      [col.to_sym, num.to_i]
    end
  end
end

class TestAoc202302 < Minitest::Test
  include TestBase

  def answer01
    8
  end

  def answer02
    2286
  end

  def sample
    <<~EOSAMPLE
      Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
      Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
      Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
      Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
      Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
    EOSAMPLE
  end
end
