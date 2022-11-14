#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative '../lib/base'

# https://adventofcode.com/2015/day/16
#
class Aoc201516
  GTS = %w[cats trees].freeze
  LTS = %w[pomeranians goldfish].freeze

  def solve01(input)
    t = ticker
    parse(input).select { |_s, p| suitable?(p, t) }.keys.first
  end

  def solve02(input)
    t = ticker
    parse(input).select { |_s, p| suitable02?(p, t) }.keys.first
  end

  def suitable?(props, ticker)
    props.all? { |k, v| ticker.fetch(k) == v }
  end

  def suitable02?(props, ticker)
    props.each do |k, v|
      suesval = ticker.fetch(k)

      if GTS.include?(k)
        return false if suesval > v
      elsif LTS.include?(k)
        return false if suesval <= v
      elsif suesval != nil?
        return false if suesval != v
      end
    end

    true
  end

  def parse(input)
    input.lines.to_h do |l|
      sue, props = l.split(': ', 2)

      props = props.split(', ').to_h do |p|
        k, v = p.split(': ')
        [k, v.to_i]
      end

      [sue.split.last.to_i, props]
    end
  end

  def ticker
    raw_ticker.lines.to_h do |l|
      k, v = l.split(': ')
      [k, v.to_i]
    end
  end

  def raw_ticker
    <<~EOTICKER
      children: 3
      cats: 7
      samoyeds: 2
      pomeranians: 3
      akitas: 0
      vizslas: 0
      goldfish: 5
      trees: 3
      cars: 2
      perfumes: 1
    EOTICKER
  end
end

class TestAoc201516 < MiniTest::Test
  include TestBase

  def test_suitable?
    refute @c.suitable?({ 'children' => 1, 'cars' => 8, 'vizslas' => 7 }, @c.ticker)
    assert @c.suitable?({ 'children' => 3, 'cars' => 2, 'vizslas' => 0 }, @c.ticker)
  end

  def test_suitable02?
    # refute @c.suitable02?({"children"=>3, "cats"=>7, "vizslas"=>7}, @c.ticker)
    assert @c.suitable02?({ 'children' => 3, 'cats' => 8, 'vizslas' => 0 }, @c.ticker)
  end
end
