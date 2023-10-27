#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/base'

class Aoc202007
  attr_reader :bag_map

  WANTED = 'shiny gold'

  def solve01(input)
    setup_data_stores(input)
    to_solve = bag_map.reject { |bag| bag == WANTED }

    expanded = to_solve.map do |bag, _how_many|
      e = expand01(bag)
      @expanded[bag] = e
      e
    end

    expanded.count { |e| e.include?(WANTED) }
  end

  def solve02(input)
    setup_data_stores(input)
    expand02(WANTED).size - 1
  end

  def setup_data_stores(input)
    @bag_map = input.as_lines.to_h { |bag| process_bag(bag) }
    @expanded = {} # cache things we've already worked out
  end

  def process_bag(line)
    bag_style, contents = line.gsub(/(bags?)|\./, '').split('contain')
    [bag_style.strip, hashified_contents(contents)]
  end

  def hashified_contents(contents)
    contents.split(',').to_h do |c|
      num, bag = c.strip.split(/\s+/, 2)
      [bag, num.to_i]
    end
  end

  def expand01(bag)
    aggr = [bag]

    return aggr if bag == WANTED || !@bag_map.key?(bag)

    return @expanded[bag] if @expanded.key?(bag)

    @bag_map[bag].each do |colour, how_many|
      aggr += expand01(colour) unless how_many.zero?
    end

    aggr.uniq
  end

  def expand02(bag)
    aggr = [bag]

    return aggr unless @bag_map.key?(bag)

    @bag_map[bag].each do |colour, how_many|
      how_many.times { aggr += expand02(colour) }
    end

    aggr
  end
end

class TestAoc202007 < Minitest::Test
  include TestBase

  def answer01
    4
  end

  def answer02
    32
  end

  def sample
    <<~EOSAMPLE
      light red bags contain 1 bright white bag, 2 muted yellow bags.
      dark orange bags contain 3 bright white bags, 4 muted yellow bags.
      bright white bags contain 1 shiny gold bag.
      muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
      shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
      dark olive bags contain 3 faded blue bags, 4 dotted black bags.
      vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
      faded blue bags contain no other bags.
      dotted black bags contain no other bags.
    EOSAMPLE
  end

  def test_process_bag
    assert_equal(
      ['light red', { 'bright white' => 1, 'muted yellow' => 2 }],
      @c.process_bag(
        'light red bags contain 1 bright white bag, 2 muted yellow bags.'
      )
    )
  end
end
